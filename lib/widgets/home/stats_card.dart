import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/constants/text_styles.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? customColor;

  const StatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.customColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = customColor ?? AppColors.primaryColor;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图标和标题行
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondaryColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 数值
          Text(
            value,
            style: AppTextStyles.valueText.copyWith(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// 网络速度卡片，带有上传/下载指示
class NetworkSpeedCard extends StatelessWidget {
  final String downloadSpeed;
  final String uploadSpeed;

  const NetworkSpeedCard({
    Key? key,
    required this.downloadSpeed,
    required this.uploadSpeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '网络速度',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          // 下载速度
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.arrow_downward,
                    color: AppColors.primaryColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '下载',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              Text(
                downloadSpeed,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          // 分隔线
          Container(
            height: 1,
            color: AppColors.backgroundColor,
          ),
          const SizedBox(height: 12),
          
          // 上传速度
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.arrow_upward,
                    color: AppColors.accentColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '上传',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              Text(
                uploadSpeed,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}