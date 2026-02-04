# 修复 Hive FundSnapshot 适配器未注册问题

## 问题描述

执行再平衡操作时，Dart 抛出错误：
```
DartError: HiveError: Cannot write, unknown type: FundSnapshot. Did you forget to register an adapter?
```

## 根因分析

### 文件导入问题

`hive_service.dart:5` 使用 `hide` 关键字隐藏了 `FundSnapshot` 和 `FundSnapshotAdapter`：

```dart
import 'package:investment_app/models/rebalance_snapshot.dart' hide FundSnapshot, FundSnapshotAdapter;
```

### 适配器注册缺失

`init()` 方法中只注册了 `RebalanceSnapshotAdapter`，未注册 `FundSnapshotAdapter`：

```dart
Hive.registerAdapter(RebalanceSnapshotAdapter());
// 缺少：Hive.registerAdapter(FundSnapshotAdapter());
```

### 嵌套对象序列化失败

`RebalanceSnapshot.funds` 字段类型为 `List<FundSnapshot>`，写入 Hive 时需要序列化嵌套的 `FundSnapshot` 对象。由于适配器未注册，导致写入失败。

### Hive 类型分配表

| TypeId | 类名 | 适配器 | 注册状态 |
|--------|------|--------|----------|
| 0 | Fund | FundAdapter | 已注册 |
| 1 | Portfolio | PortfolioAdapter | 已注册 |
| 2 | PortfolioCategory | PortfolioCategoryAdapter | 已注册 |
| 3 | RebalanceSnapshot | RebalanceSnapshotAdapter | 已注册 |
| 4 | FundSnapshot | FundSnapshotAdapter | **未注册** ✗ |

## 修复方案

### 修改文件

`lib/services/hive_service.dart`

### 修改内容

#### 1. 移除 hide 关键字

**修改前：**
```dart
import 'package:investment_app/models/rebalance_snapshot.dart' hide FundSnapshot, FundSnapshotAdapter;
```

**修改后：**
```dart
import 'package:investment_app/models/rebalance_snapshot.dart';
```

#### 2. 注册 FundSnapshotAdapter

**修改前：**
```dart
Hive.registerAdapter(RebalanceSnapshotAdapter());
Hive.registerAdapter(FundDeletionHistoryAdapter());
```

**修改后：**
```dart
Hive.registerAdapter(RebalanceSnapshotAdapter());
Hive.registerAdapter(FundSnapshotAdapter());
Hive.registerAdapter(FundDeletionHistoryAdapter());
```

## 验证步骤

1. 运行 `flutter analyze lib/services/hive_service.dart`，确认无错误
2. 执行再平衡操作，验证错误已修复
3. 确认应用正常运行

## 预计工作量

- 修改行数：2行
- 测试时间：5分钟
- 风险等级：低
