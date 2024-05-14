import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String token) async {
    if (_prefs == null) {
      await initialize();
    }
    await _prefs!.setString('token', token);
  }

  static Future<String?> getToken() async {
    if (_prefs == null) {
      await initialize();
    }
    return _prefs!.getString('token');
  }

  static Future<void> removeToken() async {
    if (_prefs == null) {
      await initialize();
    }
    await _prefs!.remove('token');
  }
}
