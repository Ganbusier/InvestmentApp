# 基金删除撤销功能方案

## 1. 需求概述

为基金删除功能增加撤销能力：
- 保留最多 10 条删除历史记录
- 支持多次撤销
- 用户友好性：提供清晰的撤销提示和操作入口

## 2. 技术方案

### 2.1 数据模型设计

创建 `FundDeletionHistory` 模型，参考现有的 `RebalanceSnapshot`：

```dart
// lib/models/fund_deletion_history.dart
@HiveType(typeId: 5)
class FundDeletionHistory {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime timestamp;
  @HiveField(2)
  final List<FundSnapshot> deletedFunds;
  @HiveField(3)
  final int order; // 用于 FIFO 队列管理

  FundDeletionHistory({
    required this.id,
    required this.timestamp,
    required this.deletedFunds,
    required this.order,
  });
}
```

### 2.2 Hive Service 扩展

在 `HiveService` 中添加：

```dart
// 新增 Box 名称
static const String _deletionHistoryBoxName = 'deletion_history';

// 新增方法
static Future<void> saveDeletionHistory(FundDeletionHistory history);
static List<FundDeletionHistory> getDeletionHistory({int limit = 10});
static Future<void> clearOldestHistory(int maxItems);
static Future<void> clearAllDeletionHistory();
```

### 2.3 Provider 层逻辑

修改 `PortfolioProvider`：

```dart
class PortfolioProvider {
  // 新增状态
  List<FundDeletionHistory> _deletionHistory = [];
  
  // 新增 getter
  List<FundDeletionHistory> get deletionHistory => _deletionHistory;
  bool get canUndo => _deletionHistory.isNotEmpty();
  
  // 修改删除方法
  Future<void> deleteFund(String fundId) async {
    final fund = HiveService.getFund(fundId);
    if (fund != null) {
      final history = FundDeletionHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        deletedFunds: [FundSnapshot.fromFund(fund)],
        order: _deletionHistory.length,
      );
      
      await HiveService.saveDeletionHistory(history);
      await HiveService.clearOldestHistory(10); // 保留最多 10 条
      await loadDeletionHistory();
    }
    
    await HiveService.deleteFund(fundId);
    await loadPortfolio();
  }

  // 批量删除方法
  Future<void> deleteFunds(List<String> fundIds) async {
    final deletedFunds = fundIds.map((id) => HiveService.getFund(id)).where((f) => f != null).toList();
    
    final history = FundDeletionHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      deletedFunds: deletedFunds.map((f) => FundSnapshot.fromFund(f!)).toList(),
      order: _deletionHistory.length,
    );
    
    await HiveService.saveDeletionHistory(history);
    await HiveService.clearOldestHistory(10);
    
    for (final id in fundIds) {
      await HiveService.deleteFund(id);
    }
    await loadPortfolio();
    await loadDeletionHistory();
  }

  // 撤销方法
  Future<bool> undoLastDeletion() async {
    if (_deletionHistory.isEmpty) return false;
    
    final lastHistory = _deletionHistory.last;
    for (final fundSnapshot in lastHistory.deletedFunds) {
      await HiveService.addFund(fundSnapshot.toFund());
    }
    
    await HiveService.removeDeletionHistory(lastHistory.id);
    await loadPortfolio();
    await loadDeletionHistory();
    return true;
  }

  Future<void> loadDeletionHistory() async {
    _deletionHistory = HiveService.getDeletionHistory(limit: 10);
    notifyListeners();
  }
}
```

### 2.4 UI 层面实现

#### 2.4.1 添加撤销 SnackBar

在删除操作后显示：

```dart
// 在 fund_list_screen.dart 或相关页面
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('已删除 ${fund.name}'),
    action: SnackBarAction(
      label: '撤销',
      onPressed: () {
        context.read<PortfolioProvider>().undoLastDeletion();
      },
    ),
    duration: const Duration(seconds: 5),
  ),
);
```

#### 2.4.2 持久化撤销入口

在基金列表页面添加：

```dart
// 在 AppBar 或底部栏添加撤销按钮
if (provider.canUndo) {
  IconButton(
    icon: Icon(Icons.restore),
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('撤销删除'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('可撤销最近 ${provider.deletionHistory.length} 次删除操作'),
              SizedBox(height: 16),
              ...provider.deletionHistory.map((history) {
                return ListTile(
                  title: Text('${history.deletedFunds.length} 个基金'),
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(history.timestamp)
                  ),
                  trailing: TextButton(
                    child: Text('撤销'),
                    onPressed: () {
                      provider.undoLastDeletion();
                      Navigator.pop(context);
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      );
    },
  );
}
```

## 3. 实现步骤

### Step 1: 创建数据模型
- [ ] 创建 `lib/models/fund_deletion_history.dart`
- [ ] 创建 `lib/models/fund_snapshot_ext.dart`（扩展 FundSnapshot）

### Step 2: 注册 Hive Adapter
- [ ] 在 `hive_service.dart` 中注册 `FundDeletionHistoryAdapter`

### Step 3: 实现 Service 层
- [ ] 扩展 `HiveService` 添加删除历史管理方法
- [ ] 实现 FIFO 队列逻辑（超过 10 条时删除最旧的）

### Step 4: 实现 Provider 层
- [ ] 修改 `PortfolioProvider` 添加删除和撤销逻辑
- [ ] 添加 `_deletionHistory` 状态
- [ ] 实现 `deleteFund`、`deleteFunds`、`undoLastDeletion` 方法

### Step 5: 实现 UI 层
- [ ] 在删除操作后显示可撤销的 SnackBar
- [ ] 在基金列表页面添加撤销入口
- [ ] 可选：添加"清除所有历史"功能

### Step 6: 测试
- [ ] 测试单条删除和撤销
- [ ] 测试批量删除和撤销
- [ ] 测试超过 10 条历史时的 FIFO 行为
- [ ] 测试应用重启后历史记录的持久化

## 4. 风险与注意事项

1. **数据一致性**：撤销操作需要确保基金 ID 不冲突
2. **用户体验**：提供清晰的撤销提示，避免用户误操作后无法恢复
3. **存储限制**：Hive 的 10 条记录限制，避免存储无限增长
4. **边界情况**：
   - 删除后添加同名基金再撤销
   - 批量删除中的部分基金已被再次添加

## 5. 评估复杂度

- **工作量**：约 2-3 小时
- **风险**：低
- **依赖**：无外部依赖，利用现有 Hive 基础设施
