# WarningBanner 交互优化实现方案

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task.

**目标：** 移除 WarningBanner 右侧"查看详情"按钮，使整个 banner 区域可点击，点击后打开再平衡页面。

**架构：** 通过用 InkWell 包裹整个 Container 替代原有的 Row + 右侧按钮结构，实现点击整行打开再平衡弹窗。

**技术栈：** Flutter, Dart

---

## 问题分析

### 当前实现
- `WarningBanner` 右侧有"查看详情"按钮（第53-77行）
- 点击按钮调用 `_showRebalanceSheet(context)` 打开再平衡弹窗
- 用户反馈按钮多余，希望直接点击整行

### 修改范围
1. `lib/widgets/warning_banner.dart` - 重构组件交互
2. `lib/screens/home_screen.dart:305-308` - 更新调用方式

---

## 修改内容

### 文件1: `lib/widgets/warning_banner.dart`

```dart
import 'package:flutter/material.dart';
import 'package:investment_app/theme/app_theme.dart';

class WarningBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;

  const WarningBanner({
    super.key,
    required this.message,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: AppTheme.warning.withValues(alpha: 0.1),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.warning.withValues(alpha: 0.15),
                AppTheme.warning.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(
              color: AppTheme.warning.withValues(alpha: 0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.warning_amber_rounded, color: AppTheme.warning, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppTheme.warning,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**变更点：**
1. 将 `onAction` 改为 `onTap`
2. 用 `Material` + `InkWell` 包裹整个 Container
3. 移除 Row 中的右侧按钮部分
4. 添加 `splashColor` 点击反馈

### 文件2: `lib/screens/home_screen.dart:305-308`

```dart
// 修改前
WarningBanner(
  message: '部分投资类别偏离目标配置，请关注',
  onAction: () => _showRebalanceSheet(context),
),

// 修改后
WarningBanner(
  message: '部分投资类别偏离目标配置，请关注',
  onTap: () => _showRebalanceSheet(context),
),
```

---

## 任务分解

### 任务 1：修改 WarningBanner 组件

**文件：**
- 修改：`lib/widgets/warning_banner.dart`

**步骤 1：备份原始文件**

运行：`cp lib/widgets/warning_banner.dart lib/widgets/warning_banner.dart.backup`

**步骤 2：应用重构代码**

将整个 `build` 方法替换为重构后的代码。

**步骤 3：运行 flutter analyze 检查**

运行：`flutter analyze lib/widgets/warning_banner.dart`
预期：无错误，无警告

**步骤 4：格式化代码**

运行：`dart format lib/widgets/warning_banner.dart`

**步骤 5：提交变更**

```bash
git add lib/widgets/warning_banner.dart
git commit -m "refactor: 优化 WarningBanner 交互，移除查看详情按钮

- 使用 InkWell 包裹整个 banner 实现整行可点击
- 将 onAction 改为 onTap
- 添加点击水波纹反馈效果"
```

---

### 任务 2：更新调用处参数名

**文件：**
- 修改：`lib/screens/home_screen.dart:305-308`

**步骤 1：修改参数名**

将 `onAction` 改为 `onTap`。

**步骤 2：运行 flutter analyze 检查**

运行：`flutter analyze lib/screens/home_screen.dart`
预期：无错误，无警告

**步骤 3：格式化代码**

运行：`dart format lib/screens/home_screen.dart`

**步骤 4：提交变更**

```bash
git add lib/screens/home_screen.dart
git commit -m "refactor: 更新 WarningBanner 调用，将 onAction 改为 onTap"
```

---

### 任务 3：验证修复

**步骤 1：启动 Flutter 应用**

运行：`flutter run`

**步骤 2：验证交互**
- 触发警告条件（类别偏离阈值）
- 点击 WarningBanner 任意位置
- 确认弹窗正常打开
- 确认无控制台错误

**步骤 4：更新项目状态**

修改 `PROJECT_STATUS.md`，添加：
```markdown
- [2026-02-05] WarningBanner 交互优化，移除查看详情按钮
```

**步骤 5：提交项目状态更新**

```bash
git add PROJECT_STATUS.md
git commit -m "docs: 更新项目状态，添加 WarningBanner 优化记录"
```

---

## 验收标准

- [ ] `flutter analyze` 无错误和警告
- [ ] `dart format` 格式正确
- [ ] WarningBanner 整行可点击
- [ ] 点击后正确打开再平衡弹窗
- [ ] 有视觉反馈（水波纹效果）
- [ ] 代码变更已提交

---

## 依赖

- Flutter SDK
- Android 模拟器（Medium_Phone）

---

## 回滚方案

如果修复引入新问题：

```bash
git checkout HEAD~1 lib/widgets/warning_banner.dart lib/screens/home_screen.dart
flutter run
```

或者使用备份文件：
```bash
cp lib/widgets/warning_banner.dart.backup lib/widgets/warning_banner.dart
flutter run
```
