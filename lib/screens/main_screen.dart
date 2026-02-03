import 'package:flutter/material.dart';
import 'package:investment_app/screens/fund_list_screen.dart';
import 'package:investment_app/screens/home_screen.dart';
import 'package:investment_app/screens/rebalance_screen.dart';
import 'package:investment_app/screens/statistics_screen.dart';
import 'package:investment_app/theme/app_theme.dart';

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

  final List<String> _titles = [
    '财富管理',
    '我的基金',
    '投资统计',
    '再平衡',
  ];

  void _onTabSelected(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.accentGold, AppTheme.accentGold.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_getCurrentIcon(), color: AppTheme.primaryDark, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              _titles[_currentIndex],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [],
      ),
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

  IconData _getCurrentIcon() {
    switch (_currentIndex) {
      case 0:
        return Icons.trending_up;
      case 1:
        return Icons.account_balance_wallet;
      case 2:
        return Icons.insights;
      case 3:
        return Icons.swap_horiz;
      default:
        return Icons.trending_up;
    }
  }
}
