import 'package:flutter/foundation.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/models/fund_deletion_history.dart';
import 'package:investment_app/models/portfolio.dart';
import 'package:investment_app/models/rebalance_check_result.dart';
import 'package:investment_app/models/rebalance_snapshot.dart';
import 'package:investment_app/models/target_allocation.dart';
import 'package:investment_app/services/hive_service.dart';
import 'package:investment_app/services/portfolio_calculator.dart';
import 'package:investment_app/services/rebalance_calculator.dart';

class PortfolioProvider with ChangeNotifier {
  Portfolio? _portfolio;
  PortfolioCalculator? _calculator;
  RebalanceCalculator? _rebalanceCalculator;
  RebalanceSnapshot? _rebalanceSnapshot;
  List<FundDeletionHistory> _deletionHistory = [];
  int? _selectedTabIndex;
  final Set<String> _deletingFundIds = {};
  bool _showAddFundDialog = false;

  PortfolioProvider() {
    loadPortfolio();
  }

  Portfolio? get portfolio => _portfolio;
  PortfolioCalculator? get calculator => _calculator;
  RebalanceCalculator? get rebalanceCalculator => _rebalanceCalculator;
  RebalanceSnapshot? get rebalanceSnapshot => _rebalanceSnapshot;
  List<FundDeletionHistory> get deletionHistory => _deletionHistory;
  int? get selectedTabIndex => _selectedTabIndex;
  bool get shouldShowAddFundDialog => _showAddFundDialog;

  bool get isLoaded => _portfolio != null;
  bool get hasWarnings => _calculator?.hasAnyWarning ?? false;
  bool get needsRebalancing => _rebalanceCalculator?.needsRebalancing ?? false;
  bool get canUndoRebalance => _rebalanceSnapshot != null;
  bool get canUndo => _deletionHistory.isNotEmpty;

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
    _rebalanceSnapshot = HiveService.getRebalanceSnapshot();
    await loadDeletionHistory();
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
    if (_deletingFundIds.contains(fundId)) return;
    _deletingFundIds.add(fundId);

    try {
      final fund = HiveService.getFund(fundId);
      if (fund != null) {
        final history = FundDeletionHistory.fromDeletedFund(fund, _deletionHistory.length);
        await HiveService.saveDeletionHistory(history);
        await HiveService.clearOldestHistory(10);
      }
      await HiveService.deleteFund(fundId);
      await loadPortfolio();
    } finally {
      _deletingFundIds.remove(fundId);
    }
  }

  Future<void> deleteFunds(List<String> fundIds) async {
    final deletedFunds = <Fund>[];
    for (final id in fundIds) {
      final fund = HiveService.getFund(id);
      if (fund != null) {
        deletedFunds.add(fund);
        await HiveService.deleteFund(id);
      }
    }
    if (deletedFunds.isNotEmpty) {
      final history = FundDeletionHistory.fromDeletedFunds(deletedFunds, _deletionHistory.length);
      await HiveService.saveDeletionHistory(history);
      await HiveService.clearOldestHistory(10);
    }
    await loadPortfolio();
  }

  Future<bool> undoLastDeletion() async {
    if (_deletionHistory.isEmpty) return false;

    final lastHistory = _deletionHistory.last;
    for (final fundSnapshot in lastHistory.deletedFunds) {
      await HiveService.addFund(fundSnapshot.toFund());
    }
    await HiveService.removeDeletionHistory(lastHistory.id);
    await loadPortfolio();
    return true;
  }

  Future<void> loadDeletionHistory() async {
    _deletionHistory = HiveService.getDeletionHistory(limit: 10);
  }

  Future<void> clearAllDeletionHistory() async {
    await HiveService.clearAllDeletionHistory();
    _deletionHistory = [];
    notifyListeners();
  }

  Future<void> recordRebalance() async {
    await HiveService.saveLastRebalanced(DateTime.now());
    await loadPortfolio();
  }

  List<RebalanceAction> getRebalanceActions() {
    return _rebalanceCalculator?.generateRebalanceActions() ?? [];
  }

  RebalanceCheckResult? checkCanRebalance() {
    if (_portfolio == null || _portfolio!.funds.isEmpty) {
      return RebalanceCheckResult(
        canRebalance: false,
        reason: RebalanceCheckReason.emptyCategoryNeedsBuy,
        emptyCategories: PortfolioCategory.values.toList(),
      );
    }

    final emptyCategories = <PortfolioCategory>[];
    for (final category in PortfolioCategory.values) {
      final currentAmount = _portfolio!.getAmountByCategory(category);
      final targetAmount = totalAmount * TargetAllocation.getTarget(category);

      if (currentAmount == 0 && targetAmount > 0) {
        emptyCategories.add(category);
      }
    }

    if (emptyCategories.isNotEmpty) {
      return RebalanceCheckResult(
        canRebalance: false,
        reason: RebalanceCheckReason.emptyCategoryNeedsBuy,
        emptyCategories: emptyCategories,
      );
    }

    return RebalanceCheckResult(
      canRebalance: true,
      reason: RebalanceCheckReason.canRebalance,
      emptyCategories: [],
    );
  }

  List<PortfolioCategory> getWarningCategories() {
    return _calculator?.getWarningCategories() ?? [];
  }

  RebalancePreview previewRebalance() {
    if (_portfolio == null || _portfolio!.funds.isEmpty) {
      return RebalancePreview(
        categoryChanges: {},
        fundChanges: [],
        totalBuy: 0,
        totalSell: 0,
      );
    }

    final totalAmount = _portfolio!.totalAmount;
    final targetAmounts = <PortfolioCategory, double>{};
    final categoryTotals = <PortfolioCategory, double>{};

    for (final category in PortfolioCategory.values) {
      targetAmounts[category] = totalAmount * 0.25;
      categoryTotals[category] = _portfolio!.getAmountByCategory(category);
    }

    final categoryChanges = <PortfolioCategory, double>{};
    final fundChanges = <FundChange>[];
    double totalBuy = 0;
    double totalSell = 0;

    for (final fund in _portfolio!.funds) {
      final target = targetAmounts[fund.category]!;
      final categoryTotal = categoryTotals[fund.category]!;
      final categoryAdjustment = target - categoryTotal;

      double newAmount;
      if (categoryTotal == 0) {
        final categoryFunds = _portfolio!.getFundsByCategory(fund.category);
        newAmount = target / (categoryFunds.isEmpty ? 1 : categoryFunds.length);
      } else {
        newAmount = fund.amount + (categoryAdjustment * (fund.amount / categoryTotal));
      }

      final change = newAmount - fund.amount;
      fundChanges.add(FundChange(
        fundId: fund.id,
        fundName: fund.name,
        category: fund.category,
        currentAmount: fund.amount,
        targetAmount: newAmount,
        change: change,
      ));

      if (change > 0) totalBuy += change;
      if (change < 0) totalSell += change.abs();
    }

    for (final category in PortfolioCategory.values) {
      categoryChanges[category] = targetAmounts[category]! - categoryTotals[category]!;
    }

    return RebalancePreview(
      categoryChanges: categoryChanges,
      fundChanges: fundChanges,
      totalBuy: totalBuy,
      totalSell: totalSell,
    );
  }

  Future<bool> executeRebalance() async {
    if (_portfolio == null || _portfolio!.funds.isEmpty) return false;
    if (_rebalanceSnapshot != null) return false;

    final snapshot = RebalanceSnapshot.fromFunds(
      _portfolio!.funds.map((f) => f.copyWith()).toList(),
      _portfolio!.totalAmount,
    );
    await HiveService.saveRebalanceSnapshot(snapshot);

    final totalAmount = _portfolio!.totalAmount;
    final targetAmounts = <PortfolioCategory, double>{};
    final categoryTotals = <PortfolioCategory, double>{};

    for (final category in PortfolioCategory.values) {
      targetAmounts[category] = totalAmount * 0.25;
      categoryTotals[category] = _portfolio!.getAmountByCategory(category);
    }

    for (final fund in _portfolio!.funds) {
      final target = targetAmounts[fund.category]!;
      final categoryTotal = categoryTotals[fund.category]!;
      final categoryAdjustment = target - categoryTotal;

      double newAmount;
      if (categoryTotal == 0) {
        final categoryFunds = _portfolio!.getFundsByCategory(fund.category);
        newAmount = target / (categoryFunds.isEmpty ? 1 : categoryFunds.length);
      } else {
        newAmount = fund.amount + (categoryAdjustment * (fund.amount / categoryTotal));
      }

      final updatedFund = fund.copyWith(amount: newAmount);
      await HiveService.updateFund(updatedFund);
    }

    await HiveService.saveLastRebalanced(DateTime.now());
    _rebalanceSnapshot = snapshot;
    await loadPortfolio();
    return true;
  }

  Future<bool> undoRebalance() async {
    if (_rebalanceSnapshot == null) return false;

    for (final fundSnapshot in _rebalanceSnapshot!.funds) {
      final originalFund = _portfolio!.funds.firstWhere(
        (f) => f.id == fundSnapshot.fundId,
        orElse: () => Fund(
          id: fundSnapshot.fundId,
          name: fundSnapshot.name,
          code: '',
          category: fundSnapshot.category,
          amount: fundSnapshot.amount,
        ),
      );
      final fund = originalFund.copyWith(amount: fundSnapshot.amount);
      await HiveService.updateFund(fund);
    }

    await HiveService.clearRebalanceSnapshot();
    _rebalanceSnapshot = null;
    await loadPortfolio();
    return true;
  }

  Future<void> loadRebalanceSnapshot() async {
    _rebalanceSnapshot = HiveService.getRebalanceSnapshot();
    notifyListeners();
  }

  void selectTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  void clearSelectedTab() {
    _selectedTabIndex = null;
    notifyListeners();
  }

  void triggerShowAddFundDialog() {
    _showAddFundDialog = true;
    notifyListeners();
  }

  void hideAddFundDialog() {
    _showAddFundDialog = false;
    notifyListeners();
  }
}

class FundChange {
  final String fundId;
  final String fundName;
  final PortfolioCategory category;
  final double currentAmount;
  final double targetAmount;
  final double change;

  FundChange({
    required this.fundId,
    required this.fundName,
    required this.category,
    required this.currentAmount,
    required this.targetAmount,
    required this.change,
  });

  bool get isBuy => change > 0;
  bool get isSell => change < 0;
  bool get isUnchanged => change == 0;
}

class RebalancePreview {
  final Map<PortfolioCategory, double> categoryChanges;
  final List<FundChange> fundChanges;
  final double totalBuy;
  final double totalSell;

  RebalancePreview({
    required this.categoryChanges,
    required this.fundChanges,
    required this.totalBuy,
    required this.totalSell,
  });

  List<FundChange> get meaningfulChanges {
    return fundChanges.where((c) => c.change.abs() > 1).toList()
      ..sort((a, b) => b.change.abs().compareTo(a.change.abs()));
  }
}
