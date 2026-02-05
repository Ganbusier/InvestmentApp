import 'package:flutter_test/flutter_test.dart';
import 'package:permanent_portfolio/models/fund.dart';
import 'package:permanent_portfolio/models/portfolio.dart';
import 'package:permanent_portfolio/services/portfolio_calculator.dart';

void main() {
  group('PortfolioCalculator Tests', () {
    late Portfolio portfolio;

    setUp(() {
      portfolio = Portfolio(
        funds: [
          Fund(
            name: '股票基金',
            code: '001',
            amount: 2500,
            category: PortfolioCategory.stock,
          ),
          Fund(
            name: '债券基金',
            code: '002',
            amount: 2500,
            category: PortfolioCategory.bond,
          ),
          Fund(
            name: '现金基金',
            code: '003',
            amount: 2500,
            category: PortfolioCategory.cash,
          ),
          Fund(
            name: '黄金基金',
            code: '004',
            amount: 2500,
            category: PortfolioCategory.gold,
          ),
        ],
      );
    });

    test('Should calculate correct percentages for balanced portfolio', () {
      final calculator = PortfolioCalculator(portfolio: portfolio);
      final percentages = calculator.calculateCategoryPercentages();

      expect(percentages[PortfolioCategory.stock], closeTo(0.25, 0.01));
      expect(percentages[PortfolioCategory.bond], closeTo(0.25, 0.01));
      expect(percentages[PortfolioCategory.cash], closeTo(0.25, 0.01));
      expect(percentages[PortfolioCategory.gold], closeTo(0.25, 0.01));
    });

    test('Should calculate correct deviations', () {
      final unbalancedPortfolio = Portfolio(
        funds: [
          Fund(
            name: '股票基金',
            code: '001',
            amount: 4000,
            category: PortfolioCategory.stock,
          ),
          Fund(
            name: '债券基金',
            code: '002',
            amount: 2000,
            category: PortfolioCategory.bond,
          ),
          Fund(
            name: '现金基金',
            code: '003',
            amount: 2000,
            category: PortfolioCategory.cash,
          ),
          Fund(
            name: '黄金基金',
            code: '004',
            amount: 2000,
            category: PortfolioCategory.gold,
          ),
        ],
      );

      final calculator = PortfolioCalculator(portfolio: unbalancedPortfolio);
      final deviations = calculator.calculateDeviations();

      expect(deviations[PortfolioCategory.stock], closeTo(0.15, 0.01));
      expect(deviations[PortfolioCategory.bond], closeTo(-0.05, 0.01));
    });

    test('Should detect excessive categories', () {
      final warningPortfolio = Portfolio(
        funds: [
          Fund(
            name: '股票基金',
            code: '001',
            amount: 4000,
            category: PortfolioCategory.stock,
          ),
          Fund(
            name: '债券基金',
            code: '002',
            amount: 2000,
            category: PortfolioCategory.bond,
          ),
          Fund(
            name: '现金基金',
            code: '003',
            amount: 2000,
            category: PortfolioCategory.cash,
          ),
          Fund(
            name: '黄金基金',
            code: '004',
            amount: 2000,
            category: PortfolioCategory.gold,
          ),
        ],
      );

      final calculator = PortfolioCalculator(portfolio: warningPortfolio);
      final warnings = calculator.getCategoriesWithWarning();

      expect(warnings[PortfolioCategory.stock], isTrue);
      expect(warnings[PortfolioCategory.bond], isFalse);
    });

    test('Should report hasAnyWarning correctly', () {
      final balancedPortfolio = Portfolio(
        funds: [
          Fund(name: '股票', code: '001', amount: 2500, category: PortfolioCategory.stock),
          Fund(name: '债券', code: '002', amount: 2500, category: PortfolioCategory.bond),
          Fund(name: '现金', code: '003', amount: 2500, category: PortfolioCategory.cash),
          Fund(name: '黄金', code: '004', amount: 2500, category: PortfolioCategory.gold),
        ],
      );

      final balancedCalculator = PortfolioCalculator(portfolio: balancedPortfolio);
      expect(balancedCalculator.hasAnyWarning, isFalse);

      final warningPortfolio = Portfolio(
        funds: [
          Fund(name: '股票', code: '001', amount: 4000, category: PortfolioCategory.stock),
          Fund(name: '债券', code: '002', amount: 2000, category: PortfolioCategory.bond),
          Fund(name: '现金', code: '003', amount: 2000, category: PortfolioCategory.cash),
          Fund(name: '黄金', code: '004', amount: 2000, category: PortfolioCategory.gold),
        ],
      );

      final warningCalculator = PortfolioCalculator(portfolio: warningPortfolio);
      expect(warningCalculator.hasAnyWarning, isTrue);
    });
  });
}
