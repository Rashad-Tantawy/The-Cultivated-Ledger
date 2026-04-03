import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  LocalStorage(this._secureStorage, this._prefs);

  // Secure storage (session tokens, sensitive data)
  Future<void> writeSecure(String key, String value) =>
      _secureStorage.write(key: key, value: value);

  Future<String?> readSecure(String key) =>
      _secureStorage.read(key: key);

  Future<void> deleteSecure(String key) =>
      _secureStorage.delete(key: key);

  Future<void> clearSecure() => _secureStorage.deleteAll();

  // Shared preferences (non-sensitive settings)
  Future<bool> setBool(String key, bool value) =>
      _prefs.setBool(key, value);

  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  Future<bool> remove(String key) => _prefs.remove(key);
}
