import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manages JWT token storage and retrieval using flutter_secure_storage.
class TokenService {
  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';
  static const _tokenExpiryKey = 'auth_token_expiry';

  final FlutterSecureStorage _storage;

  TokenService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Store tokens after successful authentication.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime expiry,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
      _storage.write(
          key: _tokenExpiryKey,
          value: expiry.millisecondsSinceEpoch.toString()),
    ]);
  }

  /// Get the current access token, or null if not stored.
  Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  /// Get the current refresh token, or null if not stored.
  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  /// Check if the access token has expired.
  Future<bool> isTokenExpired() async {
    final expiryStr = await _storage.read(key: _tokenExpiryKey);
    if (expiryStr == null) return true;

    final expiry =
        DateTime.fromMillisecondsSinceEpoch(int.parse(expiryStr));
    return DateTime.now().isAfter(expiry);
  }

  /// Check if tokens exist (user has been authenticated before).
  Future<bool> hasTokens() async {
    final token = await _storage.read(key: _accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Clear all stored tokens (on logout).
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _tokenExpiryKey),
    ]);
  }
}
