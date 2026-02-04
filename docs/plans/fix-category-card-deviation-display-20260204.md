# 修复首页类别卡片显示错误偏离度问题

## 问题描述

在之前的修复中遗漏了 `category_card.dart` 组件。

当总投资金额（totalAmount）为0时，首页的类别卡片仍显示 -25% 偏离度，而不是"平衡"状态。

## 问题根源

`category_card.dart` 接收 `currentPercentage` 和 `targetPercentage` 作为参数，自己计算偏离度：

```dart
final deviation = widget.currentPercentage - widget.targetPercentage;
// 当 totalAmount == 0 时：0 - 0.25 = -0.25
```

## 修复方案

### 修改文件：lib/widgets/category_card.dart

在 `build()` 方法中，当 `currentPercentage == 0` 时，偏离度显示为 "平衡"：

```dart
final deviation = widget.currentPercentage - widget.targetPercentage;
final deviationText = widget.currentPercentage == 0
    ? '平衡'
    : deviation >= 0
        ? '+${(deviation * 100).toStringAsFixed(1)}%'
        : '${(deviation * 100).toStringAsFixed(1)}%';
```

## 修复文件清单

| 文件 | 修改 |
|------|------|
| `lib/widgets/category_card.dart` | 修复偏离度显示，0% 时显示"平衡" |

## 验证步骤

1. 运行 `flutter analyze` 检查是否有错误
2. 测试场景：
   - 投资组合为空时，检查首页类别卡片
   - 确认不显示 -25% 偏离
   - 确认显示"平衡"状态

## 备注

此修复是 M28 的补充：
- `portfolio_calculator.dart` - calculateDeviations() 返回 0
- `statistics_screen.dart` - 0% 时显示"平衡"
- `rebalance_screen.dart` - 0% 时显示"平衡"
- `category_card.dart` - 0% 时显示"平衡"
