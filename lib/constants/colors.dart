import 'package:flutter/material.dart';

class AppColors {
  // 主题颜色
  static const Color primaryColor = Color(0xFF3550E8);
  static const Color secondaryColor = Color(0xFF3AADE1);
  static const Color accentColor = Color(0xFF02CACA);
  
  // 背景颜色
  static const Color backgroundColor = Color(0xFFF9FAFD);
  static const Color cardColor = Colors.white;
  
  // 文本颜色
  static const Color textPrimaryColor = Color(0xFF16162E);
  static const Color textSecondaryColor = Color(0xFF94A3B8);
  static const Color textLightColor = Color(0xFFB4BDD4);
  
  // 状态颜色
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFFF3B30);
  static const Color warningColor = Color(0xFFFFB700);
  
  // 渐变色
  static const List<Color> primaryGradient = [
    primaryColor,
    secondaryColor,
  ];
  
  static const List<Color> accentGradient = [
    secondaryColor,
    accentColor,
  ];
  
  // 连接状态颜色
  static const Color connectedColor = Color(0xFF4CAF50);
  static const Color disconnectedColor = Color(0xFFE53935);
  static const Color connectingColor = Color(0xFFFFB700);
} 