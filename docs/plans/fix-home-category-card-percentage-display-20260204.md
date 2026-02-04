# 修复首页类别卡片百分比显示错误问题

## 问题描述

总金额为0时，首页类别卡片显示占比0%，偏离25%，但应该显示占比25%，偏离0%。

## 问题根源

首页类别卡片使用 `Portfolio.getPercentageByCategory()` 获取百分比，而该方法在 `totalAmount == 0` 时返回 0：

```dart
double getPercentageByCategory(PortfolioCategory category) {
  final categoryAmount = getAmountByCategory(category);
  if (totalAmount == 0) return 0;  // ❌ 返回 0%
  return categoryAmount / totalAmount;
}
```

而 `PortfolioCalculator.calculateCategoryPercentages()` 已经修改为返回 0.25，但首页没有使用该方法。

## 数据源对比

| 组件 | 数据源 | totalAmount==0 时返回值 |
|------|--------|------------------------|
| CategoryCard | `Portfolio.getPercentageByCategory()` | **0%** ❌ |
| PieChartWidget | `provider.categoryPercentages` | **25%** ✅ |

## 修复方案

修改 `lib/models/portfolio.dart` 的 `getPercentageByCategory()` 方法：

```dart
double getPercentageByCategory(PortfolioCategory category) {
  final categoryAmount = getAmountByCategory(category);
  if (totalAmount == 0) return 0.25;  // ✅ 返回 25%
  return categoryAmount / totalAmount;
}
```

## 修复文件清单

| 文件 | 修改 |
|------|------|
| `lib/models/portfolio.dart` | `getPercentageByCategory()` 返回 0.25 |

## 验证步骤

1. 运行 `flutter analyze` 检查是否有错误
2. 测试场景：
   - 投资组合为空时，检查首页类别卡片
   - 确认显示 25% 占比
   - 确认偏离度显示 "平衡"

## 预期效果

| 页面 | 空状态显示 |
|------|-----------|
| 首页类别卡片 | 25%，偏离"平衡" |

## 备注

此修复配合 M30 使用，M30 修改了 `PortfolioCalculator.calculateCategoryPercentages()` 返回 0.25，但遗漏了 `Portfolio.getPercentageByCategory()` 方法。
