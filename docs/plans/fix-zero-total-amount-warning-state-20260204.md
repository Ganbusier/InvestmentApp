# 修复总金额为0时错误显示警告问题

## 问题描述

当总投资金额（totalAmount）为0时：
1. 首页显示"部分投资类别偏离目标配置，请关注"警告
2. 但点击"查看详情"后，统计页面和再平衡页面显示"投资组合已平衡"

## 问题根源

### 1. hasWarnings / needsRebalancing 逻辑

当 `portfolio.totalAmount == 0` 时：

| 方法 | 当前行为 | 问题 |
|------|---------|------|
| `getCategoriesWithWarning()` | 每个类别都返回 `isDeficient(0) = true` | 0 < 0.2 被判断为"不足" |
| `needsRebalancing()` | 依赖 `calculateDeviations()` 返回 0 | 实际上应该是 false |

### 2. isDeficient 逻辑

```dart
static bool isDeficient(PortfolioCategory category, double currentPercentage) {
  final target = getTarget(category); // 0.25
  return currentPercentage < target * 0.8; // 0 < 0.2 => true
}
```

## 修复方案

### 1. 修改 portfolio_calculator.dart - getCategoriesWithWarning()

```dart
Map<PortfolioCategory, bool> getCategoriesWithWarning() {
  // 当总投资金额为 0 时，不显示任何警告（视为平衡状态）
  if (portfolio.totalAmount == 0) {
    return {};
  }

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
```

### 2. 修改 rebalance_calculator.dart - needsRebalancing()

```dart
bool get needsRebalancing {
  // 当总投资金额为 0 时，视为平衡状态
  if (totalAmount == 0) {
    return false;
  }

  final deviations = PortfolioCalculator(portfolio: portfolio).calculateDeviations();
  return deviations.values.any((dev) => dev.abs() > 0.05);
}
```

## 修复文件清单

| 文件 | 修改 |
|------|------|
| `lib/services/portfolio_calculator.dart` | `getCategoriesWithWarning()` 增加 totalAmount == 0 判断 |
| `lib/services/rebalance_calculator.dart` | `needsRebalancing()` 增加 totalAmount == 0 判断 |

## 验证步骤

1. 运行 `flutter analyze` 检查是否有错误
2. 测试场景：
   - 投资组合为空时，首页不显示警告 widget
   - 进入统计页面，确认显示"投资组合已平衡"
   - 进入再平衡页面，确认显示"投资组合已平衡"

## 备注

此修复与以下修复配合使用：
- M28：修复总金额为0时显示错误偏离度
- M28 补充：修复首页类别卡片偏离度显示
