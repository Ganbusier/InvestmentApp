# 再平衡阈值功能修复方案

## 问题描述

再平衡阈值功能不能正常工作。用户设置阈值后，系统没有按照阈值来控制再平衡行为。

### 预期行为
- 阈值=15%：只有当某个类别偏离目标超过15%时才触发再平衡
- 低于阈值的偏差不应产生操作建议、预览或实际执行

### 当前问题
1. `generateRebalanceActions()` 使用硬编码 `adjustment.abs() > 1`，未使用阈值
2. `previewRebalance()` 未使用阈值，始终显示所有变化
3. `executeRebalance()` 未使用阈值，始终执行所有调整

## 修复方案

### 1. 修改 `generateRebalanceActions()` 
位置：`lib/services/rebalance_calculator.dart:40-56`

使用阈值过滤需要调整的类别：
```dart
for (final category in PortfolioCategory.values) {
  final adjustment = adjustments[category]!;
  final currentPercentage = portfolio.getAmountByCategory(category) / totalAmount;
  final targetPercentage = TargetAllocation.getTarget(category);
  final deviation = (currentPercentage - targetPercentage).abs();
  
  if (deviation > threshold) {
    actions.add(RebalanceAction(
      category: category,
      amount: adjustment.abs(),
      isBuy: adjustment > 0,
    ));
  }
}
```

### 2. 修改 `previewRebalance()`
位置：`lib/providers/portfolio_provider.dart:197-258`

在生成 fundChanges 时，过滤掉偏差小于阈值的基金：
```dart
// 只计算偏差超过阈值的类别变化
for (final fund in _portfolio!.funds) {
  final category = fund.category;
  final categoryPercentage = categoryTotals[category]! / totalAmount;
  final targetPercentage = 0.25; // 或使用 TargetAllocation.getTarget(category)
  final deviation = (categoryPercentage - targetPercentage).abs();
  
  if (deviation < rebalanceThreshold) continue; // 跳过低于阈值的类别
  // ... 原有逻辑
}
```

### 3. 修改 `executeRebalance()`
位置：`lib/providers/portfolio_provider.dart:260-300`

只执行偏差超过阈值的调整

## 实现步骤

1. 修改 `RebalanceCalculator.generateRebalanceActions()` 使用阈值
2. 修改 `PortfolioProvider.previewRebalance()` 使用阈值
3. 修改 `PortfolioProvider.executeRebalance()` 使用阈值
4. 运行测试验证修复
5. 运行 lint 检查

## 验收标准

1. 设置阈值为15%时，偏差低于15%的类别不会出现在操作建议中
2. 预览页面只显示需要调整的变化
3. 执行再平衡时只执行超过阈值的调整
4. 所有现有测试通过

## 额外修复：除以零问题

### 问题
在计算百分比时 `portfolio.getAmountByCategory(category) / totalAmount`，当 totalAmount 为 0 时会导致除以零错误。

### 修复方案

#### 1. rebalance_calculator.dart
在 `generateRebalanceActions()` 开头添加检查：
```dart
if (totalAmount == 0) {
  return actions;  // 空投资组合无需调整
}
```

#### 2. portfolio_provider.dart
在 `previewRebalance()` 中已处理空投资组合的情况，但在计算百分比时需要添加检查：
```dart
if (totalAmount == 0) {
  return RebalancePreview(
    categoryChanges: {},
    fundChanges: [],
    totalBuy: 0,
    totalSell: 0,
  );
}
```

## 依赖和前提条件

- TargetAllocation 类已存在并可用
- RebalanceCalculator 类的 threshold 参数已正确传递
