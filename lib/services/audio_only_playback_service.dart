import 'dart:async';

import 'package:better_native_video_player/better_native_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:frosty/apis/twitch_api.dart';
import 'package:frosty/apis/twitch_gql_api.dart';
import 'package:frosty/screens/settings/stores/auth_store.dart';

/// Owns the native player used by the standalone audio-only screen.
///
/// The controller intentionally outlives the Flutter page. Removing the
/// platform view unregisters the view but does not release the native player,
/// so audio can continue while the user browses elsewhere in Frosty.
class AudioOnlyPlaybackService extends ChangeNotifier {
  AudioOnlyPlaybackService._();

  static final instance = AudioOnlyPlaybackService._();
  static int _nextId = 100000;

  NativeVideoPlayerController? _controller;
  StreamSubscription<List<NativeVideoPlayerQuality>>? _qualitiesSub;
  bool _initializing = false;
  bool _audioQualitySelected = false;
  int _generation = 0;

  String? userLogin;
  String? displayName;
  String? title;
  String? artworkUrl;
  String? error;
  bool isLoading = false;
  bool isPlaying = false;
  double volume = 1;

  NativeVideoPlayerController? get controller => _controller;

  Future<void> start({
    required String login,
    required String name,
    required TwitchApi twitchApi,
    required TwitchGqlApi twitchGqlApi,
    required AuthStore authStore,
  }) async {
    if (userLogin == login && _controller != null) {
      await _controller!.play();
      isPlaying = true;
      notifyListeners();
      return;
    }

    await stop();
    final generation = ++_generation;
    userLogin = login;
    displayName = name;
    title = '正在连接直播';
    error = null;
    isLoading = true;
    isPlaying = false;
    _audioQualitySelected = false;
    notifyListeners();

    final controller = NativeVideoPlayerController(
      id: _nextId++,
      autoPlay: true,
      showNativeControls: false,
      mediaInfo: NativeVideoPlayerMediaInfo(
        title: name,
        subtitle: 'Frosty · Twitch',
      ),
    );
    _controller = controller;
    controller.addActivityListener(_onActivity);
    _qualitiesSub = controller.qualitiesStream.listen(_selectAudioQuality);

    unawaited(_loadArtwork(twitchApi, login, controller));
    unawaited(_loadStreamTitle(twitchApi, login, controller));
    try {
      _initializing = true;
      // Let the page mount the hidden platform view before the first method
      // channel call. The native player can then keep running after the view
      // is later removed from the widget tree.
      await Future<void>.delayed(const Duration(milliseconds: 80));
      await controller.initialize();
      if (generation != _generation || !identical(controller, _controller)) return;
      final authToken = authStore.gqlToken;
      final token = authToken == null
          ? await twitchGqlApi.getPlaybackAccessToken(login: login)
          : await twitchGqlApi.getPlaybackAccessToken(
              login: login,
              authToken: authToken,
            );
      final hlsUrl = twitchGqlApi.buildHlsUrl(login: login, token: token);
      if (generation != _generation || !identical(controller, _controller)) return;
      await controller.loadUrl(
        url: hlsUrl,
        headers: TwitchGqlApi.playbackHttpHeaders,
      );
      await controller.configureForLivePlayback();
      await controller.play();
      if (generation != _generation || !identical(controller, _controller)) return;
      isLoading = false;
      isPlaying = true;
    } catch (e) {
      error = '音频播放失败：$e';
      isLoading = false;
      isPlaying = false;
    } finally {
      _initializing = false;
      notifyListeners();
    }
  }

  Future<void> _loadArtwork(
    TwitchApi api,
    String login,
    NativeVideoPlayerController controller,
  ) async {
    try {
      final user = await api.getUser(userLogin: login);
      if (!identical(controller, _controller)) return;
      artworkUrl = user.profileImageUrl;
      await controller.setMediaInfo(
        NativeVideoPlayerMediaInfo(
          title: displayName ?? login,
          subtitle: title ?? 'Twitch',
          artworkUrl: artworkUrl,
        ),
      );
      notifyListeners();
    } catch (_) {
      // Artwork is optional; playback should not depend on Helix succeeding.
    }
  }

  Future<void> _loadStreamTitle(
    TwitchApi api,
    String login,
    NativeVideoPlayerController controller,
  ) async {
    try {
      final stream = await api.getStream(userLogin: login);
      if (!identical(controller, _controller)) return;
      title = stream.title;
      await controller.setMediaInfo(
        NativeVideoPlayerMediaInfo(
          title: displayName ?? login,
          subtitle: title ?? 'Twitch',
          artworkUrl: artworkUrl,
        ),
      );
      notifyListeners();
    } catch (_) {
      // The stream may have ended between entering the page and this request.
    }
  }

  void _selectAudioQuality(List<NativeVideoPlayerQuality> qualities) {
    if (_audioQualitySelected || _controller == null) return;
    NativeVideoPlayerQuality? audio;
    for (final quality in qualities) {
      if (quality.width == 0 && quality.height == 0) {
        audio = quality;
        break;
      }
    }
    if (audio == null) return;
    _audioQualitySelected = true;
    unawaited(_controller!.setQuality(audio));
  }

  void _onActivity(PlayerActivityEvent event) {
    switch (event.state) {
      case PlayerActivityState.playing:
        isPlaying = true;
        isLoading = false;
      case PlayerActivityState.buffering:
      case PlayerActivityState.loading:
        isLoading = true;
      case PlayerActivityState.paused:
      case PlayerActivityState.stopped:
      case PlayerActivityState.completed:
      case PlayerActivityState.idle:
        isPlaying = false;
      case PlayerActivityState.error:
        isPlaying = false;
        isLoading = false;
      default:
        break;
    }
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    final controller = _controller;
    if (controller == null || _initializing) return;
    if (isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }
  }

  Future<void> setVolume(double value) async {
    volume = value.clamp(0, 1).toDouble();
    await _controller?.setVolume(volume);
    notifyListeners();
  }

  Future<void> stop() async {
    _generation++;
    final controller = _controller;
    if (controller == null) return;
    _qualitiesSub?.cancel();
    _qualitiesSub = null;
    controller.removeActivityListener(_onActivity);
    await controller.dispose();
    _controller = null;
    userLogin = null;
    title = null;
    artworkUrl = null;
    error = null;
    isLoading = false;
    isPlaying = false;
    notifyListeners();
  }
}
