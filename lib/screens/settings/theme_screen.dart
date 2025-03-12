import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/services/theme_service.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  ThemeMode _currentThemeMode = ThemeMode.system;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentTheme();
  }

  Future<void> _loadCurrentTheme() async {
    final themeMode = await ThemeService.getCurrentThemeMode();
    if (mounted) {
      setState(() {
        _currentThemeMode = themeMode;
        _isLoading = false;
      });
    }
  }

  Future<void> _selectThemeMode(ThemeMode mode) async {
    await ThemeService.setThemeMode(mode);
    if (mounted) {
      setState(() {
        _currentThemeMode = mode;
      });
      Navigator.pop(context, mode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          '主题设置',
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
              itemCount: ThemeService.themeModeNames.length,
              itemBuilder: (context, index) {
                final mode = ThemeMode.values[index];
                final modeName = ThemeService.getThemeModeName(mode);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => _selectThemeMode(mode),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            mode == ThemeMode.light
                                ? Icons.light_mode
                                : mode == ThemeMode.dark
                                    ? Icons.dark_mode
                                    : Icons.settings_brightness,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              modeName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (mode == _currentThemeMode)
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