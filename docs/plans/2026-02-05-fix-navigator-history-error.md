# CannotRebalanceCard Navigator 历史错误修复方案

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task.

**目标：** 修复 CannotRebalanceCard 中点击"去添加基金"按钮时导致的 Navigator 历史错误（`_history.isNotEmpty` 断言失败）。

**架构：** 调整点击处理顺序：先关闭 BottomSheet 弹窗，再切换 Tab，避免 Navigator 状态冲突。

**技术栈：** Flutter, Dart

---

## 问题分析

### 错误信息
```
'package:flutter/src/widgets/navigator.dart': Failed assertion: line 5850 pos 12:
'_history.isNotEmpty': is not true.
```

### 问题根源
`lib/widgets/cannot_rebalance_card.dart:90-93`

```dart
onTap: () {
  provider.triggerShowAddFundDialog();
  provider.selectTab(0);  // ❌ 问题：同时触发状态变更
},
```

### 原因分析
1. 点击"去添加基金"按钮时，同时触发 `triggerShowAddFundDialog()` 和 `selectTab(0)`
2. 导致 `notifyListeners()` 被多次调用
3. `MainScreen` 在 `addPostFrameCallback` 中切换 Tab
4. 此时 BottomSheet（弹窗）还没关闭，导致 Navigator 历史被清空
5. 抛出 `_history.isNotEmpty` 错误

---

## 修复方案

### 修改文件
- 修改：`lib/widgets/cannot_rebalance_card.dart:90-93`

### 修改内容

**修改前：**
```dart
onTap: () {
  provider.triggerShowAddFundDialog();
  provider.selectTab(0);
},
```

**修改后：**
```dart
onTap: () {
  provider.triggerShowAddFundDialog();
  Navigator.of(context).pop();  // 先关闭弹窗
  provider.selectTab(0);        // 再切换 Tab
},
```

---

## 任务分解

### 任务 1：修复 CannotRebalanceCard Navigator 错误

**文件：**
- 修改：`lib/widgets/cannot_rebalance_card.dart:90-93`

**步骤 1：备份原始文件**

运行：`cp lib/widgets/cannot_rebalance_card.dart lib/widgets/cannot_rebalance_card.dart.backup`

**步骤 2：应用修复**

将第90-93行修改为：
```dart
onTap: () {
  provider.triggerShowAddFundDialog();
  Navigator.of(context).pop();  // 先关闭弹窗
  provider.selectTab(0);        // 再切换 Tab
},
```

**步骤 3：运行 flutter analyze 检查**

运行：`flutter analyze lib/widgets/cannot_rebalance_card.dart`
预期：无错误，无警告

**步骤 4：格式化代码**

运行：`dart format lib/widgets/cannot_rebalance_card.dart`

**步骤 5：提交变更**

```bash
git add lib/widgets/cannot_rebalance_card.dart
git commit -m "fix: 修复 CannotRebalanceCard Navigator 历史错误

- 先关闭 BottomSheet 弹窗再切换 Tab
- 避免 Navigator 状态冲突"
```

---

### 任务 2：验证修复

**步骤 1：运行 flutter analyze 全局检查**

运行：`flutter analyze`
预期：0 errors

**步骤 2：构建 APK**

运行：`flutter build apk --debug`
预期：构建成功

**步骤 3：更新项目状态**

修改 `PROJECT_STATUS.md`，添加：
```markdown
- [2026-02-05] 修复 CannotRebalanceCard Navigator 历史错误
```

**步骤 4：提交项目状态更新**

```bash
git add PROJECT_STATUS.md
git commit -m "docs: 更新项目状态，添加 Navigator 历史错误修复记录"
```

---

## 验收标准

- [ ] `flutter analyze` 无错误和警告
- [ ] `dart format` 格式正确
- [ ] APK 构建成功
- [ ] 点击"去添加基金"按钮不再崩溃
- [ ] 弹窗正确关闭后再切换 Tab
- [ ] 代码变更已提交

---

## 依赖

- Flutter SDK
- Android 模拟器（Medium_Phone）

---

## 回滚方案

如果修复引入新问题：

```bash
git checkout HEAD~1 lib/widgets/cannot_rebalance_card.dart
flutter run
```

或者使用备份文件：
```bash
cp lib/widgets/cannot_rebalance_card.dart.backup lib/widgets/cannot_rebalance_card.dart
flutter run
```
