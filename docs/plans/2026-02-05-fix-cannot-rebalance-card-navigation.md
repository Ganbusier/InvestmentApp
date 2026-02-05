# CannotRebalanceCard 导航修复方案

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task.

**目标：** 修复 CannotRebalanceCard 在不同使用场景下的导航行为差异问题。首页弹窗中使用 Navigator.pop() 正常工作，但在 rebalance_screen.dart 页面中使用会导致黑屏。

**架构：** 通过添加 `onBack` 和 `onAddFund` 回调参数，让调用方决定返回和添加基金的处理逻辑，避免在 RebalanceScreen 页面中使用 Navigator.pop() 导致黑屏。

**技术栈：** Flutter, Dart

---

## 问题分析

### 错误现象

| 使用场景 | 点击"返回"结果 |
|---------|---------------|
| 首页 WarningBanner 弹窗中的 CannotRebalanceCard | ✅ 正常关闭弹窗 |
| RebalanceScreen 页面中的 CannotRebalanceCard | ❌ 黑屏 |

### 根本原因

```
RebalanceScreen 是 MainScreen 中 IndexedStack 的一个 Tab（第60行）
    ↓
CannotRebalanceCard 中的 Navigator.pop(context) 尝试关闭整个页面
    ↓
IndexedStack 需要保留所有 Tab，关闭后没有内容显示
    ↓
黑屏
```

### 问题代码

`lib/widgets/cannot_rebalance_card.dart:72, 92`
```dart
// 第72行 - 返回按钮
onPressed: () => Navigator.pop(context),

// 第92行 - 添加基金按钮
Navigator.of(context).pop(); // 先关闭弹窗
```

---

## 解决方案

### 修改 CannotRebalanceCard 组件

添加两个回调参数：
- `VoidCallback? onBack` - 返回按钮点击处理
- `VoidCallback? onAddFund` - 添加基金按钮点击处理

### 修改调用方

1. **home_screen.dart** - 传递 `Navigator.pop` 作为回调
2. **rebalance_screen.dart** - 传递空操作或页面特定处理

---

## 修改内容

### 文件1: `lib/widgets/cannot_rebalance_card.dart`

```dart
class CannotRebalanceCard extends StatelessWidget {
  final RebalanceCheckResult checkResult;
  final PortfolioProvider provider;
  final VoidCallback? onBack;      // 新增：返回回调
  final VoidCallback? onAddFund;   // 新增：添加基金回调

  const CannotRebalanceCard({
    super.key,
    required this.checkResult,
    required this.provider,
    this.onBack,
    this.onAddFund,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ... 现有装饰代码 ...
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ... 图标和文本 ...
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack ?? () => Navigator.pop(context), // 修改：使用回调
                  // ... 样式保持不变 ...
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    provider.triggerShowAddFundDialog();
                    onAddFund ?? Navigator.of(context).pop(); // 修改：使用回调
                    provider.selectTab(0);
                  },
                  // ... 样式保持不变 ...
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

### 文件2: `lib/screens/home_screen.dart:846-847`

```dart
// 修改前
CannotRebalanceCard(checkResult: checkResult, provider: provider)

// 修改后
CannotRebalanceCard(
  checkResult: checkResult,
  provider: provider,
  onBack: () => Navigator.of(context).pop(),
  onAddFund: () => Navigator.of(context).pop(),
)
```

### 文件3: `lib/screens/rebalance_screen.dart:813`

```dart
// 修改前
return CannotRebalanceCard(checkResult: checkResult!, provider: provider);

// 修改后
return CannotRebalanceCard(
  checkResult: checkResult!,
  provider: provider,
  onBack: null,  // 使用默认行为（无操作）
  onAddFund: null, // 使用默认行为（无操作）
);
```

---

## 任务分解

### 任务 1：修改 CannotRebalanceCard 组件

**文件：**
- 修改：`lib/widgets/cannot_rebalance_card.dart`

**步骤 1：备份原始文件**

```bash
cp lib/widgets/cannot_rebalance_card.dart lib/widgets/cannot_rebalance_card.dart.v2.backup
```

**步骤 2：应用修改**

1. 添加 `onBack` 和 `onAddFund` 参数
2. 修改返回按钮的 `onPressed`
3. 修改添加基金按钮的 `onTap`

**步骤 3：运行 flutter analyze 检查**

```bash
flutter analyze lib/widgets/cannot_rebalance_card.dart
```
预期：无错误，无警告

**步骤 4：格式化代码**

```bash
dart format lib/widgets/cannot_rebalance_card.dart
```

**步骤 5：提交变更**

```bash
git add lib/widgets/cannot_rebalance_card.dart
git commit -m "refactor: 为 CannotRebalanceCard 添加导航回调参数

- 添加 onBack 和 onAddFund 回调参数
- 让调用方决定导航行为
- 避免在 RebalanceScreen 中使用 Navigator.pop() 导致黑屏"
```

---

### 任务 2：修改首页调用处

**文件：**
- 修改：`lib/screens/home_screen.dart:846-847`

**步骤 1：传递回调参数**

```dart
CannotRebalanceCard(
  checkResult: checkResult,
  provider: provider,
  onBack: () => Navigator.of(context).pop(),
  onAddFund: () => Navigator.of(context).pop(),
)
```

**步骤 2：运行 flutter analyze 检查**

```bash
flutter analyze lib/screens/home_screen.dart
```

**步骤 3：格式化代码**

```bash
dart format lib/screens/home_screen.dart

**步骤 4：提交变更**

```bash
git add lib/screens/home_screen.dart
git commit -m "refactor: 首页 CannotRebalanceCard 传递 Navigator.pop 回调"
```

---

### 任务 3：修改再平衡页面调用处

**文件：**
- 修改：`lib/screens/rebalance_screen.dart:813`

**步骤 1：传递 null 回调（使用默认行为）**

```dart
CannotRebalanceCard(
  checkResult: checkResult!,
  provider: provider,
  onBack: null,
  onAddFund: null,
)
```

**步骤 2：运行 flutter analyze 检查**

```bash
flutter analyze lib/screens/rebalance_screen.dart
```

**步骤 3：格式化代码**

```bash
dart format lib/screens/rebalance_screen.dart
```

**步骤 4：提交变更**

```bash
git add lib/screens/rebalance_screen.dart
git commit -m "refactor: 再平衡页面 CannotRebalanceCard 使用默认回调"
```

---

### 任务 4：验证修复

**步骤 1：运行 flutter analyze 全局检查**

```bash
flutter analyze
```

**步骤 2：构建 APK**

```bash
flutter build apk --debug
```

**步骤 3：更新项目状态**

修改 `PROJECT_STATUS.md`，添加：
```markdown
- [2026-02-05] 修复 CannotRebalanceCard 导航行为差异问题
```

**步骤 4：提交项目状态更新**

```bash
git add PROJECT_STATUS.md
git commit -m "docs: 更新项目状态，添加导航修复记录"
```

---

## 验收标准

- [ ] `flutter analyze` 无错误和警告
- [ ] `dart format` 格式正确
- [ ] APK 构建成功
- [ ] 首页 CannotRebalanceCard 点击返回正常关闭弹窗
- [ ] RebalanceScreen 中 CannotRebalanceCard 点击返回不黑屏
- [ ] 添加基金按钮在两种场景下都正常工作
- [ ] 代码变更已提交

---

## 依赖

- Flutter SDK
- Android 模拟器（Medium_Phone）

---

## 回滚方案

如果修复引入新问题：

```bash
git checkout HEAD~3
flutter run
```

需要回滚的文件：
- `lib/widgets/cannot_rebalance_card.dart`
- `lib/screens/home_screen.dart`
- `lib/screens/rebalance_screen.dart`
