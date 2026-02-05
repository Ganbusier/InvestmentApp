import 'package:flutter_test/flutter_test.dart';
import 'package:permanent_portfolio/models/fund.dart';
import 'package:permanent_portfolio/services/hive_service.dart';

void main() {
  group('HiveService Tests', () {
    setUpAll(() async {
      await HiveService.init();
    });

    tearDownAll(() async {
      await HiveService.clearAllData();
      await HiveService.close();
    });

    test('Should add fund successfully', () async {
      final fund = Fund(
        name: '测试基金',
        code: '001',
        amount: 1000,
        category: PortfolioCategory.stock,
      );

      await HiveService.addFund(fund);
      final retrieved = HiveService.getFund(fund.id);

      expect(retrieved, isNotNull);
      expect(retrieved!.name, '测试基金');
      expect(retrieved.amount, 1000);
    });

    test('Should update fund successfully', () async {
      final fund = Fund(
        name: '原基金',
        code: '001',
        amount: 1000,
        category: PortfolioCategory.stock,
      );

      await HiveService.addFund(fund);
      final updatedFund = fund.copyWith(name: '更新后的基金', amount: 2000);
      await HiveService.updateFund(updatedFund);

      final retrieved = HiveService.getFund(fund.id);
      expect(retrieved!.name, '更新后的基金');
      expect(retrieved.amount, 2000);
    });

    test('Should delete fund successfully', () async {
      final fund = Fund(
        name: '待删除基金',
        code: '002',
        amount: 500,
        category: PortfolioCategory.bond,
      );

      await HiveService.addFund(fund);
      await HiveService.deleteFund(fund.id);
      final retrieved = HiveService.getFund(fund.id);

      expect(retrieved, isNull);
    });

    test('Should get all funds', () async {
      await HiveService.clearAllData();
      
      await HiveService.addFund(Fund(
        name: '基金1',
        code: '001',
        amount: 1000,
        category: PortfolioCategory.stock,
      ));
      await HiveService.addFund(Fund(
        name: '基金2',
        code: '002',
        amount: 2000,
        category: PortfolioCategory.bond,
      ));

      final allFunds = HiveService.getAllFunds();
      expect(allFunds.length, 2);
    });

    test('Should get portfolio with funds', () async {
      await HiveService.clearAllData();
      
      await HiveService.addFund(Fund(
        name: '股票基金',
        code: '001',
        amount: 2500,
        category: PortfolioCategory.stock,
      ));
      await HiveService.addFund(Fund(
        name: '债券基金',
        code: '002',
        amount: 2500,
        category: PortfolioCategory.bond,
      ));

      final portfolio = HiveService.getPortfolio();
      expect(portfolio.totalAmount, 5000);
      expect(portfolio.funds.length, 2);
    });
  });
}
