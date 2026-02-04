# 移除删除 Snackbar 并让历史记录图标始终可见

## 问题描述

当前基金删除操作后会显示 Snackbar，但 Snackbar 不会自动消失，且用户需要快速点击才能进行撤销操作，体验不佳。

## 修改目标

1. 移除所有删除操作的 Snackbar
2. 让历史记录图标在基金列表页面始终可见
3. 用户通过统一的历史记录入口执行撤销操作
4. 无历史记录时显示空状态提示

## 修改内容

### 1. 移除 home_screen.dart 中的 Snackbar

**文件**: `lib/screens/home_screen.dart`
**位置**: 行 543-559

**修改**: 删除整个 Snackbar 显示逻辑

```dart
// 修改前
onDeleteFund: (fund) async {
  await provider.deleteFund(fund.id);
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text('已删除 ${fund.name}'),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
},

// 修改后
onDeleteFund: (fund) async {
  await provider.deleteFund(fund.id);
},
```

### 2. 移除 fund_list_screen.dart 中的 Snackbar

**文件**: `lib/screens/fund_list_screen.dart`

**修改点2.1**: 删除 `_showUndoSnackBar` 方法
**位置**: 行 156-182

```dart
// 删除整个方法
void _showUndoSnackBar(
    BuildContext context, PortfolioProvider provider, int count) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 10),
          Text('已删除 $count 只基金'),
        ],
      ),
      action: SnackBarAction(
        label: '撤销',
        textColor: AppTheme.accentGold,
        onPressed: () async {
          await provider.undoLastDeletion();
        },
      ),
      backgroundColor: AppTheme.success,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
```

**修改点2.2**: 删除 `_showUndoSnackBar` 调用
**位置**: 行 131-133

```dart
// 修改前
if (_selectedFundIds.isNotEmpty) {
  await provider.deleteFunds(_selectedFundIds.toList());
  _selectedFundIds.clear();
  _isEditMode = false;
  _showUndoSnackBar(context, provider, deletedCount);
}

// 修改后
if (_selectedFundIds.isNotEmpty) {
  await provider.deleteFunds(_selectedFundIds.toList());
  _selectedFundIds.clear();
  _isEditMode = false;
}
```

### 3. 让历史记录图标始终显示

**文件**: `lib/screens/fund_list_screen.dart`
**位置**: 行 332-346

```dart
// 修改前
if (!_isEditMode && context.watch<PortfolioProvider>().canUndo)
  Padding(
    padding: const EdgeInsets.only(right: 8),
    child: IconButton(
      icon: Container(
        padding: const EdgeInsets.all(6),
        child: const Icon(Icons.restore, color: AppTheme.accentGold),
      ),
      onPressed: () => _showUndoHistoryDialog(
        context,
        Provider.of<PortfolioProvider>(context, listen: false),
      ),
      tooltip: '撤销删除',
    ),
  ),

// 修改后
!_isEditMode
  Padding(
    padding: const EdgeInsets.only(right: 8),
    child: IconButton(
      icon: Container(
        padding: const EdgeInsets.all(6),
        child: const Icon(Icons.history, color: AppTheme.accentGold),
      ),
      onPressed: () => _showUndoHistoryDialog(
        context,
        Provider.of<PortfolioProvider>(context, listen: false),
      ),
      tooltip: '删除历史记录',
    ),
  ),
```

### 4. 处理历史记录对话框空状态

**文件**: `lib/screens/fund_list_screen.dart`
**位置**: `_showUndoHistoryDialog` 方法开头（行 184）

```dart
// 在方法开头添加空状态检查
void _showUndoHistoryDialog(BuildContext context, PortfolioProvider provider) {
  // 空状态检查
  if (provider.deletionHistory.isEmpty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除历史记录'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('暂无删除记录', style: TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    return;
  }

  // 原有代码继续...
}
```

## 文件清单

| 文件 | 修改内容 |
|-----|---------|
| `lib/screens/home_screen.dart` | 移除行 543-559 的 Snackbar |
| `lib/screens/fund_list_screen.dart` | 移除行 156-182（_showUndoSnackBar 方法）；移除行 131-133（方法调用）；修改行 332-346（图标始终显示）；修改行 184（添加空状态检查） |

## 验收标准

1. ✅ 删除基金后不再弹出 Snackbar
2. ✅ 基金列表页面 AppBar 上的历史记录图标始终可见
3. ✅ 点击历史记录图标时：
   - 有记录 → 显示可撤销的历史列表
   - 无记录 → 显示空状态提示（暂无删除记录）
