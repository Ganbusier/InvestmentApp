import 'package:hive/hive.dart';
import 'package:investment_app/models/fund.dart';

part 'portfolio.g.dart';

@HiveType(typeId: 2)
class Portfolio {
  @HiveField(0)
  final List<Fund> funds;
  @HiveField(1)
  final DateTime lastRebalanced;

  Portfolio({
    List<Fund>? funds,
    DateTime? lastRebalanced,
  })  : funds = funds ?? [],
        lastRebalanced = lastRebalanced ?? DateTime.now();

  double get totalAmount =>
      funds.fold(0, (sum, fund) => sum + fund.amount);

  List<Fund> getFundsByCategory(PortfolioCategory category) {
    return funds.where((fund) => fund.category == category).toList();
  }

  double getAmountByCategory(PortfolioCategory category) {
    return getFundsByCategory(category)
        .fold(0, (sum, fund) => sum + fund.amount);
  }

  double getPercentageByCategory(PortfolioCategory category) {
    final categoryAmount = getAmountByCategory(category);
    if (totalAmount == 0) return 0.25;
    return categoryAmount / totalAmount;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Portfolio &&
          runtimeType == other.runtimeType &&
          funds == other.funds &&
          lastRebalanced == other.lastRebalanced;

  @override
  int get hashCode =>
      funds.hashCode ^ lastRebalanced.hashCode;
}
