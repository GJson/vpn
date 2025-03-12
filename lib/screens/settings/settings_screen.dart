import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/constants/strings.dart';
import 'package:ws_vpn/constants/text_styles.dart';
import 'package:ws_vpn/screens/settings/connection_logs_screen.dart';
import 'package:ws_vpn/screens/settings/dns_settings_screen.dart';
import 'package:ws_vpn/widgets/common/custom_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoConnect = false;
  bool _killSwitch = false;
  bool _splitTunneling = false;
  String _protocol = 'OpenVPN';
  String _port = '443';
  
  final List<String> _protocols = ['OpenVPN', 'IKEv2', 'WireGuard', 'L2TP/IPSec'];
  final List<String> _ports = ['443', '80', '1194', '8080'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          '高级设置',
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  title: '连接设置',
                  children: [
                    _buildSwitchTile(
                      title: '自动连接',
                      subtitle: '在启动应用时自动连接到上次使用的服务器',
                      value: _autoConnect,
                      onChanged: (value) {
                        setState(() {
                          _autoConnect = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      title: '网络保护（Kill Switch）',
                      subtitle: '当VPN连接中断时阻止网络访问',
                      value: _killSwitch,
                      onChanged: (value) {
                        setState(() {
                          _killSwitch = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      title: '分流隧道',
                      subtitle: '允许部分应用或网站绕过VPN',
                      value: _splitTunneling,
                      onChanged: (value) {
                        setState(() {
                          _splitTunneling = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '协议设置',
                  children: [
                    _buildDropdownTile(
                      title: '协议',
                      subtitle: '选择VPN使用的协议',
                      value: _protocol,
                      items: _protocols,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _protocol = value;
                          });
                        }
                      },
                    ),
                    _buildDropdownTile(
                      title: '端口',
                      subtitle: '选择VPN使用的端口',
                      value: _port,
                      items: _ports,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _port = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'DNS设置',
                  children: [
                    _buildListTile(
                      title: '自定义DNS',
                      subtitle: '设置自定义DNS服务器',
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.textLightColor,
                        size: 16,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DnsSettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '日志与调试',
                  children: [
                    _buildListTile(
                      title: '连接日志',
                      subtitle: '查看VPN连接的详细日志',
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.textLightColor,
                        size: 16,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ConnectionLogsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: '保存设置',
                  onPressed: _saveSettings,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveSettings() {
    // 保存设置
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('设置已保存'),
        backgroundColor: AppColors.successColor,
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
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
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: AppTextStyles.bodyMedium,
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondaryColor,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildDropdownTile<T>({
    required String title,
    required String subtitle,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: AppTextStyles.bodyMedium,
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondaryColor,
        ),
      ),
      trailing: DropdownButton<T>(
        value: value,
        onChanged: onChanged,
        underline: const SizedBox(),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: AppColors.textLightColor,
        ),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              item.toString(),
              style: AppTextStyles.bodyMedium,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
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
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
} 