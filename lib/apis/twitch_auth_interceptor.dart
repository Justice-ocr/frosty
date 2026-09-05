import 'package:dio/dio.dart';
import 'package:frosty/screens/settings/stores/auth_store.dart';

/// Dio interceptor that automatically adds Twitch authentication headers
/// to requests targeting Twitch API endpoints.
class TwitchAuthInterceptor extends Interceptor {
  final AuthStore _authStore;

  const TwitchAuthInterceptor(this._authStore);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check if this is a Twitch API request that needs authentication
    if (_shouldAddTwitchHeaders(options.uri)) {
      // Do not attach the current access token to the client-credentials
      // request. Also preserve an explicit Authorization header: login and
      // token validation pass the token being validated on the request itself.
      if (!_isTokenEndpoint(options.uri)) {
        final twitchHeaders = _authStore.headersTwitch;
        for (final entry in twitchHeaders.entries) {
          if (!_containsHeader(options.headers, entry.key)) {
            options.headers[entry.key] = entry.value;
          }
        }
      }
    }

    handler.next(options);
  }

  /// Determines if the request URL is for a Twitch API endpoint that requires authentication
  bool _shouldAddTwitchHeaders(Uri uri) {
    final url = uri.toString();

    // Add headers for Twitch Helix API and OAuth endpoints
    return url.startsWith('https://api.twitch.tv/helix') ||
        url.startsWith('https://id.twitch.tv/oauth2');
  }

  bool _isTokenEndpoint(Uri uri) =>
      uri.host == 'id.twitch.tv' && uri.path == '/oauth2/token';

  bool _containsHeader(Map<String, dynamic> headers, String name) =>
      headers.keys.any((key) => key.toLowerCase() == name.toLowerCase());
}
