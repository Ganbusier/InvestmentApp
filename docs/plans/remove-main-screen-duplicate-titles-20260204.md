# 移除 MainScreen 重复标题，让每个页面独立控制标题

## 问题描述

1. MainScreen 在屏幕左上角显示每个页面的图标和标题
2. 每个子页面（FundListScreen、StatisticsScreen、RebalanceScreen）自带 AppBar，显示相同或类似的标题
3. 造成标题重复显示

## 目标

1. 移除 MainScreen 中的 AppBar
2. 为每个子页面添加独立 AppBar，使用与 MainScreen 相同样式（图标+标题文字）
3. 保持底部导航栏不变

## MainScreen 当前标题样式（需应用到各页面）

```dart
appBar: AppBar(
  elevation: 0,
  title: Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.accentGold, AppTheme.accentGold.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(图标, color: AppTheme.primaryDark, size: 20),
      ),
      const SizedBox(width: 12),
      Text(
        '标题文字',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
    ],
  ),
  actions: [...],
),
```

## 各页面 AppBar 配置

| 页面 | 图标 | 标题 | 特殊处理 |
|------|------|------|----------|
| HomeScreen | `Icons.trending_up` | 财富管理 | 新增 AppBar |
| FundListScreen | `Icons.account_balance_wallet` | 我的基金 / 选择基金 | 修改现有 AppBar |
| StatisticsScreen | `Icons.insights` | 投资统计 | 修改现有 AppBar |
| RebalanceScreen | `Icons.swap_horiz` | 再平衡 | 修改现有 AppBar |

## 实现步骤

### 步骤 1: 修改 main_screen.dart

移除 `_buildBody()` 中的 `appBar` 参数，保留 `IndexedStack` 和 `bottomNavigationBar`。

修改内容：
- 删除 `appBar: AppBar(...)` 部分
- `_buildBody()` 直接返回 Scaffold.body

### 步骤 2: 修改 home_screen.dart

添加 AppBar 到 Scaffold，使用与 MainScreen 一致的样式。

```dart
appBar: AppBar(
  elevation: 0,
  title: Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.accentGold, AppTheme.accentGold.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.trending_up, color: AppTheme.primaryDark, size: 20),
      ),
      const SizedBox(width: 12),
      const Text(
        '财富管理',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
    ],
  ),
  actions: [],
),
```

### 步骤 3: 修改 fund_list_screen.dart

修改现有 AppBar.title，使用 Row + Container(图标) + Text 结构。

```dart
appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  title: Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.accentGold, AppTheme.accentGold.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.account_balance_wallet, color: AppTheme.primaryDark, size: 20),
      ),
      const SizedBox(width: 12),
      Text(
        _isEditMode ? '选择基金' : '我的基金',
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
    ],
  ),
  actions: [...],
),
```

### 步骤 4: 修改 statistics_screen.dart

修改现有 AppBar.title，使用相同样式。

```dart
appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  title: Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.accentGold, AppTheme.accentGold.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.insights, color: AppTheme.primaryDark, size: 20),
      ),
      const SizedBox(width: 12),
      const Text(
        '投资统计',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
    ],
  ),
),
```

### 步骤 5: 修改 rebalance_screen.dart

修改现有 AppBar.title，使用相同样式。

```dart
appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  title: Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.accentGold, AppTheme.accentGold.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.swap_horiz, color: AppTheme.primaryDark, size: 20),
      ),
      const SizedBox(width: 12),
      const Text(
        '再平衡',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
    ],
  ),
),
```

## 验证步骤

1. 运行 `flutter analyze` 检查是否有错误
2. 检查每个页面的标题显示是否正确
3. 确认底部导航栏功能正常
4. 验证页面切换时标题正确更新

## 修改文件清单

| 文件 | 操作 | 说明 |
|------|------|------|
| `lib/screens/main_screen.dart` | 修改 | 移除 AppBar |
| `lib/screens/home_screen.dart` | 修改 | 添加 AppBar |
| `lib/screens/fund_list_screen.dart` | 修改 | 更新 AppBar 样式 |
| `lib/screens/statistics_screen.dart` | 修改 | 更新 AppBar 样式 |
| `lib/screens/rebalance_screen.dart` | 修改 | 更新 AppBar 样式 |

## 预期效果

- 移除 MainScreen 的标题显示
- 每个子页面独立控制自己的标题
- 保持与原 MainScreen 相同的视觉风格
- 底部导航栏始终可见
