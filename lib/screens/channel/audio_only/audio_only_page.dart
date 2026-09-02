import 'package:better_native_video_player/better_native_video_player.dart';
import 'package:flutter/material.dart';
import 'package:frosty/services/audio_only_playback_service.dart';
import 'package:frosty/utils/context_extensions.dart';

class AudioOnlyPage extends StatefulWidget {
  static const routeName = 'AudioOnly';

  final String userLogin;
  final String displayName;

  const AudioOnlyPage({
    super.key,
    required this.userLogin,
    required this.displayName,
  });

  @override
  State<AudioOnlyPage> createState() => _AudioOnlyPageState();
}

class _AudioOnlyPageState extends State<AudioOnlyPage> {
  final service = AudioOnlyPlaybackService.instance;

  @override
  void initState() {
    super.initState();
    service.addListener(_onChanged);
    service.start(
      login: widget.userLogin,
      name: widget.displayName,
      twitchApi: context.twitchApi,
      twitchGqlApi: context.twitchGqlApi,
      authStore: context.authStore,
    );
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    service.removeListener(_onChanged);
    // Deliberately do not stop: audio continues after leaving this page.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = service.controller;
    return Scaffold(
      appBar: AppBar(
        title: const Text('听视频'),
        actions: [
          IconButton(
            tooltip: '停止播放',
            icon: const Icon(Icons.stop_rounded),
            onPressed: controller == null ? null : service.stop,
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            if (controller != null)
              const Align(
                alignment: Alignment.topLeft,
                child: SizedBox.shrink(),
              ),
            if (controller != null)
              SizedBox(
                width: 1,
                height: 1,
                child: NativeVideoPlayer(
                  key: ObjectKey(controller),
                  controller: controller,
                ),
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Artwork(url: service.artworkUrl),
                    const SizedBox(height: 24),
                    Text(
                      service.displayName ?? widget.displayName,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.title ?? '音频模式',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    if (service.error != null)
                      Text(
                        service.error!,
                        style: TextStyle(color: context.colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    if (service.isLoading) const CircularProgressIndicator(),
                    if (!service.isLoading && service.error == null)
                      IconButton.filled(
                        iconSize: 42,
                        tooltip: service.isPlaying ? '暂停' : '播放',
                        icon: Icon(
                          service.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        onPressed: service.togglePlayPause,
                      ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        const Icon(Icons.volume_down_rounded),
                        Expanded(
                          child: Slider(
                            value: service.volume,
                            onChanged: service.setVolume,
                          ),
                        ),
                        const Icon(Icons.volume_up_rounded),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '退出此页面后仍会在后台播放',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Artwork extends StatelessWidget {
  final String? url;
  const _Artwork({this.url});

  @override
  Widget build(BuildContext context) {
    final fallback = CircleAvatar(
      radius: 72,
      backgroundColor: context.colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.headphones_rounded, size: 64),
    );
    if (url == null) return fallback;
    return ClipOval(
      child: Image.network(
        url!,
        width: 144,
        height: 144,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      ),
    );
  }
}
