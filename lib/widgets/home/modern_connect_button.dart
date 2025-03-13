import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/constants/text_styles.dart';
import 'package:ws_vpn/utils/animations/animation_config.dart';

class ModernConnectButton extends StatelessWidget {
  final bool isConnected;
  final bool isConnecting;
  final VoidCallback onPressed;
  final double size;

  const ModernConnectButton({
    Key? key,
    required this.isConnected,
    required this.isConnecting,
    required this.onPressed,
    this.size = 160,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 根据连接状态确定按钮颜色
    final Color buttonColor = isConnected
        ? AppColors.connectedColor
        : isConnecting
            ? AppColors.connectingColor
            : AppColors.primaryColor;

    // 按钮文本
    final String buttonText = isConnected
        ? '已连接'
        : isConnecting
            ? '连接中...'
            : '点击连接';

    // 构建内部填充圆形
    Widget innerCircle = Container(
      width: size * 0.84,
      height: size * 0.84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: buttonColor.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          isConnected
              ? Icons.power_settings_new
              : isConnecting
                  ? Icons.sync
                  : Icons.power_settings_new,
          color: Colors.white,
          size: size * 0.3,
        ),
      ),
    );

    // 为连接中状态添加旋转动画
    if (isConnecting) {
      innerCircle = RotationTransition(
        turns: AlwaysStoppedAnimation(0 / 360),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 6.28),
          duration: const Duration(seconds: 2),
          builder: (context, value, child) {
            return Transform.rotate(
              angle: value,
              child: child,
            );
          },
          child: innerCircle,
        ),
      );
    }

    // 为已连接和连接中状态添加阴影光晕效果
    if (isConnected || isConnecting) {
      innerCircle = Stack(
        alignment: Alignment.center,
        children: [
          // 外部光晕
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: size * 0.95,
            height: size * 0.95,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: buttonColor.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          // 按钮本身
          innerCircle,
        ],
      );
    }

    // 应用脉动动画
    Widget finalButton = AppAnimations.pulseAnimation(
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(child: innerCircle),
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        finalButton,
        const SizedBox(height: 20),
        Text(
          buttonText,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isConnected
                ? AppColors.connectedColor
                : AppColors.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}