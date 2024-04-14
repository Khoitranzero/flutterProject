//lib/tokenService.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token, String role) async {
    await _storage.write(key: 'jwt_token', value: token);
    await _storage.write(key: 'role', value: role);
    print(role);
  }

  static Future<Map<String, String?>> getTokenAndRole() async {
    String? token = await _storage.read(key: 'jwt_token');
    String? role = await _storage.read(key: 'role');
    return {'token': token, 'role': role};
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'role');
  }
}
