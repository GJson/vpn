import 'package:flutter/material.dart';

/// 现代风格的VPN图标绘制器
class ModernVpnIconPainter extends CustomPainter {
  final Color backgroundColor;
  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;
  final double shadowOpacity;

  ModernVpnIconPainter({
    this.backgroundColor = const Color(0xFF1E2235),
    this.primaryColor = const Color(0xFF4A80F0),
    this.secondaryColor = const Color(0xFF64B5F6),
    this.textColor = Colors.white,
    this.shadowOpacity = 0.3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    
    // 绘制背景
    _drawBackground(canvas, size);
    
    // 绘制圆形边框
    _drawCircleBorder(canvas, size);
    
    // 绘制中间的闪电图标
    _drawLightningIcon(canvas, size);
    
    // 绘制底部的VPN文字
    _drawVPNText(canvas, size);
  }
  
  void _drawBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    
    // 使用圆角矩形作为背景
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final radius = Radius.circular(size.width / 6);
    final rrect = RRect.fromRectAndRadius(rect, radius);
    
    canvas.drawRRect(rrect, paint);
    
    // 添加渐变效果
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          backgroundColor.withOpacity(0.9),
          backgroundColor,
        ],
      ).createShader(rect)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(rrect, gradientPaint);
  }
  
  void _drawCircleBorder(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    // 绘制圆环
    final circlePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = width / 20;
    
    final circleCenter = Offset(width * 0.5, height * 0.38);
    final circleRadius = width * 0.28;
    
    // 添加阴影
    final shadowPaint = Paint()
      ..color = primaryColor.withOpacity(shadowOpacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width / 20;
    
    canvas.drawCircle(circleCenter, circleRadius, shadowPaint);
    canvas.drawCircle(circleCenter, circleRadius, circlePaint);
  }
  
  void _drawLightningIcon(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    // 闪电位置在圆环中心
    final center = Offset(width * 0.5, height * 0.38);
    
    // 创建闪电路径
    final lightningPath = Path();
    
    // 计算闪电大小相对于圆环
    final lightningHeight = height * 0.25;
    final lightningWidth = width * 0.15;
    
    // 闪电形状
    lightningPath.moveTo(center.dx, center.dy - lightningHeight * 0.4); // 顶部
    lightningPath.lineTo(center.dx - lightningWidth * 0.4, center.dy); // 左侧向下
    lightningPath.lineTo(center.dx, center.dy - lightningHeight * 0.1); // 中间向上
    lightningPath.lineTo(center.dx, center.dy + lightningHeight * 0.4); // 中间垂直向下
    lightningPath.lineTo(center.dx + lightningWidth * 0.4, center.dy); // 右侧向上
    lightningPath.lineTo(center.dx, center.dy + lightningHeight * 0.1); // 中间向下
    lightningPath.close(); // 闭合路径
    
    // 添加闪电光晕
    final glowPaint = Paint()
      ..color = secondaryColor.withOpacity(0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(lightningPath, glowPaint);
    
    // 绘制闪电
    final lightningPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(lightningPath, lightningPaint);
    
    // 添加一点高光
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width / 100;
    
    final highlightPath = Path();
    highlightPath.moveTo(center.dx, center.dy - lightningHeight * 0.4); // 顶部
    highlightPath.lineTo(center.dx - lightningWidth * 0.4, center.dy); // 左侧向下
    
    canvas.drawPath(highlightPath, highlightPaint);
  }
  
  void _drawVPNText(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    final textStyle = TextStyle(
      color: textColor,
      fontSize: width * 0.18,
      fontWeight: FontWeight.bold,
      letterSpacing: width * 0.01,
    );
    
    final textSpan = TextSpan(
      text: 'VPN',
      style: textStyle,
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    textPainter.layout(
      minWidth: 0,
      maxWidth: width,
    );
    
    // 文字位置在底部居中 - 调整位置向下移动
    final textX = (width - textPainter.width) / 2;
    // 将系数从0.7增加到0.78，使文字下移
    final textY = height * 0.78 - textPainter.height / 2;
    
    // 添加文字阴影
    final shadowSpan = TextSpan(
      text: 'VPN',
      style: textStyle.copyWith(
        color: primaryColor.withOpacity(0.5),
        shadows: [
          Shadow(
            blurRadius: 4,
            color: primaryColor.withOpacity(0.5),
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
    
    final shadowPainter = TextPainter(
      text: shadowSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    shadowPainter.layout(
      minWidth: 0,
      maxWidth: width,
    );
    
    shadowPainter.paint(canvas, Offset(textX, textY + 1));
    textPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 