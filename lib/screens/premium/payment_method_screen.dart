import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/constants/strings.dart';
import 'package:ws_vpn/constants/text_styles.dart';
import 'package:ws_vpn/screens/home/home_screen.dart';
import 'package:ws_vpn/widgets/common/custom_button.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int _selectedMethodIndex = 0;
  bool _isLoading = false;
  
  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      name: '支付宝',
      icon: Icons.account_balance_wallet,
      color: const Color(0xFF1677FF),
    ),
    PaymentMethod(
      name: '微信支付',
      icon: Icons.wechat,
      color: const Color(0xFF07C160),
    ),
    PaymentMethod(
      name: '银行卡',
      icon: Icons.credit_card,
      color: AppColors.primaryColor,
    ),
  ];
  
  void _selectMethod(int index) {
    setState(() {
      _selectedMethodIndex = index;
    });
  }
  
  void _processPayment() {
    setState(() {
      _isLoading = true;
    });
    
    // 模拟支付过程
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      
      // 显示支付成功对话框
      _showPaymentSuccessDialog();
    });
  }
  
  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('支付成功'),
        content: const Text('恭喜您已成功升级为高级会员！现在您可以享受所有高级功能了。'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.paymentMethod,
          style: TextStyle(
            color: AppColors.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryColor),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '选择支付方式',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: _paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = _paymentMethods[index];
                    final bool isSelected = index == _selectedMethodIndex;
                    
                    return _buildPaymentMethodItem(
                      method: method,
                      isSelected: isSelected,
                      onTap: () => _selectMethod(index),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildOrderSummary(),
              const SizedBox(height: 24),
              CustomButton(
                text: '确认支付',
                onPressed: _processPayment,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPaymentMethodItem({
    required PaymentMethod method,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: method.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                method.icon,
                color: method.color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              method.name,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textLightColor,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '订单摘要',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildOrderItem(
            title: '年度高级会员',
            value: '￥198.00',
          ),
          const Divider(height: 24),
          _buildOrderItem(
            title: '优惠',
            value: '-￥0.00',
            valueColor: AppColors.successColor,
          ),
          const Divider(height: 24),
          _buildOrderItem(
            title: '总计',
            value: '￥198.00',
            isBold: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrderItem({
    required String title,
    required String value,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isBold
              ? AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)
              : AppTextStyles.bodyMedium,
        ),
        Text(
          value,
          style: isBold
              ? AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.textPrimaryColor,
                )
              : AppTextStyles.bodyMedium.copyWith(
                  color: valueColor ?? AppColors.textPrimaryColor,
                ),
        ),
      ],
    );
  }
}

class PaymentMethod {
  final String name;
  final IconData icon;
  final Color color;
  
  PaymentMethod({
    required this.name,
    required this.icon,
    required this.color,
  });
} 