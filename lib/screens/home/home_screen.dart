import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/assets.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/constants/strings.dart';
import 'package:ws_vpn/constants/text_styles.dart';
import 'package:ws_vpn/screens/account/account_screen.dart';
import 'package:ws_vpn/screens/home/select_server_screen.dart';
import 'package:ws_vpn/screens/settings/settings_screen.dart';
import 'package:ws_vpn/widgets/common/modern_vpn_icon.dart';
import 'package:ws_vpn/widgets/home/connection_status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isConnected = false;
  bool _isConnecting = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  String _selectedServer = '美国 - 纽约';
  String _connectionTime = '00:00:00';
  String _downloadSpeed = '0.00 MB/s';
  String _uploadSpeed = '0.00 MB/s';
  Timer? _timer;
  Timer? _networkSpeedTimer;
  int _seconds = 0;
  int _currentTab = 0;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    _networkSpeedTimer?.cancel();
    super.dispose();
  }

  void _toggleConnection() {
    setState(() {
      if (_isConnected) {
        // 断开连接
        _isConnected = false;
        _isConnecting = false;
        _stopTimer();
        _downloadSpeed = '0.00 MB/s';
        _uploadSpeed = '0.00 MB/s';
      } else {
        // 开始连接
        _isConnecting = true;
        _animationController.repeat();
        
        // 模拟连接过程
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isConnecting = false;
              _isConnected = true;
              _animationController.stop();
              _startTimer();
              _simulateNetworkSpeed();
            });
          }
        });
      }
    });
  }

  void _startTimer() {
    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _seconds++;
        _connectionTime = _formatDuration(Duration(seconds: _seconds));
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _seconds = 0;
    _connectionTime = '00:00:00';
  }

  void _simulateNetworkSpeed() {
    // 模拟网络速度变化
    _networkSpeedTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || !_isConnected) {
        timer.cancel();
        return;
      }
      
      setState(() {
        double download = 1.5 + (DateTime.now().millisecondsSinceEpoch % 50) / 10;
        double upload = 0.8 + (DateTime.now().millisecondsSinceEpoch % 30) / 10;
        _downloadSpeed = '${download.toStringAsFixed(2)} MB/s';
        _uploadSpeed = '${upload.toStringAsFixed(2)} MB/s';
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  void _selectServer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectServerScreen(currentServer: _selectedServer),
      ),
    );
    
    if (result != null && result is String) {
      setState(() {
        _selectedServer = result;
      });
    }
  }

  void _navigateToTab(int index) {
    if (index == _currentTab) return;
    
    switch (index) {
      case 0:
        // 已经在首页
        break;
      case 1:
        // 服务器页面
        _selectServer();
        break;
      case 2:
        // 账户页面
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountScreen(),
          ),
        );
        break;
      case 3:
        // 设置页面
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsScreen(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildConnectionButton(),
                    const SizedBox(height: 40),
                    _buildConnectionStatus(),
                    const SizedBox(height: 40),
                    _buildServerSelection(),
                  ],
                ),
              ),
            ),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'WS VPN',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
          Row(
            children: [
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  icon: const Icon(Icons.settings, size: 24),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ),
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  icon: const Icon(Icons.person_outline, size: 28),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionButton() {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _toggleConnection,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isConnected ? AppColors.successColor : Colors.white,
            boxShadow: [
              BoxShadow(
                color: (_isConnected ? AppColors.successColor : AppColors.primaryColor).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: const Icon(
                Icons.power_settings_new,
                size: 60,
                color: AppColors.primaryColor,
              ),
              secondChild: const Icon(
                Icons.power_settings_new,
                size: 60,
                color: Colors.white,
              ),
              crossFadeState:
                  _isConnected ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return ConnectionStatus(
      isConnected: _isConnected,
      isConnecting: _isConnecting,
      downloadSpeed: _downloadSpeed,
      uploadSpeed: _uploadSpeed,
      connectionTime: _connectionTime,
    );
  }

  Widget _buildServerSelection() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _selectServer,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                child: const Center(
                  child: Icon(
                    Icons.public,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '当前服务器',
                    style: AppTextStyles.bodySmall,
                  ),
                  Text(
                    _selectedServer,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textLightColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.home,
            label: '首页',
            isSelected: _currentTab == 0,
            onTap: () => _navigateToTab(0),
          ),
          _buildNavItem(
            icon: Icons.public,
            label: '服务器',
            isSelected: _currentTab == 1,
            onTap: () => _navigateToTab(1),
          ),
          _buildNavItem(
            icon: Icons.person,
            label: '账户',
            isSelected: _currentTab == 2,
            onTap: () => _navigateToTab(2),
          ),
          _buildNavItem(
            icon: Icons.settings,
            label: '设置',
            isSelected: _currentTab == 3,
            onTap: () => _navigateToTab(3),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primaryColor : AppColors.textLightColor,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.primaryColor : AppColors.textLightColor,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 