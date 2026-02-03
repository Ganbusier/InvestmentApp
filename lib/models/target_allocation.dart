import 'package:investment_app/models/fund.dart';

class TargetAllocation {
  static const Map<PortfolioCategory, double> defaults = {
    PortfolioCategory.stock: 0.25,
    PortfolioCategory.bond: 0.25,
    PortfolioCategory.cash: 0.25,
    PortfolioCategory.gold: 0.25,
  };

  static double getTarget(PortfolioCategory category) {
    return defaults[category] ?? 0.0;
  }

  static List<PortfolioCategory> get allCategories {
    return PortfolioCategory.values;
  }

  static bool isExcessive(PortfolioCategory category, double currentPercentage) {
    final target = getTarget(category);
    return currentPercentage > target * 1.2;
  }

  static bool isDeficient(PortfolioCategory category, double currentPercentage) {
    final target = getTarget(category);
    return currentPercentage < target * 0.8;
  }
}
