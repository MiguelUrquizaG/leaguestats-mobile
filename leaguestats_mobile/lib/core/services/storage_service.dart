import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage;

  // Llaves constantes para evitar errores de escritura
  static const String _tokenKey = 'auth_token';
  static const String _emailKey = 'user_email'; // Nueva llave para el email

  StorageService([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }


  Future<void> saveEmail(String email) async {
    await _storage.write(key: _emailKey, value: email);
  }

  Future<String?> getEmail() async {
    return await _storage.read(key: _emailKey);
  }

  Future<void> deleteEmail() async {
    await _storage.delete(key: _emailKey);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
