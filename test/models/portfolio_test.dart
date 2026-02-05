import 'package:flutter_test/flutter_test.dart';
import 'package:permanent_portfolio/models/fund.dart';
import 'package:permanent_portfolio/models/portfolio.dart';
import 'package:permanent_portfolio/models/target_allocation.dart';

void main() {
  group('Portfolio Model Tests', () {
    test('Portfolio should calculate total amount correctly', () {
      final portfolio = Portfolio(
        funds: [
          Fund(
            name: '基金1',
            code: '001',
            amount: 2500,
            category: PortfolioCategory.stock,
          ),
          Fund(
            name: '基金2',
            code: '002',
            amount: 1500,
            category: PortfolioCategory.bond,
          ),
        ],
      );

      expect(portfolio.totalAmount, 4000);
    });

    test('Portfolio should filter funds by category', () {
      final portfolio = Portfolio(
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
            amount: 1500,
            category: PortfolioCategory.bond,
          ),
          Fund(
            name: '另一股票基金',
            code: '003',
            amount: 1000,
            category: PortfolioCategory.stock,
          ),
        ],
      );

      final stockFunds = portfolio.getFundsByCategory(PortfolioCategory.stock);
      expect(stockFunds.length, 2);
      expect(stockFunds[0].name, '股票基金');
      expect(stockFunds[1].name, '另一股票基金');
    });

    test('Portfolio should calculate category amount correctly', () {
      final portfolio = Portfolio(
        funds: [
          Fund(
            name: '股票基金1',
            code: '001',
            amount: 2500,
            category: PortfolioCategory.stock,
          ),
          Fund(
            name: '股票基金2',
            code: '002',
            amount: 1500,
            category: PortfolioCategory.stock,
          ),
          Fund(
            name: '债券基金',
            code: '003',
            amount: 2000,
            category: PortfolioCategory.bond,
          ),
        ],
      );

      expect(portfolio.getAmountByCategory(PortfolioCategory.stock), 4000);
      expect(portfolio.getAmountByCategory(PortfolioCategory.bond), 2000);
      expect(portfolio.getAmountByCategory(PortfolioCategory.cash), 0);
    });

    test('Portfolio should calculate category percentage correctly', () {
      final portfolio = Portfolio(
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

      expect(portfolio.getPercentageByCategory(PortfolioCategory.stock), 0.25);
      expect(portfolio.getPercentageByCategory(PortfolioCategory.bond), 0.25);
      expect(portfolio.getPercentageByCategory(PortfolioCategory.cash), 0.25);
      expect(portfolio.getPercentageByCategory(PortfolioCategory.gold), 0.25);
    });

    test('Portfolio with empty funds should have zero total', () {
      final portfolio = Portfolio();
      expect(portfolio.totalAmount, 0);
      expect(portfolio.getPercentageByCategory(PortfolioCategory.stock), 0);
    });

    test('TargetAllocation should detect excessive percentage', () {
      expect(TargetAllocation.isExcessive(PortfolioCategory.stock, 0.32), isTrue);
      expect(TargetAllocation.isExcessive(PortfolioCategory.stock, 0.25), isFalse);
      expect(TargetAllocation.isExcessive(PortfolioCategory.stock, 0.29), isFalse);
    });

    test('TargetAllocation should detect deficient percentage', () {
      expect(TargetAllocation.isDeficient(PortfolioCategory.stock, 0.18), isTrue);
      expect(TargetAllocation.isDeficient(PortfolioCategory.stock, 0.25), isFalse);
      expect(TargetAllocation.isDeficient(PortfolioCategory.stock, 0.21), isFalse);
    });
  });
}
