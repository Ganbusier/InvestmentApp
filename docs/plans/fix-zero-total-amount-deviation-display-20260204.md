# 修复总金额为0时显示错误偏离度问题

## 问题描述

当总投资金额（totalAmount）为0时：
- 每个类别都显示 -25% 偏离度
- 但实际上投资组合为空，应被视为"平衡"状态

## 问题根源

`calculateDeviations()` 方法计算逻辑：
```dart
deviations[category] = percentages[category]! - target; // 0 - 0.25 = -0.25
```

当 `totalAmount == 0` 时，`percentages[category]` 为 0，导致每个类别都显示 -25% 偏离。

## 修复方案

### 1. 修改 portfolio_calculator.dart

**修改 `calculateDeviations()` 方法：**

```dart
Map<PortfolioCategory, double> calculateDeviations() {
  final percentages = calculateCategoryPercentages();
  final deviations = <PortfolioCategory, double>{};
  final total = portfolio.totalAmount;

  // 当总投资金额为 0 时，所有类别偏离度为 0（视为平衡状态）
  if (total == 0) {
    for (final category in PortfolioCategory.values) {
      deviations[category] = 0;
    }
    return deviations;
  }

  for (final category in PortfolioCategory.values) {
    final target = TargetAllocation.getTarget(category);
    deviations[category] = percentages[category]! - target;
  }

  return deviations;
}
```

### 2. 修改 UI 显示逻辑

在 statistics_screen.dart 和 rebalance_screen.dart 中，当偏离度为 0 时显示 "平衡"。

**修改 statistics_screen.dart：**

```dart
final deviationText = deviation == 0
    ? '平衡'
    : deviation >= 0
        ? '+${(deviation * 100).toStringAsFixed(1)}%'
        : '${(deviation * 100).toStringAsFixed(1)}%';
```

**修改 rebalance_screen.dart：**

```dart
final deviationText = deviation == 0
    ? '平衡'
    : deviation >= 0
        ? '+${(deviation * 100).toStringAsFixed(1)}%'
        : '${(deviation * 100).toStringAsFixed(1)}%';
```

## 验证步骤

1. 运行 `flutter analyze` 检查是否有错误
2. 测试场景：
   - 投资组合为空（totalAmount = 0）时，检查统计页面和再平衡页面
   - 确认不显示 -25% 偏离
   - 确认显示 "平衡" 状态

## 修改文件清单

| 文件 | 修改 |
|------|------|
| `lib/services/portfolio_calculator.dart` | 修改 `calculateDeviations()` 方法 |
| `lib/screens/statistics_screen.dart` | 修改偏离度显示，0% 时显示"平衡" |
| `lib/screens/rebalance_screen.dart` | 修改偏离度显示，0% 时显示"平衡" |

## 备注

- 此修复仅处理 `totalAmount == 0` 的情况
- 当 `totalAmount > 0` 时，即使类别金额很小，偏离度仍按实际计算
