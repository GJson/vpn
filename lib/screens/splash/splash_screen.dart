import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ws_vpn/constants/assets.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/constants/strings.dart';
import 'package:ws_vpn/constants/text_styles.dart';
import 'package:ws_vpn/screens/auth/onboarding_screen.dart';
import 'package:ws_vpn/screens/auth/login_screen.dart';
import 'package:ws_vpn/screens/home/home_screen.dart';
import 'package:ws_vpn/services/user_service.dart';
import 'dart:developer' as developer;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    developer.log('SplashScreen - initState');
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    developer.log('SplashScreen - dispose');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    developer.log('SplashScreen - AppLifecycleState: $state');
  }

  Future<void> _initializeApp() async {
    try {
      developer.log('SplashScreen - 开始初始化应用');
      
      if (!mounted) {
        developer.log('SplashScreen - Widget 未挂载，退出初始化');
        return;
      }

      // 延迟2秒以显示启动画面
      await Future.delayed(const Duration(seconds: 2));
      developer.log('SplashScreen - 延迟2秒完成');

      // 获取 SharedPreferences 实例
      final prefs = await SharedPreferences.getInstance();
      developer.log('SplashScreen - 成功获取 SharedPreferences 实例');

      // 检查是否首次启动
      bool isFirstLaunch;
      try {
        isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
        developer.log('SplashScreen - 首次启动状态: $isFirstLaunch');
      } catch (e) {
        developer.log('SplashScreen - 读取首次启动状态失败: $e');
        isFirstLaunch = true;
      }

      if (!mounted) {
        developer.log('SplashScreen - 状态检查后 Widget 未挂载，退出初始化');
        return;
      }

      Widget nextScreen;
      if (isFirstLaunch) {
        developer.log('SplashScreen - 首次启动，准备跳转到引导页');
        try {
          await prefs.setBool('is_first_launch', false);
          developer.log('SplashScreen - 已保存首次启动状态');
        } catch (e) {
          developer.log('SplashScreen - 保存首次启动状态失败: $e');
        }
        nextScreen = const OnboardingScreen();
      } else {
        developer.log('SplashScreen - 非首次启动，检查登录状态');
        bool isLoggedIn = false;
        try {
          isLoggedIn = await UserService.isLoggedIn();
          developer.log('SplashScreen - 登录状态: $isLoggedIn');
        } catch (e) {
          developer.log('SplashScreen - 检查登录状态失败: $e');
        }

        if (!mounted) {
          developer.log('SplashScreen - 登录检查后 Widget 未挂载，退出初始化');
          return;
        }

        nextScreen = isLoggedIn ? const HomeScreen() : const LoginScreen();
      }

      developer.log('SplashScreen - 准备导航到下一个页面');
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => nextScreen),
          (route) => false,
        );
      }
    } catch (e, stackTrace) {
      developer.log('SplashScreen - 初始化过程出错', error: e, stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _retryInitialization() {
    developer.log('SplashScreen - 重试初始化');
    setState(() {
      _error = null;
      _isLoading = true;
    });
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    developer.log('SplashScreen - build');
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.primaryGradient,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.vpn_lock,
                            size: 60,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          AppStrings.appName,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '安全、快速的VPN服务',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 24),
                          Text(
                            '初始化失败: $_error',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _retryInitialization,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primaryColor,
                            ),
                            child: const Text('重试'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (_isLoading && _error == null)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 