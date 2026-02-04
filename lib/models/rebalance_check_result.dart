import 'package:investment_app/models/fund.dart';

class RebalanceCheckResult {
  final bool canRebalance;
  final RebalanceCheckReason reason;
  final List<PortfolioCategory> emptyCategories;

  const RebalanceCheckResult({
    required this.canRebalance,
    required this.reason,
    required this.emptyCategories,
  });

  bool get canExecute => canRebalance;

  String get message {
    if (canRebalance) return '';
    switch (reason) {
      case RebalanceCheckReason.emptyCategoryNeedsBuy:
        final names = emptyCategories.map((c) => c.displayName).join('、');
        return '无法执行再平衡：$names 类别为空，无法接收资金转移。请先在这些类别中添加基金。';
      case RebalanceCheckReason.canRebalance:
        return '';
    }
  }
}

enum RebalanceCheckReason {
  canRebalance,
  emptyCategoryNeedsBuy,
}
