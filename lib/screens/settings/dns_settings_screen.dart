import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/constants/text_styles.dart';
import 'package:ws_vpn/widgets/common/custom_button.dart';
import 'package:ws_vpn/widgets/common/custom_text_field.dart';

class DnsSettingsScreen extends StatefulWidget {
  const DnsSettingsScreen({Key? key}) : super(key: key);

  @override
  State<DnsSettingsScreen> createState() => _DnsSettingsScreenState();
}

class _DnsSettingsScreenState extends State<DnsSettingsScreen> {
  final TextEditingController _primaryDnsController = TextEditingController(text: '8.8.8.8');
  final TextEditingController _secondaryDnsController = TextEditingController(text: '8.8.4.4');
  bool _useCustomDns = true;
  
  final List<Map<String, dynamic>> _predefinedDns = [
    {
      'name': 'Google DNS',
      'primary': '8.8.8.8',
      'secondary': '8.8.4.4',
      'description': '谷歌提供的公共DNS服务。速度快，可靠性高。',
    },
    {
      'name': 'Cloudflare DNS',
      'primary': '1.1.1.1',
      'secondary': '1.0.0.1',
      'description': 'Cloudflare的公共DNS服务。注重隐私和速度。',
    },
    {
      'name': 'Quad9',
      'primary': '9.9.9.9',
      'secondary': '149.112.112.112',
      'description': '专注于安全的公共DNS服务，有助于阻止恶意域名。',
    },
    {
      'name': 'OpenDNS',
      'primary': '208.67.222.222',
      'secondary': '208.67.220.220',
      'description': '提供灵活的内容过滤和安全功能的DNS服务。',
    },
  ];

  @override
  void dispose() {
    _primaryDnsController.dispose();
    _secondaryDnsController.dispose();
    super.dispose();
  }

  void _selectPredefinedDns(Map<String, dynamic> dns) {
    setState(() {
      _primaryDnsController.text = dns['primary'];
      _secondaryDnsController.text = dns['secondary'];
    });
  }

  void _saveDnsSettings() {
    // 验证并保存DNS设置
    if (_validateDns(_primaryDnsController.text) &&
        _validateDns(_secondaryDnsController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('DNS设置已保存'),
          backgroundColor: AppColors.successColor,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入有效的DNS地址'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  bool _validateDns(String value) {
    // 简单验证IP地址格式
    final RegExp ipRegex = RegExp(
        r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
    return ipRegex.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'DNS设置',
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
                _buildCustomDnsSection(),
                const SizedBox(height: 24),
                _buildPredefinedDnsSection(),
                const SizedBox(height: 32),
                CustomButton(
                  text: '保存设置',
                  onPressed: _saveDnsSettings,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDnsSection() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '自定义DNS',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Switch(
                value: _useCustomDns,
                onChanged: (value) {
                  setState(() {
                    _useCustomDns = value;
                  });
                },
                activeColor: AppColors.primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_useCustomDns) ...[
            CustomTextField(
              label: '主要DNS服务器',
              hint: '例如: 8.8.8.8',
              controller: _primaryDnsController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: '备用DNS服务器',
              hint: '例如: 8.8.4.4',
              controller: _secondaryDnsController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Text(
              '提示: 使用自定义DNS可能会提高您的网络性能和隐私安全，但也可能会影响某些网站的访问。',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPredefinedDnsSection() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '推荐DNS服务器',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          if (_useCustomDns)
            for (final dns in _predefinedDns) ...[
              _buildDnsCard(dns),
              if (_predefinedDns.last != dns) const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }

  Widget _buildDnsCard(Map<String, dynamic> dns) {
    final bool isSelected = _primaryDnsController.text == dns['primary'] &&
        _secondaryDnsController.text == dns['secondary'];

    return GestureDetector(
      onTap: () => _selectPredefinedDns(dns),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dns['name'],
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${dns['primary']} / ${dns['secondary']}',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dns['description'],
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => _selectPredefinedDns(dns),
              activeColor: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
} 