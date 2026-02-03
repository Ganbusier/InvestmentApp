import 'package:flutter/material.dart';
import 'package:investment_app/models/fund.dart';

class AppConstants {
  static const double warningThreshold = 0.2;
  static const double rebalanceThreshold = 0.05;
  
  static const List<Color> chartColors = [
    Color(0xFF2196F3),
    Color(0xFF4CAF50),
    Color(0xFF9E9E9E),
    Color(0xFFFFD700),
  ];
  
  static const Map<PortfolioCategory, String> categoryDescriptions = {
    PortfolioCategory.stock: '股票型基金、权益类投资',
    PortfolioCategory.bond: '债券型基金、国债、企业债',
    PortfolioCategory.cash: '货币基金、现金管理',
    PortfolioCategory.gold: '黄金ETF、大宗商品',
  };
}
