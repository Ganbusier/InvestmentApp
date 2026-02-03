import 'package:investment_app/models/fund.dart';
import 'package:investment_app/models/portfolio.dart';
import 'package:investment_app/models/target_allocation.dart';
import 'package:investment_app/services/portfolio_calculator.dart';

class RebalanceCalculator {
  final Portfolio portfolio;
  final double totalAmount;

  RebalanceCalculator({required this.portfolio})
      : totalAmount = portfolio.totalAmount;

  Map<PortfolioCategory, double> calculateTargetAmounts() {
    final Map<PortfolioCategory, double> targets = {};
    for (final category in PortfolioCategory.values) {
      targets[category] = totalAmount * TargetAllocation.getTarget(category);
    }
    return targets;
  }

  Map<PortfolioCategory, double> calculateAdjustments() {
    final currentAmounts = <PortfolioCategory, double>{};
    final targetAmounts = calculateTargetAmounts();
    final adjustments = <PortfolioCategory, double>{};

    for (final category in PortfolioCategory.values) {
      currentAmounts[category] = portfolio.getAmountByCategory(category);
    }

    for (final category in PortfolioCategory.values) {
      adjustments[category] = targetAmounts[category]! - currentAmounts[category]!;
    }

    return adjustments;
  }

  List<RebalanceAction> generateRebalanceActions() {
    final adjustments = calculateAdjustments();
    final actions = <RebalanceAction>[];

    for (final category in PortfolioCategory.values) {
      final adjustment = adjustments[category]!;
      if (adjustment.abs() > 1) {
        actions.add(RebalanceAction(
          category: category,
          amount: adjustment.abs(),
          isBuy: adjustment > 0,
        ));
      }
    }

    return actions;
  }

  bool get needsRebalancing {
    final deviations = PortfolioCalculator(portfolio: portfolio).calculateDeviations();
    return deviations.values.any((dev) => dev.abs() > 0.05);
  }
}

class RebalanceAction {
  final PortfolioCategory category;
  final double amount;
  final bool isBuy;

  RebalanceAction({
    required this.category,
    required this.amount,
    required this.isBuy,
  });

  String get description {
    final actionText = isBuy ? '买入' : '卖出';
    return '$actionText ${category.displayName} ¥${amount.toStringAsFixed(2)}';
  }
}
