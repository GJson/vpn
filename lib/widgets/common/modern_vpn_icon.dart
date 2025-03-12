import 'package:flutter/material.dart';
import 'package:ws_vpn/widgets/common/modern_vpn_icon_painter.dart';

/// 现代风格的VPN图标组件
class ModernVpnIcon extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;
  final double shadowOpacity;
  
  const ModernVpnIcon({
    Key? key,
    this.size = 60,
    this.backgroundColor = const Color(0xFF1E2235),
    this.primaryColor = const Color(0xFF4A80F0),
    this.secondaryColor = const Color(0xFF64B5F6),
    this.textColor = Colors.white,
    this.shadowOpacity = 0.3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: ModernVpnIconPainter(
          backgroundColor: backgroundColor,
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
          textColor: textColor,
          shadowOpacity: shadowOpacity,
        ),
      ),
    );
  }
}

/// 预定义的图标样式
class ModernVpnIconStyle {
  // 默认风格 - 深蓝色背景，蓝色主题
  static Widget blue({double size = 60}) {
    return ModernVpnIcon(
      size: size,
      backgroundColor: const Color(0xFF1E2235),
      primaryColor: const Color(0xFF4A80F0),
      secondaryColor: const Color(0xFF64B5F6),
      textColor: Colors.white,
    );
  }
  
  // 明亮风格 - 浅色背景，主题蓝
  static Widget light({double size = 60}) {
    return ModernVpnIcon(
      size: size,
      backgroundColor: Colors.white,
      primaryColor: const Color(0xFF4A80F0),
      secondaryColor: const Color(0xFFE3EDFB),
      textColor: const Color(0xFF4A80F0),
      shadowOpacity: 0.1,
    );
  }
  
  // 暗夜风格 - 黑色背景，蓝紫色主题
  static Widget dark({double size = 60}) {
    return ModernVpnIcon(
      size: size,
      backgroundColor: const Color(0xFF121212),
      primaryColor: const Color(0xFF6A1B9A),
      secondaryColor: const Color(0xFFE1BEE7),
      textColor: Colors.white,
    );
  }
  
  // 森林风格 - 深绿色背景，绿色主题
  static Widget forest({double size = 60}) {
    return ModernVpnIcon(
      size: size,
      backgroundColor: const Color(0xFF1B5E20),
      primaryColor: const Color(0xFF4CAF50),
      secondaryColor: const Color(0xFFA5D6A7),
      textColor: Colors.white,
    );
  }
  
  // 紫色风格 - 深紫色背景，紫色主题
  static Widget purple({double size = 60}) {
    return ModernVpnIcon(
      size: size,
      backgroundColor: const Color(0xFF311B92),
      primaryColor: const Color(0xFF7C4DFF),
      secondaryColor: const Color(0xFFB39DDB),
      textColor: Colors.white,
    );
  }
  
  // 红色风格 - 深红色背景，红色主题
  static Widget red({double size = 60}) {
    return ModernVpnIcon(
      size: size,
      backgroundColor: const Color(0xFF7F0000),
      primaryColor: const Color(0xFFD32F2F),
      secondaryColor: const Color(0xFFFFCDD2),
      textColor: Colors.white,
    );
  }
  
  // 商务风格 - 黑色背景，金色主题
  static Widget business({double size = 60}) {
    return ModernVpnIcon(
      size: size,
      backgroundColor: const Color(0xFF212121),
      primaryColor: const Color(0xFFFFC107),
      secondaryColor: const Color(0xFFFFE082),
      textColor: Colors.white,
    );
  }
} 