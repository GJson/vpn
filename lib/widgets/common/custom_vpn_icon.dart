import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/widgets/common/custom_vpn_icon_painter.dart';

class CustomVpnIcon extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Color shieldColor;
  final Color shieldStrokeColor;
  final Color lightningColor;

  const CustomVpnIcon({
    Key? key,
    this.size = 60,
    this.backgroundColor = const Color(0xFF4A80F0),
    this.shieldColor = const Color(0xFF4A80F0),
    this.shieldStrokeColor = Colors.white,
    this.lightningColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: VpnIconPainter(
          backgroundColor: backgroundColor,
          shieldColor: shieldColor,
          shieldStrokeColor: shieldStrokeColor,
          lightningColor: lightningColor,
        ),
      ),
    );
  }
}

// 为了在Widget中快速访问的图标类型
class VpnIconType {
  static const default_ = CustomVpnIcon();
  
  // 圆角矩形版本
  static Widget rounded({double size = 60}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF4A80F0),
        borderRadius: BorderRadius.circular(size / 5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A80F0).withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: VpnIconPainter(
          paintBackground: false,
        ),
      ),
    );
  }
  
  // 圆形版本
  static Widget circular({double size = 60}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF4A80F0),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A80F0).withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: VpnIconPainter(
          paintBackground: false,
        ),
      ),
    );
  }
} 