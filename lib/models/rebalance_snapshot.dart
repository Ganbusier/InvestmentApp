import 'package:hive/hive.dart';
import 'package:permanent_portfolio/models/fund.dart';

part 'rebalance_snapshot.g.dart';

@HiveType(typeId: 3)
class RebalanceSnapshot {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime timestamp;
  @HiveField(2)
  final List<FundSnapshot> funds;
  @HiveField(3)
  final double totalAmount;

  RebalanceSnapshot({
    required this.id,
    required this.timestamp,
    required this.funds,
    required this.totalAmount,
  });

  factory RebalanceSnapshot.fromFunds(List<Fund> funds, double totalAmount) {
    return RebalanceSnapshot(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      funds: funds
          .map((f) => FundSnapshot(
                fundId: f.id,
                name: f.name,
                code: f.code,
                category: f.category,
                amount: f.amount,
              ))
          .toList(),
      totalAmount: totalAmount,
    );
  }

  Map<PortfolioCategory, double> get categoryAmounts {
    final amounts = <PortfolioCategory, double>{};
    for (final fund in funds) {
      amounts[fund.category] = (amounts[fund.category] ?? 0) + fund.amount;
    }
    return amounts;
  }
}

@HiveType(typeId: 4)
class FundSnapshot {
  @HiveField(0)
  final String fundId;
  @HiveField(1)
  final String name;
  @HiveField(4)
  final String code;
  @HiveField(2)
  final PortfolioCategory category;
  @HiveField(3)
  final double amount;

  FundSnapshot({
    required this.fundId,
    required this.name,
    required this.code,
    required this.category,
    required this.amount,
  });

  Fund toFund() {
    return Fund(
      id: fundId,
      name: name,
      code: code,
      category: category,
      amount: amount,
    );
  }
}
