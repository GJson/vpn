import 'package:flutter/material.dart';

class VpnIconPainter extends CustomPainter {
  final Color backgroundColor;
  final Color shieldColor;
  final Color shieldStrokeColor;
  final Color lightningColor;
  final bool paintBackground;

  VpnIconPainter({
    this.backgroundColor = const Color(0xFF4A80F0),
    this.shieldColor = const Color(0xFF4A80F0),
    this.shieldStrokeColor = Colors.white,
    this.lightningColor = Colors.white,
    this.paintBackground = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    
    if (paintBackground) {
      // 绘制背景
      final Paint backgroundPaint = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.fill;
      
      final RRect backgroundRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, width, height),
        Radius.circular(width / 4),
      );
      
      canvas.drawRRect(backgroundRect, backgroundPaint);
    }
    
    // 绘制盾牌外框
    final Paint shieldStrokePaint = Paint()
      ..color = shieldStrokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = width / 20;
    
    final Path shieldPath = Path()
      ..moveTo(width / 2, height * 0.08)
      ..lineTo(width * 0.15, height * 0.25)
      ..lineTo(width * 0.15, height * 0.63)
      ..quadraticBezierTo(width * 0.18, height * 0.85, width / 2, height * 0.92)
      ..quadraticBezierTo(width * 0.82, height * 0.85, width * 0.85, height * 0.63)
      ..lineTo(width * 0.85, height * 0.25)
      ..close();
    
    // 绘制盾牌内部填充
    final Paint shieldFillPaint = Paint()
      ..color = shieldColor
      ..style = PaintingStyle.fill;
    
    // 稍微缩小内部盾牌以创建边框效果
    final Path shieldFillPath = Path()
      ..moveTo(width / 2, height * 0.12)
      ..lineTo(width * 0.20, height * 0.27)
      ..lineTo(width * 0.20, height * 0.62)
      ..quadraticBezierTo(width * 0.22, height * 0.82, width / 2, height * 0.88)
      ..quadraticBezierTo(width * 0.78, height * 0.82, width * 0.80, height * 0.62)
      ..lineTo(width * 0.80, height * 0.27)
      ..close();
    
    canvas.drawPath(shieldFillPath, shieldFillPaint);
    canvas.drawPath(shieldPath, shieldStrokePaint);
    
    // 绘制闪电
    final Paint lightningPaint = Paint()
      ..color = lightningColor
      ..style = PaintingStyle.fill;
    
    final Path lightningPath = Path()
      ..moveTo(width * 0.48, height * 0.28)
      ..lineTo(width * 0.35, height * 0.53)
      ..lineTo(width * 0.48, height * 0.53)
      ..lineTo(width * 0.45, height * 0.72)
      ..lineTo(width * 0.65, height * 0.47)
      ..lineTo(width * 0.52, height * 0.47)
      ..lineTo(width * 0.55, height * 0.28)
      ..close();
    
    canvas.drawPath(lightningPath, lightningPaint);
    
    // 绘制细节装饰线
    final Paint detailPaint = Paint()
      ..color = lightningColor.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width / 80;
    
    // 添加弧形装饰线
    final Path detailPath = Path()
      ..addArc(
        Rect.fromCenter(
          center: Offset(width / 2, height / 2),
          width: width * 0.6,
          height: height * 0.6,
        ),
        0,
        3.14,
      );
    
    canvas.drawPath(detailPath, detailPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
} 