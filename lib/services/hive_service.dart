import 'package:hive_flutter/hive_flutter.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/models/portfolio.dart';
import 'package:investment_app/models/rebalance_snapshot.dart';

class HiveService {
  static const String _fundsBoxName = 'funds';
  static const String _portfolioBoxName = 'portfolio';
  static const String _settingsBoxName = 'settings';
  static const String _snapshotBoxName = 'rebalance_snapshot';

  static Box<Fund> get fundsBox => Hive.box<Fund>(_fundsBoxName);
  static Box<Portfolio> get portfolioBox => Hive.box<Portfolio>(_portfolioBoxName);
  static Box<dynamic> get settingsBox => Hive.box<dynamic>(_settingsBoxName);
  static Box<RebalanceSnapshot> get snapshotBox => Hive.box<RebalanceSnapshot>(_snapshotBoxName);

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(FundAdapter());
    Hive.registerAdapter(PortfolioAdapter());
    Hive.registerAdapter(PortfolioCategoryAdapter());
    Hive.registerAdapter(RebalanceSnapshotAdapter());
    Hive.registerAdapter(FundSnapshotAdapter());
    
    await Hive.openBox<Fund>(_fundsBoxName);
    await Hive.openBox<Portfolio>(_portfolioBoxName);
    await Hive.openBox<dynamic>(_settingsBoxName);
    await Hive.openBox<RebalanceSnapshot>(_snapshotBoxName);
  }

  static Future<void> addFund(Fund fund) async {
    await fundsBox.put(fund.id, fund);
  }

  static Future<void> updateFund(Fund fund) async {
    await fundsBox.put(fund.id, fund);
  }

  static Future<void> deleteFund(String fundId) async {
    await fundsBox.delete(fundId);
  }

  static Fund? getFund(String fundId) {
    return fundsBox.get(fundId);
  }

  static List<Fund> getAllFunds() {
    return fundsBox.values.toList();
  }

  static Portfolio getPortfolio() {
    final funds = getAllFunds();
    final lastRebalanced = portfolioBox.get('lastRebalanced')?.lastRebalanced;
    return Portfolio(funds: funds, lastRebalanced: lastRebalanced);
  }

  static Future<void> saveLastRebalanced(DateTime dateTime) async {
    await portfolioBox.put('lastRebalanced', Portfolio(lastRebalanced: dateTime));
  }

  static Future<void> clearAllData() async {
    await fundsBox.clear();
    await portfolioBox.clear();
    await snapshotBox.clear();
  }

  static Future<void> saveRebalanceSnapshot(RebalanceSnapshot snapshot) async {
    await snapshotBox.put('current_snapshot', snapshot);
  }

  static RebalanceSnapshot? getRebalanceSnapshot() {
    return snapshotBox.get('current_snapshot');
  }

  static Future<void> clearRebalanceSnapshot() async {
    await snapshotBox.delete('current_snapshot');
  }

  static Future<void> close() async {
    await Hive.close();
  }
}
