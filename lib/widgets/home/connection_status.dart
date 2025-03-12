import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/constants/text_styles.dart';

class ConnectionStatus extends StatelessWidget {
  final bool isConnected;
  final bool isConnecting;
  final String downloadSpeed;
  final String uploadSpeed;
  final String connectionTime;

  const ConnectionStatus({
    Key? key,
    required this.isConnected,
    required this.isConnecting,
    this.downloadSpeed = '0.00 MB/s',
    this.uploadSpeed = '0.00 MB/s',
    this.connectionTime = '00:00:00',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          isConnecting
              ? '连接中...'
              : isConnected
                  ? '已连接'
                  : '未连接',
          style: AppTextStyles.heading3.copyWith(
            color: isConnecting
                ? AppColors.connectingColor
                : isConnected
                    ? AppColors.connectedColor
                    : AppColors.disconnectedColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isConnecting
              ? '正在建立安全连接...'
              : isConnected
                  ? '点击断开连接'
                  : '点击连接',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryColor,
          ),
        ),
        if (isConnected) ...[
          const SizedBox(height: 32),
          _buildConnectionInfo(),
        ],
      ],
    );
  }

  Widget _buildConnectionInfo() {
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
        children: [
          _buildInfoRow(
            icon: Icons.access_time,
            title: '连接时间',
            value: connectionTime,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.download,
            title: '下载速度',
            value: downloadSpeed,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.upload,
            title: '上传速度',
            value: uploadSpeed,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primaryColor,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.bodyMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
} 