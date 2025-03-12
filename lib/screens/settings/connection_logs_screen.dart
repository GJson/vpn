import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/constants/strings.dart';
import 'package:ws_vpn/constants/text_styles.dart';
import 'package:ws_vpn/widgets/common/custom_button.dart';

class ConnectionLogsScreen extends StatefulWidget {
  const ConnectionLogsScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionLogsScreen> createState() => _ConnectionLogsScreenState();
}

class _ConnectionLogsScreenState extends State<ConnectionLogsScreen> {
  final List<ConnectionLog> _logs = [
    ConnectionLog(
      message: AppStrings.connectionInitiated,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      type: LogType.info,
    ),
    ConnectionLog(
      message: '正在验证服务器 "美国 - 纽约"...',
      timestamp: DateTime.now().subtract(const Duration(minutes: 29, seconds: 55)),
      type: LogType.info,
    ),
    ConnectionLog(
      message: '服务器验证成功',
      timestamp: DateTime.now().subtract(const Duration(minutes: 29, seconds: 50)),
      type: LogType.success,
    ),
    ConnectionLog(
      message: '正在创建安全隧道...',
      timestamp: DateTime.now().subtract(const Duration(minutes: 29, seconds: 40)),
      type: LogType.info,
    ),
    ConnectionLog(
      message: '安全隧道已创建',
      timestamp: DateTime.now().subtract(const Duration(minutes: 29, seconds: 35)),
      type: LogType.success,
    ),
    ConnectionLog(
      message: '正在获取IP地址...',
      timestamp: DateTime.now().subtract(const Duration(minutes: 29, seconds: 30)),
      type: LogType.info,
    ),
    ConnectionLog(
      message: 'IP地址获取成功: 123.45.67.89',
      timestamp: DateTime.now().subtract(const Duration(minutes: 29, seconds: 25)),
      type: LogType.success,
    ),
    ConnectionLog(
      message: AppStrings.connectionEstablished,
      timestamp: DateTime.now().subtract(const Duration(minutes: 29, seconds: 20)),
      type: LogType.success,
    ),
    ConnectionLog(
      message: '网络速度测试中...',
      timestamp: DateTime.now().subtract(const Duration(minutes: 29)),
      type: LogType.info,
    ),
    ConnectionLog(
      message: '下载速度: 42.5 Mbps, 上传速度: 23.8 Mbps',
      timestamp: DateTime.now().subtract(const Duration(minutes: 28, seconds: 50)),
      type: LogType.success,
    ),
    ConnectionLog(
      message: '网络延迟: 85ms',
      timestamp: DateTime.now().subtract(const Duration(minutes: 28, seconds: 40)),
      type: LogType.info,
    ),
    ConnectionLog(
      message: '接收到用户断开连接请求',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      type: LogType.warning,
    ),
    ConnectionLog(
      message: '正在关闭安全隧道...',
      timestamp: DateTime.now().subtract(const Duration(minutes: 9, seconds: 55)),
      type: LogType.info,
    ),
    ConnectionLog(
      message: '安全隧道已关闭',
      timestamp: DateTime.now().subtract(const Duration(minutes: 9, seconds: 50)),
      type: LogType.success,
    ),
    ConnectionLog(
      message: AppStrings.connectionTerminated,
      timestamp: DateTime.now().subtract(const Duration(minutes: 9, seconds: 45)),
      type: LogType.warning,
    ),
    ConnectionLog(
      message: '连接会话时长: 00:20:15',
      timestamp: DateTime.now().subtract(const Duration(minutes: 9, seconds: 40)),
      type: LogType.info,
    ),
  ];

  void _clearLogs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除日志'),
        content: const Text('确定要清除所有连接日志吗？'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _logs.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(AppStrings.logsCleared),
                  backgroundColor: AppColors.successColor,
                ),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
  
  void _emptyFunction() {
    // 空函数，当日志为空时作为占位符
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.connectionLogs,
          style: TextStyle(
            color: AppColors.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: _logs.isEmpty
                ? null
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('日志已复制到剪贴板'),
                      ),
                    );
                  },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: _logs.isEmpty
                    ? _buildEmptyState()
                    : _buildLogsList(),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: AppStrings.clearLogs,
                onPressed: _logs.isEmpty ? _emptyFunction : _clearLogs,
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 64,
            color: AppColors.textLightColor,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noLogsAvailable,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '连接VPN后将在此处显示连接日志',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLogsList() {
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
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _logs.length,
        separatorBuilder: (context, index) => const Divider(height: 24),
        itemBuilder: (context, index) {
          final log = _logs[_logs.length - 1 - index]; // 倒序显示日志
          return _buildLogItem(log);
        },
      ),
    );
  }

  Widget _buildLogItem(ConnectionLog log) {
    final IconData iconData;
    final Color iconColor;
    
    switch (log.type) {
      case LogType.info:
        iconData = Icons.info_outline;
        iconColor = AppColors.primaryColor;
        break;
      case LogType.success:
        iconData = Icons.check_circle_outline;
        iconColor = AppColors.successColor;
        break;
      case LogType.warning:
        iconData = Icons.warning_amber_outlined;
        iconColor = AppColors.warningColor;
        break;
      case LogType.error:
        iconData = Icons.error_outline;
        iconColor = AppColors.errorColor;
        break;
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          iconData,
          color: iconColor,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                log.message,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(log.timestamp),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }
}

class ConnectionLog {
  final String message;
  final DateTime timestamp;
  final LogType type;

  ConnectionLog({
    required this.message,
    required this.timestamp,
    required this.type,
  });
}

enum LogType {
  info,
  success,
  warning,
  error,
} 