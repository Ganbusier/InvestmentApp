import 'package:flutter_test/flutter_test.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/models/portfolio.dart';
import 'package:investment_app/services/rebalance_calculator.dart';

void main() {
  group('RebalanceCalculator Tests', () {
    test('Should calculate correct target amounts', () {
      final portfolio = Portfolio(
        funds: [
          Fund(name: '股票', code: '001', amount: 2500, category: PortfolioCategory.stock),
          Fund(name: '债券', code: '002', amount: 2500, category: PortfolioCategory.bond),
          Fund(name: '现金', code: '003', amount: 2500, category: PortfolioCategory.cash),
          Fund(name: '黄金', code: '004', amount: 2500, category: PortfolioCategory.gold),
        ],
      );

      final calculator = RebalanceCalculator(portfolio: portfolio);
      final targets = calculator.calculateTargetAmounts();

      expect(targets[PortfolioCategory.stock], 2500);
      expect(targets[PortfolioCategory.bond], 2500);
      expect(targets[PortfolioCategory.cash], 2500);
      expect(targets[PortfolioCategory.gold], 2500);
    });

    test('Should calculate correct adjustments for unbalanced portfolio', () {
      final portfolio = Portfolio(
        funds: [
          Fund(name: '股票', code: '001', amount: 4000, category: PortfolioCategory.stock),
          Fund(name: '债券', code: '002', amount: 2000, category: PortfolioCategory.bond),
          Fund(name: '现金', code: '003', amount: 2000, category: PortfolioCategory.cash),
          Fund(name: '黄金', code: '004', amount: 2000, category: PortfolioCategory.gold),
        ],
      );

      final calculator = RebalanceCalculator(portfolio: portfolio);
      final adjustments = calculator.calculateAdjustments();

      expect(adjustments[PortfolioCategory.stock], closeTo(-1500, 0.01));
      expect(adjustments[PortfolioCategory.bond], closeTo(500, 0.01));
      expect(adjustments[PortfolioCategory.cash], closeTo(500, 0.01));
      expect(adjustments[PortfolioCategory.gold], closeTo(500, 0.01));
    });

    test('Should generate correct rebalance actions', () {
      final portfolio = Portfolio(
        funds: [
          Fund(name: '股票', code: '001', amount: 4000, category: PortfolioCategory.stock),
          Fund(name: '债券', code: '002', amount: 2000, category: PortfolioCategory.bond),
          Fund(name: '现金', code: '003', amount: 2000, category: PortfolioCategory.cash),
          Fund(name: '黄金', code: '004', amount: 2000, category: PortfolioCategory.gold),
        ],
      );

      final calculator = RebalanceCalculator(portfolio: portfolio);
      final actions = calculator.generateRebalanceActions();

      expect(actions.length, 4);
      
      final stockAction = actions.firstWhere((a) => a.category == PortfolioCategory.stock);
      expect(stockAction.isBuy, isFalse);
      expect(stockAction.amount, closeTo(1500, 0.01));

      final bondAction = actions.firstWhere((a) => a.category == PortfolioCategory.bond);
      expect(bondAction.isBuy, isTrue);
      expect(bondAction.amount, closeTo(500, 0.01));
    });

    test('Should detect needsRebalancing correctly', () {
      final balancedPortfolio = Portfolio(
        funds: [
          Fund(name: '股票', code: '001', amount: 2500, category: PortfolioCategory.stock),
          Fund(name: '债券', code: '002', amount: 2500, category: PortfolioCategory.bond),
          Fund(name: '现金', code: '003', amount: 2500, category: PortfolioCategory.cash),
          Fund(name: '黄金', code: '004', amount: 2500, category: PortfolioCategory.gold),
        ],
      );

      final balancedCalculator = RebalanceCalculator(portfolio: balancedPortfolio);
      expect(balancedCalculator.needsRebalancing, isFalse);

      final unbalancedPortfolio = Portfolio(
        funds: [
          Fund(name: '股票', code: '001', amount: 4000, category: PortfolioCategory.stock),
          Fund(name: '债券', code: '002', amount: 2000, category: PortfolioCategory.bond),
          Fund(name: '现金', code: '003', amount: 2000, category: PortfolioCategory.cash),
          Fund(name: '黄金', code: '004', amount: 2000, category: PortfolioCategory.gold),
        ],
      );

      final unbalancedCalculator = RebalanceCalculator(portfolio: unbalancedPortfolio);
      expect(unbalancedCalculator.needsRebalancing, isTrue);
    });
  });
}
