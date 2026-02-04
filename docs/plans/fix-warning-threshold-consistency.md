# 修复首页警告与再平衡阈值一致性

## 问题描述

更新再平衡阈值后，即使所有类别的偏移值都在阈值之内，首页仍然会显示警告"部分投资类别偏离目标配置"。

## 问题根源

首页警告与再平衡判断使用了**不同的阈值标准**：

| 功能 | 判断逻辑 | 阈值来源 |
|-----|---------|---------|
| 首页警告 `hasWarnings` | `TargetAllocation.isExcessive/Deficient()` | **固定阈值 ±20%** |
| 再平衡 `needsRebalancing` | `deviation.abs() > threshold` | **用户自定义阈值** |

**`TargetAllocation` 的固定阈值** (target_allocation.dart:19-27)：
```dart
isExcessive: currentPercentage > target * 1.20   // 超过120%
isDeficient: currentPercentage < target * 0.80   // 低于80%
```

**问题场景**：
```
用户设置阈值: 15%
类别实际偏差: 10%（在阈值内）

首页警告判断:
  - TargetAllocation 固定阈值: 10% < 20% → 标记为"不足"
  - 显示警告 ❌

再平衡判断:
  - 用户阈值: 10% < 15% → 不需要再平衡
  - 不显示建议 ✅
```

## 修复方案

在 `PortfolioProvider` 中添加一个考虑用户阈值的方法：

```dart
bool get hasWarningsConsideringThreshold {
  if (rebalanceCalculator == null) return false;
  return rebalanceCalculator!.needsRebalancing;
}
```

修改首页使用此方法：
```dart
if (provider.hasWarningsConsideringThreshold)  // 替换 hasWarnings
  WarningBanner(...);
```

## 实施步骤

1. 在 `PortfolioProvider` 中添加 `hasWarningsConsideringThreshold` getter
2. 修改 `home_screen.dart`，将 `hasWarnings` 替换为 `hasWarningsConsideringThreshold`
3. 运行测试验证

## 预期效果

| 场景 | 修复前 | 修复后 |
|-----|-------|-------|
| 偏差 10%，阈值 15% | 显示警告 ❌ | 不显示警告 ✅ |
| 偏差 20%，阈值 15% | 显示警告 ❌ | 显示警告 ✅ |
| 偏差 25%，阈值 20% | 显示警告 ✅ | 显示警告 ✅ |

## 验证结果

```
flutter test: ✅ 8 passed
flutter analyze: ✅ 0 errors
```
