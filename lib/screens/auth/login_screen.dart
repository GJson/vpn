import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/assets.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/constants/strings.dart';
import 'package:ws_vpn/constants/text_styles.dart';
import 'package:ws_vpn/screens/auth/forget_password_screen.dart';
import 'package:ws_vpn/screens/auth/register_screen.dart';
import 'package:ws_vpn/screens/home/home_screen.dart';
import 'package:ws_vpn/services/user_service.dart';
import 'package:ws_vpn/utils/keyboard_utils.dart';
import 'package:ws_vpn/widgets/common/custom_button.dart';
import 'package:ws_vpn/widgets/common/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 延迟一下再弹出键盘，确保页面已经完全加载
    // Future.delayed(const Duration(milliseconds: 300), () {
    //   KeyboardUtils.forceShowKeyboard(context, _emailFocusNode);
    // });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // 隐藏键盘
      KeyboardUtils.hideKeyboard(context);

      // 模拟登录过程
      await Future.delayed(const Duration(seconds: 2));

      try {
        // 保存登录状态
        await UserService.saveLoginState(_emailController.text);

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          // 登录成功后跳转到主页
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          // 显示错误提示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('登录失败，请重试'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入电子邮箱';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return '请输入有效的电子邮箱';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    if (value.length < 6) {
      return '密码长度至少为6位';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        KeyboardUtils.hideKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          bottom: false,  // 不为底部安全区域留空
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        top: 24.0,
                        bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 80.0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 40),
                                Text(
                                  AppStrings.login,
                                  style: AppTextStyles.heading1,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '欢迎回来，请登录您的账户',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                GestureDetector(
                                  onTap: () {
                                    KeyboardUtils.forceShowKeyboard(context, _emailFocusNode);
                                  },
                                  child: CustomTextField(
                                    label: AppStrings.email,
                                    hint: '请输入您的电子邮箱',
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: _validateEmail,
                                    prefixIcon: const Icon(Icons.email_outlined),
                                    focusNode: _emailFocusNode,
                                    autofocus: true,
                                    onSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                GestureDetector(
                                  onTap: () {
                                    KeyboardUtils.forceShowKeyboard(context, _passwordFocusNode);
                                  },
                                  child: CustomTextField(
                                    label: AppStrings.password,
                                    hint: '请输入您的密码',
                                    controller: _passwordController,
                                    isPassword: true,
                                    validator: _validatePassword,
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    focusNode: _passwordFocusNode,
                                    onSubmitted: (_) => _login(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const ForgetPasswordScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      AppStrings.forgotPassword,
                                      style: AppTextStyles.linkText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CustomButton(
                                  text: AppStrings.login,
                                  onPressed: _login,
                                  isLoading: _isLoading,
                                ),
                                const SizedBox(height: 24),
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: '${AppStrings.dontHaveAccount} ',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.textSecondaryColor,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: AppStrings.createAccount,
                                            style: AppTextStyles.bodyMedium.copyWith(
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 40 : 0),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
} 