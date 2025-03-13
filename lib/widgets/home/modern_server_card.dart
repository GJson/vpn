import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/constants/text_styles.dart';

class ModernServerCard extends StatelessWidget {
  final String serverName;
  final String countryCode;
  final int ping;
  final bool isSelected;
  final bool isPremium;
  final VoidCallback onTap;

  const ModernServerCard({
    Key? key,
    required this.serverName,
    required this.countryCode, 
    required this.ping,
    required this.isSelected,
    required this.isPremium,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 根据 ping 值确定连接质量
    final Color pingColor = _getPingColor(ping);
    final String pingText = _getPingQuality(ping);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                ? AppColors.primaryColor.withOpacity(0.1)
                : AppColors.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: isSelected ? 2 : 0,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 国旗/服务器图标
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withOpacity(0.5),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  countryCode.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 服务器信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          serverName,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                              ? AppColors.primaryColor 
                              : AppColors.textPrimaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isPremium) ...[
                        const SizedBox(width: 8),
                        _buildPremiumBadge(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: pingColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$pingText · $ping ms',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 选择指示器
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                border: Border.all(
                  color: isSelected 
                    ? AppColors.primaryColor 
                    : AppColors.textLightColor,
                  width: 2,
                ),
              ),
              child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB700), Color(0xFFFF8A00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB700).withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Text(
        '高级',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getPingColor(int ping) {
    if (ping < 80) {
      return AppColors.successColor;
    } else if (ping < 150) {
      return AppColors.warningColor;
    } else {
      return AppColors.errorColor;
    }
  }

  String _getPingQuality(int ping) {
    if (ping < 80) {
      return '极速';
    } else if (ping < 150) {
      return '良好';
    } else {
      return '一般';
    }
  }
}