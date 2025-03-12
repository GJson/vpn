import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/assets.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/constants/strings.dart';
import 'package:ws_vpn/constants/text_styles.dart';
import 'package:ws_vpn/screens/auth/login_screen.dart';
import 'package:ws_vpn/screens/premium/go_premium_screen.dart';
import 'package:ws_vpn/screens/settings/settings_screen.dart';
import 'package:ws_vpn/screens/settings/language_screen.dart';
import 'package:ws_vpn/screens/settings/theme_screen.dart';
import 'package:ws_vpn/screens/common/webview_screen.dart';
import 'package:ws_vpn/services/user_service.dart';
import 'package:ws_vpn/services/notification_service.dart';
import 'package:ws_vpn/services/language_service.dart';
import 'package:ws_vpn/services/theme_service.dart';
import 'package:ws_vpn/services/support_service.dart';
import 'package:ws_vpn/widgets/common/custom_button.dart';
import 'package:flutter/material.dart' show ThemeMode;

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? _userEmail;
  String _displayName = '';
  bool _isLoading = true;
  bool _notificationEnabled = true;
  String _currentLanguage = LanguageService.defaultLanguage;
  ThemeMode _currentThemeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadNotificationSettings();
    _loadLanguageSettings();
    _loadThemeSettings();
  }

  Future<void> _loadUserInfo() async {
    try {
      final email = await UserService.getLoggedInUserEmail();
      final savedDisplayName = await UserService.getDisplayName();
      if (mounted) {
        setState(() {
          _userEmail = email;
          _displayName = savedDisplayName ?? _getDisplayName(email);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('加载用户信息失败: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadNotificationSettings() async {
    final enabled = await NotificationService.isNotificationEnabled();
    if (mounted) {
      setState(() {
        _notificationEnabled = enabled;
      });
    }
  }

  Future<void> _loadLanguageSettings() async {
    final language = await LanguageService.getCurrentLanguage();
    if (mounted) {
      setState(() {
        _currentLanguage = language;
      });
    }
  }

  Future<void> _loadThemeSettings() async {
    final themeMode = await ThemeService.getCurrentThemeMode();
    if (mounted) {
      setState(() {
        _currentThemeMode = themeMode;
      });
    }
  }

  Future<void> _toggleNotification(bool value) async {
    await NotificationService.setNotificationEnabled(value);
    if (mounted) {
      setState(() {
        _notificationEnabled = value;
      });
    }
  }

  String _getDisplayName(String? email) {
    if (email == null || email.isEmpty) {
      return '用户';
    }
    return email.split('@')[0];
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    return name.substring(0, 1).toUpperCase();
  }

  Future<void> _showEditDialog() async {
    final TextEditingController nameController = TextEditingController(text: _displayName);
    final TextEditingController emailController = TextEditingController(text: _userEmail);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑个人信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '显示名称',
                hintText: '请输入您的名称',
                labelStyle: TextStyle(color: AppColors.primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: '邮箱',
                hintText: '请输入您的邮箱',
                labelStyle: TextStyle(color: AppColors.primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '取消',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              final newEmail = emailController.text.trim();
              final newDisplayName = nameController.text.trim();
              
              if (newEmail.isEmpty || newDisplayName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('邮箱和显示名称不能为空')),
                );
                return;
              }

              try {
                await UserService.updateUserInfo(
                  email: newEmail,
                  displayName: newDisplayName,
                );
                
                if (mounted) {
                  setState(() {
                    _userEmail = newEmail;
                    _displayName = newDisplayName;
                  });
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('个人信息更新成功')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('更新失败: $e')),
                  );
                }
              }
            },
            child: const Text(
              '保存',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openLanguageSettings() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const LanguageScreen(),
      ),
    );
    
    if (result != null && mounted) {
      setState(() {
        _currentLanguage = result;
      });
    }
  }

  Future<void> _openThemeSettings() async {
    final result = await Navigator.push<ThemeMode>(
      context,
      MaterialPageRoute(
        builder: (context) => const ThemeScreen(),
      ),
    );
    
    if (result != null && mounted) {
      setState(() {
        _currentThemeMode = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.myAccount,
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
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _buildProfileCard(),
                      const SizedBox(height: 24),
                      _buildPremiumBanner(context),
                      const SizedBox(height: 24),
                      _buildSettingsSection(context),
                      const SizedBox(height: 24),
                      _buildSupportSection(),
                      const SizedBox(height: 24),
                      _buildLogoutButton(context),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                _getInitials(_displayName),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayName,
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: 4),
                Text(
                  _userEmail ?? '未设置邮箱',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '免费用户',
                    style: TextStyle(
                      color: AppColors.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: AppColors.primaryColor,
            ),
            onPressed: _showEditDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GoPremiumScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '升级到高级会员',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '解锁所有高级功能和服务器',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryColor,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final List<Map<String, dynamic>> settings = [
      {
        'icon': Icons.notifications_none,
        'title': AppStrings.notifications,
        'trailing': Transform.scale(
          scale: 0.8,
          child: Switch(
            value: _notificationEnabled,
            onChanged: _toggleNotification,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primaryColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
          ),
        ),
      },
      {
        'icon': Icons.language,
        'title': AppStrings.language,
        'subtitle': LanguageService.getLanguageName(_currentLanguage),
        'trailing': const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textLightColor,
          size: 16,
        ),
        'onTap': _openLanguageSettings,
      },
      {
        'icon': Icons.dark_mode,
        'title': AppStrings.theme,
        'subtitle': ThemeService.getThemeModeName(_currentThemeMode),
        'trailing': const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textLightColor,
          size: 16,
        ),
        'onTap': _openThemeSettings,
      },
      {
        'icon': Icons.settings,
        'title': '高级设置',
        'subtitle': 'VPN连接设置、协议和DNS',
        'trailing': const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textLightColor,
          size: 16,
        ),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            ),
          );
        },
      },
    ];

    return _buildSection(
      title: '设置',
      items: settings,
      context: context,
    );
  }

  Widget _buildSupportSection() {
    final List<Map<String, dynamic>> support = [
      {
        'icon': Icons.help_outline,
        'title': AppStrings.help,
        'trailing': const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textLightColor,
          size: 16,
        ),
        'onTap': () => _openSupportPage('help', AppStrings.help),
      },
      { 
        'icon': Icons.privacy_tip_outlined,
        'title': AppStrings.privacyPolicy,
        'trailing': const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textLightColor,
          size: 16,
        ),
        'onTap': () => _openSupportPage('privacy', AppStrings.privacyPolicy),
      },
      {
        'icon': Icons.description_outlined,
        'title': AppStrings.termsOfService,
        'trailing': const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textLightColor,
          size: 16,
        ),
        'onTap': () => _openSupportPage('terms', AppStrings.termsOfService),
      },
      {
        'icon': Icons.mail_outline,
        'title': AppStrings.contactUs,
        'trailing': const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textLightColor,
          size: 16,
        ),
        'onTap': () => _openSupportPage('contact', AppStrings.contactUs),
      },
    ];

    return _buildSection(
      title: '支持',
      items: support,
      context: context,
    );
  }

  void _openSupportPage(String key, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          title: title,
          url: SupportService.getUrl(key),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Map<String, dynamic>> items,
    required BuildContext? context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ...items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Column(
                    children: [
                      if (index > 0)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(height: 1),
                        ),
                      _buildSettingItem(
                        icon: item['icon'] as IconData,
                        title: item['title'] as String,
                        subtitle: item.containsKey('subtitle') ? item['subtitle'] as String : null,
                        trailing: item['trailing'] as Widget,
                        onTap: item['onTap'] as VoidCallback?,
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primaryColor.withOpacity(0.1),
        highlightColor: AppColors.primaryColor.withOpacity(0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing is Switch)
                trailing
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondaryColor,
                        ),
                      ),
                    const SizedBox(width: 8),
                    trailing,
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return CustomButton(
      text: AppStrings.logout,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('退出登录'),
            content: const Text('确定要退出登录吗？'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '取消',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    // 显示加载状态
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                    
                    // 清除用户数据
                    await UserService.logout();
                    
                    if (mounted) {
                      // 关闭加载对话框
                      Navigator.pop(context);
                      // 关闭确认对话框
                      Navigator.pop(context);
                      
                      // 返回登录页面
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    // 关闭加载对话框
                    Navigator.pop(context);
                    // 显示错误消息
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('退出登录失败: $e')),
                    );
                  }
                },
                child: const Text(
                  '确定',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        );
      },
      isOutlined: true,
    );
  }
} 