import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageCodeKey = 'language_code';
  static const String defaultLanguage = 'zh_CN';

  static const Map<String, String> supportedLanguages = {
    'zh_CN': '简体中文',
    'en_US': 'English',
    'ja_JP': '日本語',
    'ko_KR': '한국어',
  };

  static Future<String> getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageCodeKey) ?? defaultLanguage;
  }

  static Future<void> setLanguage(String languageCode) async {
    if (!supportedLanguages.containsKey(languageCode)) {
      throw Exception('Unsupported language code: $languageCode');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
  }

  static String getLanguageName(String languageCode) {
    return supportedLanguages[languageCode] ?? supportedLanguages[defaultLanguage]!;
  }
} 