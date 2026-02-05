# CategoryCard RenderFlex 溢出修复方案

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**目标：** 修复 `category_card.dart` 中 Row 组件的 RenderFlex 溢出错误，确保类别名称和基金数量徽章在有限空间内正确显示。

**架构：** 通过在类别名称 Text 组件外层添加 `Flexible` 包装，配合 `maxLines: 1` 和 `overflow: TextOverflow.ellipsis` 实现文本自动收缩和溢出处理。

**技术栈：** Flutter, Dart

---

## 问题分析

### 错误信息
- 错误位置：`lib/widgets/category_card.dart:214:31`
- 错误类型：RenderFlex overflowed by 20-38 pixels on the right
- 影响范围：类别名称 Row 组件内多个溢出警告

### 根本原因
1. 类别名称 `widget.category.displayName` 可能较长
2. Row 内包含固定宽度的基金数量徽章 Container
3. 外层 Expanded 约束导致总宽度受限
4. 文本缺少溢出处理机制

---

## 解决方案

### 修改文件
- `lib/widgets/category_card.dart:214-240`

### 修改内容
```dart
Row(
  children: [
    Flexible(  // 新增：允许文本收缩
      child: Text(
        widget.category.displayName,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        maxLines: 1,           // 新增：限制1行
        overflow: TextOverflow.ellipsis, // 新增：溢出显示...
      ),
    ),
    const SizedBox(width: 8),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${widget.funds.length} 只',
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis, // 新增：溢出处理
        maxLines: 1,
      ),
    ),
  ],
)
```

---

## 任务分解

### 任务 1：修改类别名称 Row 组件

**文件：**
- 修改：`lib/widgets/category_card.dart:214-240`

**步骤 1：备份原始文件**

运行：`cp lib/widgets/category_card.dart lib/widgets/category_card.dart.backup`

**步骤 2：应用修复**

```dart
Row(
  children: [
    Flexible(
      child: Text(
        widget.category.displayName,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    const SizedBox(width: 8),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${widget.funds.length} 只',
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    ),
  ],
)
```

**步骤 3：运行 flutter analyze 检查**

运行：`flutter analyze lib/widgets/category_card.dart`
预期：无错误，无警告

**步骤 4：格式化代码**

运行：`dart format lib/widgets/category_card.dart`

**步骤 5：提交变更**

```bash
git add lib/widgets/category_card.dart
git commit -m "fix: 修复 CategoryCard RenderFlex 溢出问题

- 为类别名称添加 Flexible 包装
- 为文本添加 maxLines: 1 和 overflow: TextOverflow.ellipsis
- 确保长类别名称正确截断显示"
```

---

### 任务 2：验证修复

**步骤 1：启动 Flutter 应用**

运行：`flutter run`

**步骤 2：验证无溢出警告**

- 在模拟器中检查 CategoryCard 组件
- 确认控制台无 "RenderFlex overflowed" 错误
- 确认文本显示正常，溢出时显示省略号

**步骤 3：更新项目状态**

修改 `PROJECT_STATUS.md`，添加：
```markdown
### 已修复 Bug
- [2026-02-05] CategoryCard RenderFlex 溢出问题
```

---

## 验收标准

- [ ] `flutter analyze` 无错误和警告
- [ ] `dart format` 格式正确
- [ ] 应用运行无 RenderFlex overflowed 错误
- [ ] 长类别名称显示时正确截断（显示省略号）
- [ ] 基金数量徽章正常显示
- [ ] 代码变更已提交

---

## 依赖

- Flutter SDK
- Android 模拟器（Medium_Phone）

---

## 回滚方案

如果修复引入新问题：

```bash
git checkout HEAD~1 lib/widgets/category_card.dart
flutter run
```

或者使用备份文件：
```bash
cp lib/widgets/category_card.dart.backup lib/widgets/category_card.dart
flutter run
```
