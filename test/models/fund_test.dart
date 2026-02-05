import 'package:flutter_test/flutter_test.dart';
import 'package:permanent_portfolio/models/fund.dart';

void main() {
  group('Fund Model Tests', () {
    test('Fund should be created with required fields', () {
      final fund = Fund(
        name: '测试基金',
        code: '001',
        amount: 1000,
        category: PortfolioCategory.stock,
      );

      expect(fund.name, '测试基金');
      expect(fund.code, '001');
      expect(fund.amount, 1000);
      expect(fund.category, PortfolioCategory.stock);
      expect(fund.id, isNotEmpty);
      expect(fund.createdAt, isNotNull);
      expect(fund.updatedAt, isNotNull);
    });

    test('Fund copyWith should update specified fields', () {
      final original = Fund(
        name: '原基金',
        code: '001',
        amount: 1000,
        category: PortfolioCategory.stock,
      );

      final updated = original.copyWith(
        name: '新基金',
        amount: 2000,
      );

      expect(updated.name, '新基金');
      expect(updated.amount, 2000);
      expect(updated.code, '001');
      expect(updated.category, PortfolioCategory.stock);
      expect(updated.id, original.id);
    });

    test('PortfolioCategory should have correct display names', () {
      expect(PortfolioCategory.stock.displayName, '股票/权益类');
      expect(PortfolioCategory.bond.displayName, '长期债券');
      expect(PortfolioCategory.cash.displayName, '现金/货币基金');
      expect(PortfolioCategory.gold.displayName, '黄金/商品');
    });

    test('PortfolioCategory should have 25% target percentage', () {
      for (final category in PortfolioCategory.values) {
        expect(category.targetPercentage, 0.25);
      }
    });

    test('Two funds with same id should be equal', () {
      final fund1 = Fund(
        id: 'same-id',
        name: '基金1',
        code: '001',
        amount: 1000,
        category: PortfolioCategory.stock,
      );

      final fund2 = Fund(
        id: 'same-id',
        name: '基金1',
        code: '001',
        amount: 1000,
        category: PortfolioCategory.stock,
      );

      expect(fund1, equals(fund2));
    });
  });
}
