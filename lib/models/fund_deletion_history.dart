import 'package:hive/hive.dart';
import 'package:permanent_portfolio/models/fund.dart';

part 'fund_deletion_history.g.dart';

@HiveType(typeId: 5)
class FundDeletionHistory {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime timestamp;
  @HiveField(2)
  final List<DeletedFundSnapshot> deletedFunds;
  @HiveField(3)
  final int order;

  FundDeletionHistory({
    required this.id,
    required this.timestamp,
    required this.deletedFunds,
    required this.order,
  });

  factory FundDeletionHistory.fromDeletedFund(Fund fund, int order) {
    return FundDeletionHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      deletedFunds: [
        DeletedFundSnapshot(
          fundId: fund.id,
          name: fund.name,
          code: fund.code,
          category: fund.category,
          amount: fund.amount,
        )
      ],
      order: order,
    );
  }

  factory FundDeletionHistory.fromDeletedFunds(List<Fund> funds, int order) {
    return FundDeletionHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      deletedFunds: funds
          .map((f) => DeletedFundSnapshot(
                fundId: f.id,
                name: f.name,
                code: f.code,
                category: f.category,
                amount: f.amount,
              ))
          .toList(),
      order: order,
    );
  }
}

@HiveType(typeId: 6)
class DeletedFundSnapshot {
  @HiveField(0)
  final String fundId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String code;
  @HiveField(3)
  final PortfolioCategory category;
  @HiveField(4)
  final double amount;

  DeletedFundSnapshot({
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
