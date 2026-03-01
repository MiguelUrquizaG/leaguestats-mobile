import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage;

  // Llaves constantes para evitar errores de escritura
  static const String _tokenKey = 'auth_token';
  static const String _emailKey = 'user_email'; // Nueva llave para el email

  StorageService([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  // --- MÉTODOS PARA EL TOKEN ---
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // --- MÉTODOS PARA EL EMAIL (Nuevos) ---

  // Llama a esto justo después de un login exitoso
  Future<void> saveEmail(String email) async {
    await _storage.write(key: _emailKey, value: email);
  }

  // Esto es lo que usa tu HomePageView para saber a quién buscar
  Future<String?> getEmail() async {
    return await _storage.read(key: _emailKey);
  }

  Future<void> deleteEmail() async {
    await _storage.delete(key: _emailKey);
  }

  // Método extra para limpiar todo al cerrar sesión
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
