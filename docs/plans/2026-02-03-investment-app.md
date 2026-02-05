# 永久投资组合模拟器（永久投资组合）实现计划

> **For Claude：** REQUIRED SUB-SKILL: 使用 superpowers:executing-plans 按任务逐一实现此计划。

**目标：** 开发一款基于永久投资组合策略的永久投资组合模拟器，帮助用户管理基金投资、监控各类别百分比，并在比例失衡时提供再平衡指引。

**架构：** 采用Flutter跨平台框架，使用Hive进行本地数据持久化，Provider进行状态管理，fl_chart实现数据可视化。遵循TDD开发流程，先写测试后实现代码，确保功能可靠且易于维护。应用采用模块化设计，将数据模型、业务逻辑、UI组件分离，便于后续扩展云端同步功能。

**技术栈：** Flutter 3.x、Dart 3.x、Hive 2.x、Provider 6.x、fl_chart 0.x、VS Code + Flutter插件、Android Studio（模拟器）、iOS Simulator）。

---

## （Mac任务清单

### 任务1：项目初始化与环境搭建

**文件：**
- 创建：`pubspec.yaml`
- 创建：`analysis_options.yaml`
- 创建：`lib/main.dart`
- 创建：`test/widget_test.dart`
- 创建：`README.md`

**步骤1：创建pubspec.yaml依赖配置**

```yaml
name: investment_app
description: 永久投资组合永久投资组合模拟器

publish_to: none

version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  hive_flutter: ^2.0.0
  provider: ^6.0.5
  fl_chart: ^0.63.0
  intl: ^0.18.1
  uuid: ^4.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.0
  build_runner: ^2.4.0
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
```

**步骤2：创建analysis_options.yaml代码规范配置**

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_declarations
    - avoid_print
    - no_leading_underscores_for_local_identifiers
```

**步骤3：创建lib/main.dart入口文件**

```dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInit();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
      ],
      child: MaterialApp(
        title: '永久投资组合模拟器',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const HomeScreen(),
      ),
    );
  }
}
```

**步骤4：创建test/widget_test.dart基础测试**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:investment_app/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('永久投资组合模拟器'), findsOneWidget);
  });
}
```

**步骤5：创建README.md项目说明**

```markdown
# 永久投资组合模拟器（永久投资组合）

基于永久投资组合策略的理财管理应用，帮助用户：
- 按类别管理基金投资（股票、债券、现金、黄金）
- 监控各类别投资百分比
- 获取再平衡操作指引

## 技术栈

- Flutter 3.x
- Hive（本地存储）
- Provider（状态管理）
- fl_chart（数据可视化）

## 运行方式

```bash
flutter pub get
flutter run
```

## 测试

```bash
flutter test
```
```

**步骤6：运行flutter pub get安装依赖**

Run: `flutter pub get`
Expected: Dependencies installed successfully

**步骤7：验证项目可运行**

Run: `flutter test`
Expected: 1 passed, 0 failures

**步骤8：提交代码**

```bash
git add .
git commit -m "feat: 初始化Flutter项目结构和依赖配置"
```

---

### 任务2：数据模型层实现

**文件：**
- 创建：`lib/models/fund.dart`
- 创建：`lib/models/portfolio.dart`
- 创建：`lib/models/target_allocation.dart`
- 创建：`test/models/fund_test.dart`
- 创建：`test/models/portfolio_test.dart`

**步骤1：创建lib/models/fund.dart基金数据模型**

```dart
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'fund.g.dart';

@HiveType(typeId: 0)
enum PortfolioCategory {
  @HiveField(0)
  stock,
  @HiveField(1)
  bond,
  @HiveField(2)
  cash,
  @HiveField(3)
  gold,
}

extension PortfolioCategoryExtension on PortfolioCategory {
  String get displayName {
    switch (this) {
      case PortfolioCategory.stock:
        return '股票/权益类';
      case PortfolioCategory.bond:
        return '长期债券';
      case PortfolioCategory.cash:
        return '现金/货币基金';
      case PortfolioCategory.gold:
        return '黄金/商品';
    }
  }

  double get targetPercentage {
    return 0.25;
  }
}

@HiveType(typeId: 1)
class Fund {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String code;
  @HiveField(3)
  final double amount;
  @HiveField(4)
  final PortfolioCategory category;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime updatedAt;

  Fund({
    String? id,
    required this.name,
    required this.code,
    required this.amount,
    required this.category,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Fund copyWith({
    String? name,
    String? code,
    double? amount,
    PortfolioCategory? category,
  }) {
    return Fund(
      id: id,
      name: name ?? this.name,
      code: code ?? this.code,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Fund &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          code == other.code &&
          amount == other.amount &&
          category == other.category;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      code.hashCode ^
      amount.hashCode ^
      category.hashCode;
}
```

**步骤2：创建lib/models/portfolio.dart投资组合模型**

```dart
import 'package:hive/hive.dart';
import 'package:investment_app/models/fund.dart';

part 'portfolio.g.dart';

@HiveType(typeId: 2)
class Portfolio {
  @HiveField(0)
  final List<Fund> funds;
  @HiveField(1)
  final DateTime lastRebalanced;

  Portfolio({
    List<Fund>? funds,
    DateTime? lastRebalanced,
  })  : funds = funds ?? [],
        lastRebalanced = lastRebalanced ?? DateTime.now();

  double get totalAmount =>
      funds.fold(0, (sum, fund) => sum + fund.amount);

  List<Fund> getFundsByCategory(PortfolioCategory category) {
    return funds.where((fund) => fund.category == category).toList();
  }

  double getAmountByCategory(PortfolioCategory category) {
    return getFundsByCategory(category)
        .fold(0, (sum, fund) => sum + fund.amount);
  }

  double getPercentageByCategory(PortfolioCategory category) {
    final categoryAmount = getAmountByCategory(category);
    if (totalAmount == 0) return 0;
    return categoryAmount / totalAmount;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Portfolio &&
          runtimeType == other.runtimeType &&
          funds == other.funds &&
          lastRebalanced == other.lastRebalanced;

  @override
  int get hashCode =>
      funds.hashCode ^ lastRebalanced.hashCode;
}
```

**步骤3：创建lib/models/target_allocation.dart目标配置模型**

```dart
import 'package:investment_app/models/fund.dart';

class TargetAllocation {
  static const Map<PortfolioCategory, double> defaults = {
    PortfolioCategory.stock: 0.25,
    PortfolioCategory.bond: 0.25,
    PortfolioCategory.cash: 0.25,
    PortfolioCategory.gold: 0.25,
  };

  static double getTarget(PortfolioCategory category) {
    return defaults[category] ?? 0.0;
  }

  static List<PortfolioCategory> get allCategories {
    return PortfolioCategory.values;
  }

  static bool isExcessive(PortfolioCategory category, double currentPercentage) {
    final target = getTarget(category);
    return currentPercentage > target * 1.2;
  }

  static bool isDeficient(PortfolioCategory category, double currentPercentage) {
    final target = getTarget(category);
    return currentPercentage < target * 0.8;
  }
}
```

**步骤4：创建test/models/fund_test.dart Fund模型测试**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:investment_app/models/fund.dart';

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
```

**步骤5：创建test/models/portfolio_test.dart Portfolio模型测试**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/models/portfolio.dart';

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
```

**步骤6：运行测试验证数据模型**

Run: `flutter test test/models/`
Expected: All tests pass

**步骤7：运行Hive代码生成**

Run: `flutter pub run build_runner build`
Expected: Generated files fund.g.dart, portfolio.g.dart

**步骤8：提交代码**

```bash
git add lib/models/ test/models/
git commit -m "feat: 实现数据模型层（Fund、Portfolio、TargetAllocation）"
```

---

### 任务3：Hive本地存储服务实现

**文件：**
- 创建：`lib/services/hive_service.dart`
- 创建：`test/services/hive_service_test.dart`
- 修改：`lib/main.dart`（添加Hive初始化）

**步骤1：创建lib/services/hive_service.dart存储服务**

```dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/models/portfolio.dart';

class HiveService {
  static const String _fundsBoxName = 'funds';
  static const String _portfolioBoxName = 'portfolio';
  static const String _settingsBoxName = 'settings';

  static Box<Fund> get fundsBox => Hive.box<Fund>(_fundsBoxName);
  static Box<Portfolio> get portfolioBox => Hive.box<Portfolio>(_portfolioBoxName);
  static Box<dynamic> get settingsBox => Hive.box<dynamic>(_settingsBoxName);

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(FundAdapter());
    Hive.registerAdapter(PortfolioAdapter());
    Hive.registerAdapter(PortfolioCategoryAdapter());
    
    await Hive.openBox<Fund>(_fundsBoxName);
    await Hive.openBox<Portfolio>(_portfolioBoxName);
    await Hive.openBox<dynamic>(_settingsBoxName);
  }

  static Future<void> addFund(Fund fund) async {
    await fundsBox.put(fund.id, fund);
  }

  static Future<void> updateFund(Fund fund) async {
    await fund.save();
  }

  static Future<void> deleteFund(String fundId) async {
    await fundsBox.delete(fundId);
  }

  static Fund? getFund(String fundId) {
    return fundsBox.get(fundId);
  }

  static List<Fund> getAllFunds() {
    return fundsBox.values.toList();
  }

  static Portfolio getPortfolio() {
    final funds = getAllFunds();
    final lastRebalanced = portfolioBox.get('lastRebalanced')?.lastRebalanced;
    return Portfolio(funds: funds, lastRebalanced: lastRebalanced);
  }

  static Future<void> saveLastRebalanced(DateTime dateTime) async {
    await portfolioBox.put('lastRebalanced', Portfolio(lastRebalanced: dateTime));
  }

  static Future<void> clearAllData() async {
    await fundsBox.clear();
    await portfolioBox.clear();
  }

  static Future<void> close() async {
    await Hive.close();
  }
}
```

**步骤2：创建test/services/hive_service_test.dart存储服务测试**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/services/hive_service.dart';

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
```

**步骤3：修改lib/main.dart添加Hive初始化**

```dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/theme/app_theme.dart';
import 'package:investment_app/services/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInit();
  await HiveService.init();
  runApp(const MyApp());
}
```

**步骤4：运行存储服务测试**

Run: `flutter test test/services/`
Expected: All tests pass

**步骤5：提交代码**

```bash
git add lib/services/ test/services/
git commit -m "feat: 实现Hive本地存储服务"
```

---

### 任务4：业务逻辑服务层实现

**文件：**
- 创建：`lib/services/portfolio_calculator.dart`
- 创建：`lib/services/rebalance_calculator.dart`
- 创建：`test/services/portfolio_calculator_test.dart`
- 创建：`test/services/rebalance_calculator_test.dart`

**步骤1：创建lib/services/portfolio_calculator.dart百分比计算服务**

```dart
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/models/portfolio.dart';
import 'package:investment_app/models/target_allocation.dart';

class PortfolioCalculator {
  final Portfolio portfolio;

  PortfolioCalculator({required this.portfolio});

  Map<PortfolioCategory, double> calculateCategoryPercentages() {
    final Map<PortfolioCategory, double> percentages = {};
    final total = portfolio.totalAmount;

    if (total == 0) {
      for (final category in PortfolioCategory.values) {
        percentages[category] = 0;
      }
      return percentages;
    }

    for (final category in PortfolioCategory.values) {
      percentages[category] = portfolio.getAmountByCategory(category) / total;
    }

    return percentages;
  }

  Map<PortfolioCategory, double> calculateDeviations() {
    final percentages = calculateCategoryPercentages();
    final deviations = <PortfolioCategory, double>{};

    for (final category in PortfolioCategory.values) {
      final target = TargetAllocation.getTarget(category);
      deviations[category] = percentages[category]! - target;
    }

    return deviations;
  }

  Map<PortfolioCategory, bool> getCategoriesWithWarning() {
    final percentages = calculateCategoryPercentages();
    final warnings = <PortfolioCategory, bool>{};

    for (final category in PortfolioCategory.values) {
      warnings[category] = TargetAllocation.isExcessive(
        category,
        percentages[category]!,
      ) || TargetAllocation.isDeficient(
        category,
        percentages[category]!,
      );
    }

    return warnings;
  }

  bool get hasAnyWarning {
    return getCategoriesWithWarning().values.any((warning) => warning);
  }

  List<PortfolioCategory> getWarningCategories() {
    final warnings = getCategoriesWithWarning();
    return warnings.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }
}
```

**步骤2：创建lib/services/rebalance_calculator.dart再平衡计算服务**

```dart
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/models/portfolio.dart';
import 'package:investment_app/models/target_allocation.dart';

class RebalanceCalculator {
  final Portfolio portfolio;
  final double totalAmount;

  RebalanceCalculator({required this.portfolio})
      : totalAmount = portfolio.totalAmount;

  Map<PortfolioCategory, double> calculateTargetAmounts() {
    final Map<PortfolioCategory, double> targets = {};
    for (final category in PortfolioCategory.values) {
      targets[category] = totalAmount * TargetAllocation.getTarget(category);
    }
    return targets;
  }

  Map<PortfolioCategory, double> calculateAdjustments() {
    final currentAmounts = <PortfolioCategory, double>{};
    final targetAmounts = calculateTargetAmounts();
    final adjustments = <PortfolioCategory, double>{};

    for (final category in PortfolioCategory.values) {
      currentAmounts[category] = portfolio.getAmountByCategory(category);
    }

    for (final category in PortfolioCategory.values) {
      adjustments[category] = targetAmounts[category]! - currentAmounts[category]!;
    }

    return adjustments;
  }

  List<RebalanceAction> generateRebalanceActions() {
    final adjustments = calculateAdjustments();
    final actions = <RebalanceAction>[];

    for (final category in PortfolioCategory.values) {
      final adjustment = adjustments[category]!;
      if (adjustment.abs() > 1) {
        actions.add(RebalanceAction(
          category: category,
          amount: adjustment.abs(),
          isBuy: adjustment > 0,
        ));
      }
    }

    return actions;
  }

  bool get needsRebalancing {
    final deviations = PortfolioCalculator(portfolio: portfolio).calculateDeviations();
    return deviations.values.any((dev) => dev.abs() > 0.05);
  }
}

class RebalanceAction {
  final PortfolioCategory category;
  final double amount;
  final bool isBuy;

  RebalanceAction({
    required this.category,
    required this.amount,
    required this.isBuy,
  });

  String get description {
    final actionText = isBuy ? '买入' : '卖出';
    return '$actionText ${category.displayName} ¥${amount.toStringAsFixed(2)}';
  }
}
```

**步骤3：创建test/services/portfolio_calculator_test.dart计算服务测试**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/models/portfolio.dart';
import 'package:investment_app/services/portfolio_calculator.dart';

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
```

**步骤4：创建test/services/rebalance_calculator_test.dart再平衡测试**

```dart
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

      expect(adjustments[PortfolioCategory.stock], closeTo(-1000, 0.01));
      expect(adjustments[PortfolioCategory.bond], closeTo(500, 0.01));
      expect(adjustments[PortfolioCategory.cash], closeTo(500, 0.01));
      expect(adjustments[PortfolioCategory.gold], closeTo(0, 0.01));
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

      expect(actions.length, 3);
      
      final stockAction = actions.firstWhere((a) => a.category == PortfolioCategory.stock);
      expect(stockAction.isBuy, isFalse);
      expect(stockAction.amount, closeTo(1000, 0.01));

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
```

**步骤5：运行业务逻辑测试**

Run: `flutter test test/services/`
Expected: All tests pass

**步骤6：提交代码**

```bash
git add lib/services/ test/services/
git commit -m "feat: 实现业务逻辑服务层（百分比计算、再平衡计算）"
```

---

### 任务5：状态管理层实现

**文件：**
- 创建：`lib/providers/portfolio_provider.dart`
- 创建：`test/providers/portfolio_provider_test.dart`

**步骤1：创建lib/providers/portfolio_provider.dart状态管理**

```dart
import 'package:flutter/foundation.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/models/portfolio.dart';
import 'package:investment_app/services/hive_service.dart';
import 'package:investment_app/services/portfolio_calculator.dart';
import 'package:investment_app/services/rebalance_calculator.dart';

class PortfolioProvider with ChangeNotifier {
  Portfolio? _portfolio;
  PortfolioCalculator? _calculator;
  RebalanceCalculator? _rebalanceCalculator;

  Portfolio? get portfolio => _portfolio;
  PortfolioCalculator? get calculator => _calculator;
  RebalanceCalculator? get rebalanceCalculator => _rebalanceCalculator;

  bool get isLoaded => _portfolio != null;
  bool get hasWarnings => _calculator?.hasAnyWarning ?? false;
  bool get needsRebalancing => _rebalanceCalculator?.needsRebalancing ?? false;

  double get totalAmount => _portfolio?.totalAmount ?? 0;

  Map<PortfolioCategory, double> get categoryPercentages {
    return _calculator?.calculateCategoryPercentages() ?? {};
  }

  Map<PortfolioCategory, double> get categoryDeviations {
    return _calculator?.calculateDeviations() ?? {};
  }

  List<Fund> getAllFunds() {
    return _portfolio?.funds ?? [];
  }

  List<Fund> getFundsByCategory(PortfolioCategory category) {
    return _portfolio?.getFundsByCategory(category) ?? [];
  }

  Future<void> loadPortfolio() async {
    _portfolio = HiveService.getPortfolio();
    _calculator = PortfolioCalculator(portfolio: _portfolio!);
    _rebalanceCalculator = RebalanceCalculator(portfolio: _portfolio!);
    notifyListeners();
  }

  Future<void> addFund(Fund fund) async {
    await HiveService.addFund(fund);
    await loadPortfolio();
  }

  Future<void> updateFund(Fund fund) async {
    await HiveService.updateFund(fund);
    await loadPortfolio();
  }

  Future<void> deleteFund(String fundId) async {
    await HiveService.deleteFund(fundId);
    await loadPortfolio();
  }

  Future<void> recordRebalance() async {
    await HiveService.saveLastRebalanced(DateTime.now());
    await loadPortfolio();
  }

  List<RebalanceAction> getRebalanceActions() {
    return _rebalanceCalculator?.generateRebalanceActions() ?? [];
  }

  List<PortfolioCategory> getWarningCategories() {
    return _calculator?.getWarningCategories() ?? [];
  }
}
```

**步骤2：创建test/providers/portfolio_provider_test.dart状态管理测试**

```dart
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
```

**步骤3：运行状态管理测试**

Run: `flutter test test/providers/`
Expected: All tests pass

**步骤4：提交代码**

```bash
git add lib/providers/ test/providers/
git commit -m "feat: 实现状态管理层（PortfolioProvider）"
```

---

### 任务6：主题与常量定义

**文件：**
- 创建：`lib/theme/app_theme.dart`
- 创建：`lib/utils/constants.dart`
- 创建：`lib/utils/formatters.dart`

**步骤1：创建lib/theme/app_theme.dart主题配置**

```dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF1976D2);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color secondary = Color(0xFF26A69A);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFF9800);
  static const Color success = Color(0xFF4CAF50);

  static const Color stockColor = Color(0xFF2196F3);
  static const Color bondColor = Color(0xFF4CAF50);
  static const Color cashColor = Color(0xFF9E9E9E);
  static const Color goldColor = Color(0xFFFFD700);

  static const TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.black87,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Colors.black87,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  );

  static ThemeData get light {
    return ThemeData(
      primaryColor: primary,
      primaryColorDark: primaryDark,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        error: error,
        surface: surface,
        background: background,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: surface,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      primaryColor: primary,
      scaffoldBackgroundColor: Colors.grey[900],
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
      ),
      textTheme: textTheme.apply(bodyColor: Colors.white),
    );
  }

  static Color getCategoryColor(PortfolioCategory category) {
    switch (category) {
      case PortfolioCategory.stock:
        return stockColor;
      case PortfolioCategory.bond:
        return bondColor;
      case PortfolioCategory.cash:
        return cashColor;
      case PortfolioCategory.gold:
        return goldColor;
    }
  }
}
```

**步骤2：创建lib/utils/constants.dart常量定义**

```dart
import 'package:flutter/material.dart';
import 'package:investment_app/models/fund.dart';

class AppConstants {
  static const double warningThreshold = 0.2;
  static const double rebalanceThreshold = 0.05;
  
  static const List<Color> chartColors = [
    Color(0xFF2196F3),
    Color(0xFF4CAF50),
    Color(0xFF9E9E9E),
    Color(0xFFFFD700),
  ];
  
  static const Map<PortfolioCategory, String> categoryDescriptions = {
    PortfolioCategory.stock: '股票型基金、权益类投资',
    PortfolioCategory.bond: '债券型基金、国债、企业债',
    PortfolioCategory.cash: '货币基金、现金管理',
    PortfolioCategory.gold: '黄金ETF、大宗商品',
  };
}
```

**步骤3：创建lib/utils/formatters.dart格式化工具**

```dart
import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'zh_CN',
    symbol: '¥',
    decimalDigits: 2,
  );

  static final NumberFormat percentFormat = NumberFormat.percentPattern('zh_CN');

  static String formatCurrency(double amount) {
    return currencyFormat.format(amount);
  }

  static String formatPercent(double value) {
    return percentFormat.format(value);
  }

  static String formatDate(DateTime date) {
    return DateFormat('yyyy年MM月dd日', 'zh_CN').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy年MM月dd日 HH:mm', 'zh_CN').format(dateTime);
  }
}
```

**步骤4：提交代码**

```bash
git add lib/theme/ lib/utils/
git commit -m "feat: 定义主题、常量和格式化工具"
```

---

### 任务7：通用UI组件实现

**文件：**
- 创建：`lib/widgets/category_card.dart`
- 创建：`lib/widgets/fund_card.dart`
- 创建：`lib/widgets/warning_banner.dart`
- 创建：`lib/widgets/pie_chart_widget.dart`

**步骤1：创建lib/widgets/category_card.dart类别卡片组件**

```dart
import 'package:flutter/material.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/theme/app_theme.dart';
import 'package:investment_app/utils/formatters.dart';

class CategoryCard extends StatelessWidget {
  final PortfolioCategory category;
  final double currentAmount;
  final double targetAmount;
  final double currentPercentage;
  final double targetPercentage;

  const CategoryCard({
    super.key,
    required this.category,
    required this.currentAmount,
    required this.targetAmount,
    required this.currentPercentage,
    required this.targetPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getCategoryColor(category);
    final deviation = currentPercentage - targetPercentage;
    final deviationText = deviation >= 0 ? '+${(deviation * 100).toStringAsFixed(1)}%' : '${(deviation * 100).toStringAsFixed(1)}%';
    final deviationColor = deviation > 0 ? Colors.red : deviation < 0 ? Colors.blue : Colors.green;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  category.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  Formatters.formatPercent(currentPercentage),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: currentPercentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '当前: ${Formatters.formatCurrency(currentAmount)}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  '目标: ${Formatters.formatCurrency(targetAmount)}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '偏离: $deviationText',
              style: TextStyle(
                fontSize: 14,
                color: deviationColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**步骤2：创建lib/widgets/fund_card.dart基金卡片组件**

```dart
import 'package:flutter/material.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/theme/app_theme.dart';
import 'package:investment_app/utils/formatters.dart';

class FundCard extends StatelessWidget {
  final Fund fund;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const FundCard({
    super.key,
    required this.fund,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getCategoryColor(fund.category);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    fund.code.substring(0, min(4, fund.code.length)),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fund.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fund.code,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        fund.category.displayName,
                        style: TextStyle(
                          fontSize: 10,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.formatCurrency(fund.amount),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: onEdit,
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                        onPressed: onDelete,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**步骤3：创建lib/widgets/warning_banner.dart警告横幅组件**

```dart
import 'package:flutter/material.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/theme/app_theme.dart';

class WarningBanner extends StatelessWidget {
  final List<PortfolioCategory> warningCategories;

  const WarningBanner({
    super.key,
    required this.warningCategories,
  });

  @override
  Widget build(BuildContext context) {
    if (warningCategories.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.warning.withOpacity(0.1),
        border: Border.all(color: AppTheme.warning),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: AppTheme.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '投资比例失衡提醒',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.warning,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '以下类别超出正常范围: ${warningCategories.map((c) => c.displayName).join('、')}',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('查看详情'),
          ),
        ],
      ),
    );
  }
}
```

**步骤4：创建lib/widgets/pie_chart_widget.dart饼图组件**

```dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/theme/app_theme.dart';

class PieChartWidget extends StatelessWidget {
  final Map<PortfolioCategory, double> percentages;
  final double totalAmount;

  const PieChartWidget({
    super.key,
    required this.percentages,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final pieData = percentages.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value * 100,
        color: AppTheme.getCategoryColor(entry.key),
        title: '${(entry.value * 100).toStringAsFixed(0)}%',
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: pieData,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: percentages.entries.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppTheme.getCategoryColor(entry.key),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  entry.key.displayName,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
```

**步骤5：提交代码**

```bash
git add lib/widgets/
git commit -m "feat: 实现通用UI组件（CategoryCard、FundCard、WarningBanner、PieChartWidget）"
```

---

### 任务8：功能A-基金录入页面实现

**文件：**
- 创建：`lib/screens/fund/fund_form_screen.dart`
- 修改：`lib/screens/fund/fund_list_screen.dart`

**步骤1：创建lib/screens/fund/fund_form_screen.dart基金表单页面**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/theme/app_theme.dart';
import 'package:investment_app/utils/formatters.dart';

class FundFormScreen extends StatefulWidget {
  final Fund? fund;

  const FundFormScreen({super.key, this.fund});

  @override
  State<FundFormScreen> createState() => _FundFormScreenState();
}

class _FundFormScreenState extends State<FundFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _amountController;
  PortfolioCategory _selectedCategory = PortfolioCategory.stock;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _codeController = TextEditingController();
    _amountController = TextEditingController();

    if (widget.fund != null) {
      _isEditing = true;
      _nameController.text = widget.fund!.name;
      _codeController.text = widget.fund!.code;
      _amountController.text = widget.fund!.amount.toString();
      _selectedCategory = widget.fund!.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveFund() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<PortfolioProvider>(context, listen: false);
    final amount = double.parse(_amountController.text);

    final fund = Fund(
      id: widget.fund?.id,
      name: _nameController.text,
      code: _codeController.text,
      amount: amount,
      category: _selectedCategory,
    );

    if (_isEditing) {
      await provider.updateFund(fund);
    } else {
      await provider.addFund(fund);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑基金' : '添加基金'),
        actions: [
          TextButton(
            onPressed: _saveFund,
            child: const Text('保存'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '基金名称',
                hintText: '输入基金名称',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入基金名称';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: '基金代码',
                hintText: '输入基金代码',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入基金代码';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: '投资金额',
                prefixText: '¥',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入投资金额';
                }
                if (double.tryParse(value) == null) {
                  return '请输入有效金额';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PortfolioCategory>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: '投资类别',
              ),
              items: PortfolioCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveFund,
              child: Text(_isEditing ? '更新基金' : '添加基金'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**步骤2：创建lib/screens/fund/fund_list_screen.dart基金列表页面**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/widgets/fund_card.dart';
import 'package:investment_app/screens/fund/fund_form_screen.dart';

class FundListScreen extends StatelessWidget {
  const FundListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final funds = provider.getAllFunds();

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的基金'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const FundFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: funds.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    '还没有添加基金',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const FundFormScreen()),
                      );
                    },
                    child: const Text('添加第一个基金'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: funds.length,
              itemBuilder: (context, index) {
                final fund = funds[index];
                return FundCard(
                  fund: fund,
                  onTap: () {},
                  onEdit: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FundFormScreen(fund: fund),
                      ),
                    );
                  },
                  onDelete: () {
                    _showDeleteDialog(context, fund);
                  },
                );
              },
            ),
    );
  }

  void _showDeleteDialog(BuildContext context, Fund fund) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除基金'),
        content: Text('确定要删除 "${fund.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              await Provider.of<PortfolioProvider>(context, listen: false)
                  .deleteFund(fund.id);
              if (mounted) Navigator.of(context).pop();
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
```

**步骤3：创建lib/screens/home/home_screen.dart主页面（集成基金列表入口）**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/screens/home/dashboard_screen.dart';
import 'package:investment_app/screens/fund/fund_list_screen.dart';
import 'package:investment_app/screens/analysis/analysis_screen.dart';
import 'package:investment_app/screens/rebalance/rebalance_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const FundListScreen(),
    const AnalysisScreen(),
    const RebalanceScreen(),
  ];

  final List<String> _titles = ['仪表盘', '基金列表', '分析', '再平衡'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PortfolioProvider>(context, listen: false).loadPortfolio();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: '仪表盘',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: '基金',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: '分析',
          ),
          NavigationDestination(
            icon: Icon(Icons.balance),
            label: '再平衡',
          ),
        ],
      ),
    );
  }
}
```

**步骤4：创建占位页面（后续任务会完善）**

```dart
// lib/screens/home/dashboard_screen.dart
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('仪表盘页面'));
  }
}

// lib/screens/analysis/analysis_screen.dart
import 'package:flutter/material.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('分析页面'));
  }
}

// lib/screens/rebalance/rebalance_screen.dart
import 'package:flutter/material.dart';

class RebalanceScreen extends StatelessWidget {
  const RebalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('再平衡页面'));
  }
}
```

**步骤5：测试基金录入功能**

Run: `flutter test`
Expected: All tests pass

**步骤6：提交代码**

```bash
git add lib/screens/
git commit -m "feat: 实现基金录入功能（FundFormScreen、FundListScreen）"
```

---

### 任务9：功能B-统计可视化页面实现

**文件：**
- 修改：`lib/screens/home/dashboard_screen.dart`
- 修改：`lib/screens/analysis/analysis_screen.dart`

**步骤1：完善lib/screens/home/dashboard_screen.dart仪表盘页面**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/theme/app_theme.dart';
import 'package:investment_app/utils/formatters.dart';
import 'package:investment_app/widgets/pie_chart_widget.dart';
import 'package:investment_app/widgets/warning_banner.dart';
import 'package:investment_app/widgets/category_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final percentages = provider.categoryPercentages;
    final warnings = provider.getWarningCategories();

    if (!provider.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WarningBanner(warningCategories: warnings),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '总资产',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.formatCurrency(provider.totalAmount),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                if (provider.totalAmount > 0) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          PieChartWidget(
                            percentages: percentages,
                            totalAmount: provider.totalAmount,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...PortfolioCategory.values.map((category) {
                    final target = TargetAllocation.getTarget(category);
                    return CategoryCard(
                      category: category,
                      currentAmount: provider.portfolio?.getAmountByCategory(category) ?? 0,
                      targetAmount: provider.totalAmount * target,
                      currentPercentage: percentages[category] ?? 0,
                      targetPercentage: target,
                    );
                  }),
                ] else ...[
                  Center(
                    child: Column(
                      children: [
                        const Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          '添加基金后查看资产分布',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

**步骤2：完善lib/screens/analysis/analysis_screen.dart分析页面**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/theme/app_theme.dart';
import 'package:investment_app/utils/formatters.dart';
import 'package:investment_app/widgets/category_card.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final portfolio = provider.portfolio;
    final percentages = provider.categoryPercentages;
    final deviations = provider.categoryDeviations;

    if (!provider.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '投资分析',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '各类别详情',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  ...PortfolioCategory.values.map((category) {
                    final categoryFunds = provider.getFundsByCategory(category);
                    final categoryAmount = portfolio?.getAmountByCategory(category) ?? 0;
                    final target = TargetAllocation.getTarget(category);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppTheme.getCategoryColor(category),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category.displayName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              Formatters.formatCurrency(categoryAmount),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.description,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        if (categoryFunds.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          ...categoryFunds.map((fund) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      fund.name,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Text(
                                    Formatters.formatCurrency(fund.amount),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '目标配置对比',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  ...PortfolioCategory.values.map((category) {
                    final currentPct = percentages[category] ?? 0;
                    final targetPct = TargetAllocation.getTarget(category);
                    final deviation = deviations[category] ?? 0;
                    final deviationPct = deviation * 100;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(category.displayName),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${(currentPct * 100).toStringAsFixed(1)}%',
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${(targetPct * 100).toStringAsFixed(0)}%',
                              textAlign: TextAlign.end,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              deviationPct >= 0 ? '+${deviationPct.toStringAsFixed(1)}%' : '${deviationPct.toStringAsFixed(1)}%',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: deviationPct > 0 ? Colors.red : deviationPct < 0 ? Colors.blue : Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

**步骤3：测试统计可视化功能**

Run: `flutter test`
Expected: All tests pass

**步骤4：提交代码**

```bash
git add lib/screens/
git commit -m "feat: 实现统计可视化功能（DashboardScreen、AnalysisScreen）"
```

---

### 任务10：功能C-监控提醒页面实现

**文件：**
- 修改：`lib/screens/home/dashboard_screen.dart`（添加警告横幅）
- 修改：`lib/widgets/warning_banner.dart`（完善警告逻辑）

**步骤1：完善lib/screens/home/dashboard_screen.dart中的警告功能**

```dart
// 在DashboardScreen的build方法中添加警告检测
bool _hasWarnings = provider.hasWarnings;
List<PortfolioCategory> _warningCategories = provider.getWarningCategories();
```

**步骤2：完善警告横幅组件交互**

```dart
// 在WarningBanner中添加导航到分析页面的功能
onPressed: () {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const AnalysisScreen()),
  );
},
```

**步骤3：测试监控提醒功能**

Run: `flutter test`
Expected: All tests pass

**步骤4：提交代码**

```bash
git add lib/screens/ lib/widgets/
git commit -m "feat: 实现监控提醒功能"
```

---

### 任务11：功能D-再平衡指引页面实现

**文件：**
- 修改：`lib/screens/rebalance/rebalance_screen.dart`

**步骤1：完善lib/screens/rebalance/rebalance_screen.dart再平衡页面**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/services/rebalance_calculator.dart';
import 'package:investment_app/theme/app_theme.dart';
import 'package:investment_app/utils/formatters.dart';

class RebalanceScreen extends StatelessWidget {
  const RebalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final rebalanceCalculator = provider.rebalanceCalculator;
    final actions = provider.getRebalanceActions();
    final needsRebalancing = provider.needsRebalancing;

    if (!provider.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: needsRebalancing
                ? AppTheme.warning.withOpacity(0.1)
                : AppTheme.success.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    needsRebalancing ? Icons.warning_amber : Icons.check_circle,
                    color: needsRebalancing ? AppTheme.warning : AppTheme.success,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          needsRebalancing ? '需要再平衡' : '投资组合平衡',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: needsRebalancing
                                ? AppTheme.warning
                                : AppTheme.success,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          needsRebalancing
                              ? '当前投资比例与目标有较大偏离，建议进行调整'
                              : '投资比例在正常范围内，保持当前配置',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '调整建议',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (actions.isEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, size: 48, color: AppTheme.success),
                    const SizedBox(height: 16),
                    const Text(
                      '投资组合已平衡',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '各类别投资比例接近目标，无需调整',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            ...actions.map((action) {
              final color = AppTheme.getCategoryColor(action.category);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: action.isBuy
                              ? AppTheme.success.withOpacity(0.1)
                              : AppTheme.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          action.isBuy ? Icons.add_circle : Icons.remove_circle,
                          color: action.isBuy ? AppTheme.success : AppTheme.warning,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              action.category.displayName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              action.isBuy ? '增加投资' : '减少投资',
                              style: TextStyle(
                                fontSize: 14,
                                color: action.isBuy
                                    ? AppTheme.success
                                    : AppTheme.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        Formatters.formatCurrency(action.amount),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            if (needsRebalancing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await provider.recordRebalance();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('已记录再平衡操作')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                  ),
                  child: const Text('记录本次再平衡'),
                ),
              ),
          ],
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '什么是再平衡？',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '再平衡是指调整投资组合，使其回到目标配置比例。当某类资产因涨跌而占比偏离目标时，通过买入或卖出使其回归平衡。',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '建议：当某类别偏离目标超过5%时考虑再平衡。',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

**步骤2：测试再平衡功能**

Run: `flutter test`
Expected: All tests pass

**步骤3：提交代码**

```bash
git add lib/screens/
git commit -m "feat: 实现再平衡指引功能（RebalanceScreen）"
```

---

### 任务12：最终测试与完善

**步骤1：运行完整测试套件**

Run: `flutter test --coverage`
Expected: All tests pass, coverage > 80%

**步骤2：检查代码规范**

Run: `flutter analyze`
Expected: No errors, no warnings

**步骤3：构建测试**

Run: `flutter build apk --debug`
Expected: Build successful

**步骤4：提交最终版本**

```bash
git add .
git commit -m "feat: 完成永久投资组合模拟器所有功能开发"
git tag v1.0.0
```

---

## 执行选项

**计划完成并已保存至 `docs/plans/2026-02-03-investment-app.md`。两种执行方式：**

**1. Subagent-Driven（本会话）** - 我为每个任务启动独立子代理，任务间审查，迭代快速

**2. Parallel Session（单独会话）** - 在工作树中打开新会话批量执行，有检查点

**选择哪种方式？**
