import 'package:investment_app/models/fund.dart';
import 'package:investment_app/models/portfolio.dart';
import 'package:investment_app/models/target_allocation.dart';

class PortfolioCalculator {
  final Portfolio portfolio;

  PortfolioCalculator({required this.portfolio});

  Map<PortfolioCategory, double> calculateCategoryPercentages() {
    final Map<PortfolioCategory, double> percentages = {};
    final total = portfolio.totalAmount;

    if (total == 0) {
      for (final category in PortfolioCategory.values) {
        percentages[category] = 0;
      }
      return percentages;
    }

    for (final category in PortfolioCategory.values) {
      percentages[category] = portfolio.getAmountByCategory(category) / total;
    }

    return percentages;
  }

  Map<PortfolioCategory, double> calculateDeviations() {
    final percentages = calculateCategoryPercentages();
    final deviations = <PortfolioCategory, double>{};
    final total = portfolio.totalAmount;

    if (total == 0) {
      for (final category in PortfolioCategory.values) {
        deviations[category] = 0;
      }
      return deviations;
    }

    for (final category in PortfolioCategory.values) {
      final target = TargetAllocation.getTarget(category);
      deviations[category] = percentages[category]! - target;
    }

    return deviations;
  }

  Map<PortfolioCategory, bool> getCategoriesWithWarning() {
    final percentages = calculateCategoryPercentages();
    final warnings = <PortfolioCategory, bool>{};

    for (final category in PortfolioCategory.values) {
      warnings[category] = TargetAllocation.isExcessive(
        category,
        percentages[category]!,
      ) || TargetAllocation.isDeficient(
        category,
        percentages[category]!,
      );
    }

    return warnings;
  }

  bool get hasAnyWarning {
    return getCategoriesWithWarning().values.any((warning) => warning);
  }

  List<PortfolioCategory> getWarningCategories() {
    final warnings = getCategoriesWithWarning();
    return warnings.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }
}
