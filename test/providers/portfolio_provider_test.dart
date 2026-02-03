import 'package:flutter_test/flutter_test.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/services/hive_service.dart';

void main() {
  group('PortfolioProvider Tests', () {
    late PortfolioProvider provider;

    setUpAll(() async {
      await HiveService.init();
    });

    setUp(() async {
      await HiveService.clearAllData();
      provider = PortfolioProvider();
      await provider.loadPortfolio();
    });

    tearDownAll(() async {
      await HiveService.clearAllData();
      await HiveService.close();
    });

    test('Should initially have empty portfolio', () {
      expect(provider.isLoaded, isTrue);
      expect(provider.totalAmount, 0);
      expect(provider.getAllFunds().length, 0);
    });

    test('Should add fund and update state', () async {
      final fund = Fund(
        name: '测试基金',
        code: '001',
        amount: 1000,
        category: PortfolioCategory.stock,
      );

      await provider.addFund(fund);

      expect(provider.totalAmount, 1000);
      expect(provider.getAllFunds().length, 1);
      expect(provider.getAllFunds()[0].name, '测试基金');
    });

    test('Should update fund and reflect changes', () async {
      final fund = Fund(
        name: '原基金',
        code: '001',
        amount: 1000,
        category: PortfolioCategory.stock,
      );

      await provider.addFund(fund);
      
      final updatedFund = fund.copyWith(name: '更新基金', amount: 2000);
      await provider.updateFund(updatedFund);

      expect(provider.totalAmount, 2000);
      expect(provider.getAllFunds()[0].name, '更新基金');
    });

    test('Should delete fund and update state', () async {
      final fund = Fund(
        name: '待删除基金',
        code: '002',
        amount: 500,
        category: PortfolioCategory.bond,
      );

      await provider.addFund(fund);
      expect(provider.totalAmount, 500);

      await provider.deleteFund(fund.id);
      expect(provider.totalAmount, 0);
      expect(provider.getAllFunds().length, 0);
    });

    test('Should calculate category percentages', () async {
      await provider.addFund(Fund(
        name: '股票',
        code: '001',
        amount: 2500,
        category: PortfolioCategory.stock,
      ));
      await provider.addFund(Fund(
        name: '债券',
        code: '002',
        amount: 2500,
        category: PortfolioCategory.bond,
      ));
      await provider.addFund(Fund(
        name: '现金',
        code: '003',
        amount: 2500,
        category: PortfolioCategory.cash,
      ));
      await provider.addFund(Fund(
        name: '黄金',
        code: '004',
        amount: 2500,
        category: PortfolioCategory.gold,
      ));

      final percentages = provider.categoryPercentages;
      expect(percentages[PortfolioCategory.stock], closeTo(0.25, 0.01));
    });

    test('Should get rebalance actions', () async {
      await provider.addFund(Fund(
        name: '股票',
        code: '001',
        amount: 4000,
        category: PortfolioCategory.stock,
      ));
      await provider.addFund(Fund(
        name: '债券',
        code: '002',
        amount: 2000,
        category: PortfolioCategory.bond,
      ));
      await provider.addFund(Fund(
        name: '现金',
        code: '003',
        amount: 2000,
        category: PortfolioCategory.cash,
      ));
      await provider.addFund(Fund(
        name: '黄金',
        code: '004',
        amount: 2000,
        category: PortfolioCategory.gold,
      ));

      final actions = provider.getRebalanceActions();
      expect(actions.isNotEmpty, isTrue);
      expect(provider.needsRebalancing, isTrue);
    });
  });
}
