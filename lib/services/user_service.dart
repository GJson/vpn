import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';
  static const String _userDisplayNameKey = 'user_display_name';

  // 保存登录状态
  static Future<void> saveLoginState(String email, {String? displayName}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setBool(_isLoggedInKey, true),
        prefs.setString(_userEmailKey, email),
      ]);
      if (displayName != null) {
        await prefs.setString(_userDisplayNameKey, displayName);
      }
      print('登录状态保存成功: $email');
    } catch (e) {
      print('保存登录状态失败: $e');
      rethrow;
    }
  }

  // 检查是否已登录
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      final email = prefs.getString(_userEmailKey);
      print('检查登录状态: isLoggedIn=$isLoggedIn, email=$email');
      return isLoggedIn;
    } catch (e) {
      print('检查登录状态失败: $e');
      return false;
    }
  }

  // 获取已登录用户的邮箱
  static Future<String?> getLoggedInUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(_userEmailKey);
      print('获取登录用户邮箱: $email');
      return email;
    } catch (e) {
      print('获取登录用户邮箱失败: $e');
      return null;
    }
  }

  // 获取已登录用户的显示名称
  static Future<String?> getDisplayName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final displayName = prefs.getString(_userDisplayNameKey);
      print('获取登录用户显示名称: $displayName');
      return displayName;
    } catch (e) {
      print('获取登录用户显示名称失败: $e');
      return null;
    }
  }

  // 清除登录状态
  static Future<void> logout() async {
    try {
      // 使用 resetAllState 方法清除所有状态
      await resetAllState();
      print('登出成功，已清除所有缓存数据');
    } catch (e) {
      print('登出失败: $e');
      rethrow;
    }
  }

  // 重置所有状态
  static Future<void> resetAllState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('所有状态已重置');
    } catch (e) {
      print('重置状态失败: $e');
      rethrow;
    }
  }

  // 更新用户信息
  static Future<void> updateUserInfo({String? email, String? displayName}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (email != null) {
        await prefs.setString(_userEmailKey, email);
      }
      if (displayName != null) {
        await prefs.setString(_userDisplayNameKey, displayName);
      }
      print('用户信息更新成功');
    } catch (e) {
      print('更新用户信息失败: $e');
      rethrow;
    }
  }
} 