# 基金删除确认对话框重复 Bug 修复方案

## 1. 问题描述

### Bug 现象
1. **确认对话框出现两次**：滑动删除时会弹出两个确认删除对话框
2. **选择不一致导致错误**：第一次确认后基金已删除，若第二次选择取消，会导致：
   - 删除历史未记录
   - 后续删除操作报错（基金已不存在）

## 2. 根因分析

### 调用链路
```
用户滑动删除
    ↓
Dismissible.confirmDismiss (fund_card.dart:48)
    ↓
第一次 showDialog (fund_card.dart:49-138)
    ↓ 用户确认
Dismissible.onDismissed (fund_card.dart:140-142)
    ↓
onDelete?.call()
    ↓
_fund_list_screen.dart._confirmDelete (fund_list_screen.dart)
    ↓
第二次 showDialog (fund_list_screen.dart)
```

### 问题代码位置

| 文件 | 行号 | 问题 |
|------|------|------|
| `lib/widgets/fund_card.dart` | 48-142 | confirmDismiss 和底部删除按钮都有独立确认 |
| `lib/screens/fund_list_screen.dart` | _confirmDelete | 与 fund_card 的 confirmDismiss 重复 |

## 3. 解决方案

### 方案 A：移除 FundCard 的确认对话框（推荐）

**核心思路**：统一使用 `fund_list_screen.dart` 中的 `_confirmDelete` 作为唯一确认入口

#### 修改内容

**Step 1: 修改 `fund_card.dart`**

```dart
// 移除 confirmDismiss 回调中的确认对话框
confirmDismiss: (direction) async {
  // 直接返回 true，允许删除执行
  // 由 fund_list_screen.dart 的 _confirmDelete 负责确认
  return true;
},

// onDismissed 保持不变
onDismissed: (direction) {
  onDelete?.call();
},
```

**Step 2: 确保 `_confirmDelete` 与 `onDismissed` 正确协作**

在 `fund_list_screen.dart` 中，`_confirmDelete` 已经在删除前调用：
- 用户确认 → 执行 `provider.deleteFund(fund.id)` → 显示 SnackBar

但由于 `Dismissible` 的 `confirmDismiss` 返回 `true` 后会立即触发 `onDismissed`，需要避免重复调用。

**Step 3: 添加防重复机制**

在 `PortfolioProvider` 中使用 `deletingFundIds` Set：

```dart
class PortfolioProvider with ChangeNotifier {
  final Set<String> _deletingFundIds = {};

  Future<void> deleteFund(String fundId) async {
    if (_deletingFundIds.contains(fundId)) return; // 防止重复删除
    _deletingFundIds.add(fundId);

    try {
      final fund = HiveService.getFund(fundId);
      if (fund != null) {
        // ... 保存历史记录
      }
      await HiveService.deleteFund(fundId);
      await loadPortfolio();
    } finally {
      _deletingFundIds.remove(fundId);
    }
  }
}
```

### 方案 B：移除底部删除按钮，统一使用 Dismissible

**核心思路**：移除底部删除按钮的确认对话框，只使用 Dismissible 的确认

#### 修改内容

修改 `fund_card.dart`，让底部删除按钮也通过确认流程：

```dart
InkWell(
  onTap: () {
    // 直接触发滑动删除的 confirmDismiss 流程
    // 通过 GlobalKey 获取 Dismissible 状态并调用 showConfirmDialog
  },
  // ...
)
```

**缺点**：实现复杂，需要获取 Dismissible 状态

## 4. 推荐方案：方案 A

### 实施步骤

#### Step 1: 修改 `fund_card.dart`

**修改位置**：`fund_card.dart:48-142`

```dart
// 修改前
confirmDismiss: (direction) async {
  return await showDialog<bool>(
    context: context,
    // ... 完整确认对话框
  );
},

// 修改后
confirmDismiss: (direction) async {
  // 不再在这里显示确认对话框
  // 由 fund_list_screen.dart 的 _confirmDelete 负责
  return true;
},
```

#### Step 2: 修改 `PortfolioProvider`

**新增状态**：防止重复删除

```dart
class PortfolioProvider with ChangeNotifier {
  final Set<String> _deletingFundIds = {};

  Future<void> deleteFund(String fundId) async {
    if (_deletingFundIds.contains(fundId)) return;
    _deletingFundIds.add(fundId);

    try {
      // 原有删除逻辑
      final fund = HiveService.getFund(fundId);
      if (fund != null) {
        final history = FundDeletionHistory.fromDeletedFund(fund, _deletionHistory.length);
        await HiveService.saveDeletionHistory(history);
        await HiveService.clearOldestHistory(10);
      }
      await HiveService.deleteFund(fundId);
      await loadPortfolio();
    } finally {
      _deletingFundIds.remove(fundId);
    }
  }
}
```

#### Step 3: 可选优化 - 移除底部删除按钮

如果希望简化 UI，可以移除 `fund_card.dart` 底部的删除按钮（行 244-281），统一使用滑动删除。

## 5. 风险评估

| 风险 | 级别 | 缓解措施 |
|------|------|----------|
| 用户习惯改变 | 低 | 确认对话框仍在，只是入口统一 |
| 代码回归 | 低 | 修改范围小，仅涉及删除流程 |
| 性能影响 | 无 | 添加的 Set 操作 O(1) |

## 6. 测试用例

1. **正常流程测试**
   - [ ] 滑动删除 → 确认 → 基金删除 → 历史记录正确
   - [ ] 点击底部删除按钮 → 确认 → 基金删除 → 历史记录正确

2. **取消流程测试**
   - [ ] 滑动删除 → 确认 → 底部按钮取消 → 基金不删除
   - [ ] 点击底部删除按钮 → 取消 → 基金不删除

3. **边界情况测试**
   - [ ] 快速连续删除多个基金
   - [ ] 删除过程中切换页面
   - [ ] 应用重启后恢复

## 7. 文件变更清单

| 文件 | 变更类型 | 说明 |
|------|----------|------|
| `lib/widgets/fund_card.dart` | 修改 | 简化 confirmDismiss 回调 |
| `lib/providers/portfolio_provider.dart` | 修改 | 添加防重复删除机制 |
| `lib/screens/fund_list_screen.dart` | 无变更 | 保持现有逻辑 |
