import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/services/language_service.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _currentLanguage = LanguageService.defaultLanguage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final language = await LanguageService.getCurrentLanguage();
    if (mounted) {
      setState(() {
        _currentLanguage = language;
        _isLoading = false;
      });
    }
  }

  Future<void> _selectLanguage(String languageCode) async {
    await LanguageService.setLanguage(languageCode);
    if (mounted) {
      setState(() {
        _currentLanguage = languageCode;
      });
      Navigator.pop(context, languageCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          '语言设置',
          style: TextStyle(
            color: AppColors.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryColor),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: LanguageService.supportedLanguages.length,
              itemBuilder: (context, index) {
                final languageCode = LanguageService.supportedLanguages.keys.elementAt(index);
                final languageName = LanguageService.supportedLanguages[languageCode]!;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => _selectLanguage(languageCode),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              languageName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (languageCode == _currentLanguage)
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.primaryColor,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
} 