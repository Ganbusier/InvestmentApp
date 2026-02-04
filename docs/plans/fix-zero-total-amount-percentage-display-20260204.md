# 修复总金额为0时百分比显示为0%的问题

## 问题描述

当总投资金额（totalAmount）为0时：
- 各类别当前百分比显示 0%
- 应该显示 25%（与目标比例一致）

## 问题根源

`calculateCategoryPercentages()` 方法在 total == 0 时返回 0：

```dart
if (total == 0) {
  for (final category in PortfolioCategory.values) {
    percentages[category] = 0;  // ❌ 应该是 0.25
  }
  return percentages;
}
```

## 修复方案

### 1. 修改 portfolio_calculator.dart - calculateCategoryPercentages()

当 total == 0 时，每个类别返回 0.25：

```dart
if (total == 0) {
  for (final category in PortfolioCategory.values) {
    percentages[category] = 0.25;  // ✅ 25%
  }
  return percentages;
}
```

### 2. 恢复 calculateDeviations() 的原有逻辑

由于 percentage 现在返回 25%，偏离度自然为 0（25% - 25% = 0%），恢复原有逻辑：

```dart
Map<PortfolioCategory, double> calculateDeviations() {
  final percentages = calculateCategoryPercentages();
  final deviations = <PortfolioCategory, double>{};

  for (final category in PortfolioCategory.values) {
    final target = TargetAllocation.getTarget(category);
    deviations[category] = percentages[category]! - target;
  }

  return deviations;
}
```

### 3. 恢复 UI 显示的偏离度判断逻辑

由于 percentage 不再为 0，将之前 M29 的修改恢复为原来的逻辑：

- `statistics_screen.dart`: `percentage == 0` → `deviation == 0`
- `rebalance_screen.dart`: `percentage == 0` → `deviation == 0`
- `category_card.dart`: `currentPercentage == 0` → 恢复原逻辑

### 4. 恢复 needsRebalancing() 和 getCategoriesWithWarning() 的原有逻辑

由于 calculateDeviations() 现在在 total == 0 时返回正确的 0，恢复原有逻辑：

- `portfolio_calculator.dart - getCategoriesWithWarning()`: 移除 totalAmount == 0 的特殊判断
- `rebalance_calculator.dart - needsRebalancing()`: 移除 totalAmount == 0 的特殊判断

## 修复文件清单

| 文件 | 修改 |
|------|------|
| `lib/services/portfolio_calculator.dart` | calculateDeviations() 恢复原有逻辑，getCategoriesWithWarning() 恢复原有逻辑 |
| `lib/screens/statistics_screen.dart` | deviationText 判断恢复为 deviation == 0 |
| `lib/screens/rebalance_screen.dart` | deviationText 判断恢复为 deviation == 0 |
| `lib/widgets/category_card.dart` | deviationText 判断恢复原逻辑 |

## 验证步骤

1. 运行 `flutter analyze` 检查是否有错误
2. 测试场景：
   - 投资组合为空时，各页面类别显示 25%
   - 偏离度显示 "平衡"
   - 首页不显示警告 widget

## 预期效果

| 页面 | 空状态显示 |
|------|-----------|
| 首页类别卡片 | 25%，偏离"平衡" |
| 统计页面类别详情 | 25%，偏离"平衡" |
| 再平衡当前配置 | 25%，偏离"平衡" |
| 首页警告 | 不显示 |

## 备注

此修复是对 M28-M29 的纠正：
- M28：修复偏离度显示（方向错误）
- M29：修复警告状态（方向错误）
- M30：正确的修复方案
