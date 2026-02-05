import 'package:permanent_portfolio/models/fund.dart';
import 'package:permanent_portfolio/models/portfolio.dart';
import 'package:permanent_portfolio/models/target_allocation.dart';
import 'package:permanent_portfolio/services/portfolio_calculator.dart';

class RebalanceCalculator {
  final Portfolio portfolio;
  final double totalAmount;
  final double threshold;

  RebalanceCalculator({
    required this.portfolio,
    this.threshold = 0.10,
  }) : totalAmount = portfolio.totalAmount;

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
    if (totalAmount == 0) {
      return [];
    }

    final adjustments = calculateAdjustments();
    final actions = <RebalanceAction>[];

    for (final category in PortfolioCategory.values) {
      final adjustment = adjustments[category]!;
      final currentPercentage = portfolio.getAmountByCategory(category) / totalAmount;
      final targetPercentage = TargetAllocation.getTarget(category);
      final deviation = (currentPercentage - targetPercentage).abs();

      if (deviation > threshold) {
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
    return deviations.values.any((dev) => dev.abs() > threshold);
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
