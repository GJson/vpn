import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/colors.dart';

class AppTextStyles {
  // 标题样式
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryColor,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryColor,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryColor,
    fontFamily: 'Poppins',
  );
  
  // 正文样式
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryColor,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryColor,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryColor,
    fontFamily: 'Poppins',
  );
  
  // 按钮文本样式
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'Poppins',
  );
  
  // 链接文本样式
  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    fontFamily: 'Poppins',
    decoration: TextDecoration.underline,
  );
  
  // 标签文本样式
  static const TextStyle labelText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryColor,
    fontFamily: 'Poppins',
  );
} 