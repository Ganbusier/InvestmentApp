import 'package:investment_app/models/fund.dart';

class RebalanceCheckResult {
  final bool canRebalance;
  final RebalanceCheckReason reason;
  final PortfolioCategory? category;

  const RebalanceCheckResult({
    required this.canRebalance,
    required this.reason,
    this.category,
  });

  bool get canExecute => canRebalance;

  String get message {
    if (canRebalance) return '';
    switch (reason) {
      case RebalanceCheckReason.emptyCategoryNeedsBuy:
        return '无法执行再平衡：${category?.displayName}类别为空，无法接收资金转移。请先在该类别中添加基金。';
      case RebalanceCheckReason.canRebalance:
        return '';
    }
  }
}

enum RebalanceCheckReason {
  canRebalance,
  emptyCategoryNeedsBuy,
}
