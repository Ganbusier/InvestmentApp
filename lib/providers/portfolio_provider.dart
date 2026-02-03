import 'package:flutter/foundation.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/models/portfolio.dart';
import 'package:investment_app/services/hive_service.dart';
import 'package:investment_app/services/portfolio_calculator.dart';
import 'package:investment_app/services/rebalance_calculator.dart';

class PortfolioProvider with ChangeNotifier {
  Portfolio? _portfolio;
  PortfolioCalculator? _calculator;
  RebalanceCalculator? _rebalanceCalculator;

  PortfolioProvider() {
    loadPortfolio();
  }

  Portfolio? get portfolio => _portfolio;
  PortfolioCalculator? get calculator => _calculator;
  RebalanceCalculator? get rebalanceCalculator => _rebalanceCalculator;

  bool get isLoaded => _portfolio != null;
  bool get hasWarnings => _calculator?.hasAnyWarning ?? false;
  bool get needsRebalancing => _rebalanceCalculator?.needsRebalancing ?? false;

  double get totalAmount => _portfolio?.totalAmount ?? 0;

  Map<PortfolioCategory, double> get categoryPercentages {
    return _calculator?.calculateCategoryPercentages() ?? {};
  }

  Map<PortfolioCategory, double> get categoryDeviations {
    return _calculator?.calculateDeviations() ?? {};
  }

  List<Fund> getAllFunds() {
    return _portfolio?.funds ?? [];
  }

  List<Fund> getFundsByCategory(PortfolioCategory category) {
    return _portfolio?.getFundsByCategory(category) ?? [];
  }

  Future<void> loadPortfolio() async {
    _portfolio = HiveService.getPortfolio();
    _calculator = PortfolioCalculator(portfolio: _portfolio!);
    _rebalanceCalculator = RebalanceCalculator(portfolio: _portfolio!);
    notifyListeners();
  }

  Future<void> addFund(Fund fund) async {
    await HiveService.addFund(fund);
    await loadPortfolio();
  }

  Future<void> updateFund(Fund fund) async {
    await HiveService.updateFund(fund);
    await loadPortfolio();
  }

  Future<void> deleteFund(String fundId) async {
    await HiveService.deleteFund(fundId);
    await loadPortfolio();
  }

  Future<void> recordRebalance() async {
    await HiveService.saveLastRebalanced(DateTime.now());
    await loadPortfolio();
  }

  List<RebalanceAction> getRebalanceActions() {
    return _rebalanceCalculator?.generateRebalanceActions() ?? [];
  }

  List<PortfolioCategory> getWarningCategories() {
    return _calculator?.getWarningCategories() ?? [];
  }
}
