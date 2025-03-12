import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/assets.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/constants/strings.dart';
import 'package:ws_vpn/constants/text_styles.dart';
import 'package:ws_vpn/screens/premium/payment_method_screen.dart';
import 'package:ws_vpn/widgets/common/custom_button.dart';

class GoPremiumScreen extends StatefulWidget {
  const GoPremiumScreen({Key? key}) : super(key: key);

  @override
  State<GoPremiumScreen> createState() => _GoPremiumScreenState();
}

class _GoPremiumScreenState extends State<GoPremiumScreen> {
  int _selectedPlanIndex = 1; // 默认选择年度计划
  
  final List<PremiumPlan> _plans = [
    PremiumPlan(
      title: '月度计划',
      price: '￥28.00',
      period: '每月',
      features: [
        '不限流量',
        '高速服务器',
        '无广告',
        '5台设备同时连接',
      ],
      savePercent: 0,
    ),
    PremiumPlan(
      title: '年度计划',
      price: '￥198.00',
      period: '每年',
      features: [
        '不限流量',
        '高速服务器',
        '无广告',
        '不限设备数量',
        '优先客服支持',
      ],
      savePercent: 40,
      isBestValue: true,
    ),
  ];

  void _selectPlan(int index) {
    setState(() {
      _selectedPlanIndex = index;
    });
  }

  void _subscribe() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentMethodScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.goPremium,
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 宣传图片
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    AppAssets.goPremium1,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  '高级功能',
                  style: AppTextStyles.heading2,
                ),
                const SizedBox(height: 8),
                Text(
                  '解锁所有高级功能，享受更快速、更安全的VPN服务',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 32),
                // 高级功能列表
                _buildFeaturesList(),
                const SizedBox(height: 32),
                // 订阅计划
                for (int i = 0; i < _plans.length; i++) ...[
                  _buildPlanCard(
                    plan: _plans[i],
                    isSelected: i == _selectedPlanIndex,
                    onTap: () => _selectPlan(i),
                  ),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 16),
                CustomButton(
                  text: AppStrings.subscribe,
                  onPressed: _subscribe,
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      '恢复购买',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    '订阅将在到期时自动续费，您可以随时在账户设置中取消订阅',
                    style: TextStyle(
                      color: AppColors.textLightColor,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      {'icon': Icons.speed, 'title': '无速度限制', 'description': '享受高速连接和无限带宽'},
      {'icon': Icons.lock, 'title': '高级加密', 'description': '使用最高级别的加密技术保护您的数据'},
      {'icon': Icons.devices, 'title': '多设备支持', 'description': '在多台设备上同时使用VPN服务'},
      {'icon': Icons.support_agent, 'title': '专属客服支持', 'description': '获得优先的客户支持服务'},
    ];

    return Column(
      children: features.map((feature) => _buildFeatureItem(
        icon: feature['icon'] as IconData,
        title: feature['title'] as String,
        description: feature['description'] as String,
      )).toList(),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required PremiumPlan plan,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            width: 2,
          ),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          plan.price,
                          style: AppTextStyles.heading3,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          plan.period,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                if (plan.savePercent > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '节省${plan.savePercent}%',
                      style: TextStyle(
                        color: AppColors.accentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                if (plan.isBestValue) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '最佳价值',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                Radio<bool>(
                  value: true,
                  groupValue: isSelected,
                  onChanged: (_) => onTap(),
                  activeColor: AppColors.primaryColor,
                ),
              ],
            ),
            const Divider(height: 24),
            ...plan.features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.successColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    feature,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}

class PremiumPlan {
  final String title;
  final String price;
  final String period;
  final List<String> features;
  final int savePercent;
  final bool isBestValue;

  PremiumPlan({
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    this.savePercent = 0,
    this.isBestValue = false,
  });
} 