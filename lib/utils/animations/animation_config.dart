import 'package:flutter/material.dart';

/// 应用全局动画配置
class AppAnimations {
  // 动画持续时间
  static const Duration veryFast = Duration(milliseconds: 150);
  static const Duration fast = Duration(milliseconds: 250);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);
  
  // 常用动画曲线
  static const Curve easeFast = Curves.easeOut;
  static const Curve easeNormal = Curves.easeInOut;
  static const Curve easeElastic = Curves.elasticOut;
  static const Curve easeBack = Curves.easeOutBack;
  static const Curve easeBounce = Curves.bounceOut;
  
  // 页面转场动画
  static PageRouteBuilder fadeTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: normal,
    );
  }
  
  static PageRouteBuilder slideTransition(Widget page, {bool fromBottom = true}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = fromBottom 
            ? const Offset(0.0, 1.0)
            : const Offset(1.0, 0.0);
        final end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: normal,
    );
  }
  
  static PageRouteBuilder scaleTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleAnimation = Tween(begin: 0.8, end: 1.0)
            .chain(CurveTween(curve: easeBack))
            .animate(animation);
        final fadeAnimation = Tween(begin: 0.0, end: 1.0)
            .animate(animation);
            
        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: normal,
    );
  }
  
  // 专用动画 - VPN连接按钮
  static Widget pulseAnimation(Widget child) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.95, end: 1.05),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
      builder: (context, value, c) {
        return Transform.scale(
          scale: value,
          child: c,
        );
      },
      child: child,
    );
  }
  
  // 卡片悬浮动画
  static Widget cardHoverAnimation(Widget child) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;
        
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: fast,
            curve: easeNormal,
            transform: Matrix4.identity()
              ..translate(0.0, isHovered ? -5.0 : 0.0, 0.0),
            child: child,
          ),
        );
      },
    );
  }
}