import 'package:flutter/material.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/screens/fund_list_screen.dart';
import 'package:investment_app/screens/home_screen.dart';
import 'package:investment_app/screens/rebalance_screen.dart';
import 'package:investment_app/screens/statistics_screen.dart';
import 'package:investment_app/theme/app_theme.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List<Widget> get _pages => [
        const HomeScreen(),
        const FundListScreen(),
        const StatisticsScreen(),
        const RebalanceScreen(),
      ];

  void _onTabSelected(int index) {
    final provider = Provider.of<PortfolioProvider>(context, listen: false);
    provider.clearSelectedTab();
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PortfolioProvider>(
      builder: (context, provider, child) {
        if (provider.selectedTabIndex != null && provider.selectedTabIndex != _currentIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _currentIndex = provider.selectedTabIndex!;
              });
              provider.clearSelectedTab();
            }
          });
        }
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.navBarBackground,
              AppTheme.navBarBackground.withValues(alpha: 0.95),
            ],
          ),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.accentGold,
          unselectedItemColor: Colors.white.withValues(alpha: 0.5),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '首页',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: '基金',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights),
              label: '统计',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz),
              label: '再平衡',
            ),
          ],
          onTap: _onTabSelected,
        ),
      ),
    );
  }
}

