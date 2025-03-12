import 'package:flutter/material.dart';
import 'package:ws_vpn/constants/colors.dart';
import 'package:ws_vpn/constants/strings.dart';
import 'package:ws_vpn/constants/text_styles.dart';
import 'package:ws_vpn/screens/premium/go_premium_screen.dart';

class SelectServerScreen extends StatefulWidget {
  final String currentServer;
  
  const SelectServerScreen({
    Key? key,
    required this.currentServer,
  }) : super(key: key);

  @override
  State<SelectServerScreen> createState() => _SelectServerScreenState();
}

class _SelectServerScreenState extends State<SelectServerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  late String _selectedServer;
  
  final List<ServerItem> _freeServers = [
    ServerItem(
      name: '美国 - 纽约',
      icon: 'us',
      ping: 120,
      isPremium: false,
    ),
    ServerItem(
      name: '德国 - 法兰克福',
      icon: 'de',
      ping: 85,
      isPremium: false,
    ),
    ServerItem(
      name: '新加坡',
      icon: 'sg',
      ping: 150,
      isPremium: false,
    ),
    ServerItem(
      name: '日本 - 东京',
      icon: 'jp',
      ping: 95,
      isPremium: false,
    ),
    ServerItem(
      name: '韩国 - 首尔',
      icon: 'kr',
      ping: 110,
      isPremium: false,
    ),
  ];
  
  final List<ServerItem> _premiumServers = [
    ServerItem(
      name: '美国 - 洛杉矶',
      icon: 'us',
      ping: 100,
      isPremium: true,
    ),
    ServerItem(
      name: '英国 - 伦敦',
      icon: 'uk',
      ping: 75,
      isPremium: true,
    ),
    ServerItem(
      name: '加拿大 - 多伦多',
      icon: 'ca',
      ping: 90,
      isPremium: true,
    ),
    ServerItem(
      name: '澳大利亚 - 悉尼',
      icon: 'au',
      ping: 160,
      isPremium: true,
    ),
    ServerItem(
      name: '法国 - 巴黎',
      icon: 'fr',
      ping: 80,
      isPremium: true,
    ),
    ServerItem(
      name: '荷兰 - 阿姆斯特丹',
      icon: 'nl',
      ping: 70,
      isPremium: true,
    ),
    ServerItem(
      name: '瑞士 - 苏黎世',
      icon: 'ch',
      ping: 65,
      isPremium: true,
    ),
  ];
  
  List<ServerItem> _filteredServers = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedServer = widget.currentServer;
    _filteredServers = _freeServers;
    
    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == 0) {
          _filteredServers = _freeServers;
        } else {
          _filteredServers = _premiumServers;
        }
      });
    });
    
    _searchController.addListener(() {
      _filterServers();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  
  void _filterServers() {
    final String searchTerm = _searchController.text.toLowerCase();
    setState(() {
      if (_tabController.index == 0) {
        if (searchTerm.isEmpty) {
          _filteredServers = _freeServers;
        } else {
          _filteredServers = _freeServers
              .where((server) => server.name.toLowerCase().contains(searchTerm))
              .toList();
        }
      } else {
        if (searchTerm.isEmpty) {
          _filteredServers = _premiumServers;
        } else {
          _filteredServers = _premiumServers
              .where((server) => server.name.toLowerCase().contains(searchTerm))
              .toList();
        }
      }
    });
  }
  
  void _selectServer(String serverName, bool isPremium) {
    if (isPremium) {
      _showPremiumDialog();
    } else {
      setState(() {
        _selectedServer = serverName;
      });
      Navigator.pop(context, serverName);
    }
  }
  
  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('高级功能'),
        content: const Text('此服务器仅限高级会员使用，您需要升级到高级会员才能使用此服务器。'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GoPremiumScreen(),
                ),
              );
            },
            child: const Text('升级'),
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
          AppStrings.selectServer,
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppStrings.searchServer,
                  hintStyle: TextStyle(color: AppColors.textLightColor),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textLightColor),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryColor,
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: AppColors.textSecondaryColor,
              tabs: const [
                Tab(text: '免费服务器'),
                Tab(text: '高级服务器'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildServerList(),
                  _buildServerList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildServerList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      itemCount: _filteredServers.length,
      itemBuilder: (context, index) {
        final server = _filteredServers[index];
        final bool isSelected = _selectedServer == server.name;
        
        return _buildServerItem(
          server: server,
          isSelected: isSelected,
          onTap: () => _selectServer(server.name, server.isPremium),
        );
      },
    );
  }
  
  Widget _buildServerItem({
    required ServerItem server,
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
            color: isSelected
                ? AppColors.primaryColor
                : Colors.transparent,
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
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.backgroundColor,
              ),
              child: Center(
                child: Icon(
                  Icons.flag,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        server.name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (server.isPremium) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '高级',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '延迟: ${server.ping}ms',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primaryColor
                    : Colors.transparent,
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
}

class ServerItem {
  final String name;
  final String icon;
  final int ping;
  final bool isPremium;

  ServerItem({
    required this.name,
    required this.icon,
    required this.ping,
    required this.isPremium,
  });
} 