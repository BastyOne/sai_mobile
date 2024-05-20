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

  static Future<void> setUserType(String userType) async {
    if (_prefs == null) {
      await initialize();
    }
    await _prefs!.setString('userType', userType);
  }

  static Future<String?> getUserType() async {
    if (_prefs == null) {
      await initialize();
    }
    return _prefs!.getString('userType');
  }

  static Future<void> removeUserType() async {
    if (_prefs == null) {
      await initialize();
    }
    await _prefs!.remove('userType');
  }

  static Future<void> setUserId(int userId) async {
    if (_prefs == null) {
      await initialize();
    }
    await _prefs!.setInt('userId', userId);
  }

  static Future<int?> getUserId() async {
    if (_prefs == null) {
      await initialize();
    }
    return _prefs!.getInt('userId');
  }

  static Future<void> removeUserId() async {
    if (_prefs == null) {
      await initialize();
    }
    await _prefs!.remove('userId');
  }
}
