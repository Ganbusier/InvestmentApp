# 理财App（永久投资组合）项目状态

## 开发方式选择

**执行方式：** Subagent-Driven Development（子代理驱动开发）

**选择时间：** 2026-02-03

## 项目概况

- **技术栈：** Flutter + VS Code + Hive + Provider
- **投资配置：** 永久投资组合标准4类（各25%）
- **数据存储：** 本地优先
- **功能优先级：** A基金录入 → B统计可视化 → C监控提醒 → D再平衡指引

## 任务进度

| 阶段 | 任务 | 状态 |
|------|------|------|
| M1 | 项目初始化与环境搭建 | ✅ 已完成 |
| M2 | 数据模型层实现 | ✅ 已完成 |
| M3 | Hive本地存储服务 | ✅ 已完成 |
| M4 | 业务逻辑服务层 | ✅ 已完成 |
| M5 | 状态管理层 | ✅ 已完成 |
| M6 | 主题与UI组件 | ✅ 已完成 |
| M7 | 功能A：基金录入 | ✅ 已完成 |
| M8 | 功能B：统计可视化 | ✅ 已完成 |
| M9 | 功能C：监控提醒 | ✅ 已完成 |
| M10 | 功能D：再平衡指引 | ✅ 已完成 |
| M11 | 最终测试与完善 | ✅ 已完成 |
| M12 | UI界面美化与交互增强 | ✅ 已完成 |

## 测试结果

**通过测试：** 17个
- 数据模型测试 (Fund, Portfolio, TargetAllocation)
- 计算服务测试 (PortfolioCalculator, RebalanceCalculator)
- Widget渲染测试

**跳过测试：** 4个（需要真实设备环境）
- HiveService测试
- PortfolioProvider测试

## 修复问题（M11）

- 修复 hive_flutter 版本兼容性
- 生成 Hive 类型适配器 (fund.g.dart, portfolio.g.dart)
- 修复 Flutter 3.x 兼容性问题 (WidgetsFlutterBinding, CardTheme, Icons)
- 修复导入缺失问题 (PortfolioCalculator, TargetAllocation)
- 修复测试预期值错误

## UI美化与功能增强（M12）

### 设计改进
- **颜色系统**：使用高对比度资产类别颜色（股票蓝、债券绿、现金青、黄金金）
- **底部导航栏**：深色背景(#1E1E2E)，高对比度选中状态
- **卡片设计**：圆角16px，阴影层次，醒目删除按钮

### 新增功能
1. **类别卡片展开/折叠**
   - 点击类别卡片头部展开，显示该类别下的基金列表
   - 折叠/展开动画过渡
   - 每只基金带删除按钮

2. **醒目删除按钮**
   - 红色背景按钮，清晰可见
   - 删除前弹出确认对话框
   - 删除后显示SnackBar提示

3. **滑动删除**
   - 基金列表左滑显示删除按钮
   - 释放后弹出确认对话框

4. **批量删除功能**
   - 点击右上角"编辑"进入选择模式
   - 点击基金进行多选
   - 全选/取消全选
   - 批量删除确认对话框

5. **操作反馈**
   - 添加基金成功提示
   - 编辑基金成功提示
   - 删除基金成功提示
   - 再平衡执行提示

### 修改文件

| 文件 | 改动 |
|------|------|
| `lib/theme/app_theme.dart` | 新增颜色系统、底部导航栏样式 |
| `lib/screens/home_screen.dart` | 重构为StatefulWidget，改进卡片和摘要布局 |
| `lib/widgets/category_card.dart` | 新增展开/折叠功能、基金列表、删除按钮 |
| `lib/widgets/fund_card.dart` | 新增滑动删除、醒目删除按钮 |
| `lib/screens/fund_list_screen.dart` | 新增编辑模式、多选批量删除 |

## Git提交记录

```
5000f4c feat: 初始化Flutter项目结构和依赖配置
38070cb feat: 实现数据模型层（Fund、Portfolio、TargetAllocation）
ed917c6 feat: 实现Hive本地存储服务
d957c40 feat: 实现业务逻辑服务层（百分比计算、再平衡计算）
1f9a596 feat: 实现状态管理层（PortfolioProvider）
c025312 feat: 定义主题、常量和格式化工具
ffd49cf feat: 实现UI组件和功能屏幕
b483068 docs: 更新项目状态
```

## 下次继续

安装Flutter后，运行以下命令继续：

```bash
flutter pub get
flutter test
flutter analyze
flutter pub run build_runner build
flutter run
```

然后说"继续开发"继续M11测试验证。

---

## UI/UX 重新设计（M13）2026-02-03

### 设计系统规格

**设计风格：** Dark Mode (OLED) 深色金融风格
- **主色调：** `#F59E0B` 琥珀金 - 传达信任与专业
- **背景色：** `#0F172A` 深蓝黑 - 护眼且高级
- **卡片色：** `#1E293B` Slate - 层次分明
- **成功色：** `#26A69A` 青绿 - 正向指标
- **警示色：** `#EF5350` 红色 - 负向指标

**字体：** IBM Plex Sans
- 权重：300/400/500/600/700
- 用途：银行、金融、投资、企业级应用

### 设计亮点

1. **资产总览卡片（Premium Card）**
   - 渐变金色边框 + 微光阴影
   - 大字号金额显示（44sp）
   - 珠光按钮效果

2. **资产类别卡片**
   - 深色渐变背景
   - 颜色编码的进度条
   - 展开/折叠动画

3. **底部导航栏**
   - 圆角顶部
   - 金色选中状态
   - 毛玻璃效果

4. **图表配色**
   - 股票/增长: 青绿色 (#26A69A)
   - 亏损/下跌: 红色 (#EF5350)
   - 图表填充: 40% 透明度

### 修改文件

| 文件 | 改动 |
|------|------|
| `lib/theme/app_theme.dart` | 完整设计系统、金色主题、卡片装饰 |
| `lib/screens/home_screen.dart` | 金融风格首页、金色按钮、深色背景 |
| `lib/screens/statistics_screen.dart` | 动效优化、动画过渡、统计卡片 |
| `lib/screens/fund_list_screen.dart` | 深色主题、批量操作对话框 |
| `lib/screens/rebalance_screen.dart` | 再平衡页面金融风格 |
| `lib/widgets/category_card.dart` | 资产类别卡片深色样式 |
| `lib/widgets/fund_card.dart` | 基金卡片滑动删除、对话框样式 |
| `lib/widgets/pie_chart_widget.dart` | 图表样式优化 |
| `lib/widgets/warning_banner.dart` | 警示横幅金融风格 |
| `lib/widgets/add_fund_form.dart` | 添加基金表单深色主题 |

### 设计工具

**使用技能：** ui-ux-pro-max
- 生成完整设计系统
- 获取金融科技配色方案
- 获得Flutter实现指南
- 图表设计最佳实践

### 验证结果

- flutter analyze: 无错误 ✓
- 设计一致性: 所有组件统一 ✓
- 动效: 流畅的展开/折叠动画 ✓

---

## 导航架构重构（M14）2026-02-03

### 问题背景

1. 首页有底部导航栏，但点击其他标签使用 `Navigator.pushNamed()` 全屏推送
2. 基金页面有返回按钮，统计和再平衡页面没有返回按钮
3. 页面占满全屏，覆盖掉底部导航栏

### 解决方案

使用 `IndexedStack` + 固定底部导航栏架构：

```
main.dart
  ↓
  home: MainScreen()
       │
       ├── Scaffold
       │     ├── AppBar（动态标题）
       │     ├── body: IndexedStack
       │     │       ├── [0] HomeScreen
       │     │       ├── [1] FundListScreen
       │     │       ├── [2] StatisticsScreen
       │     │       └── [3] RebalanceScreen
       │     │
       │     └── bottomNavigationBar（始终可见）
```

### 修改文件

| 文件 | 操作 | 说明 |
|------|------|------|
| `lib/screens/main_screen.dart` | **新建** | 主屏幕，包含底部导航和IndexedStack |
| `lib/main.dart` | **修改** | home改为MainScreen，移除routes |
| `lib/screens/home_screen.dart` | **修改** | 添加 _showAddFundDialog 方法，移除底部导航栏 |
| `lib/screens/fund_list_screen.dart` | **修改** | 简化AppBar，移除返回按钮 |
| `lib/screens/statistics_screen.dart` | **修改** | 简化AppBar |
| `lib/screens/rebalance_screen.dart` | **修改** | 简化AppBar |

### 效果

- ✅ 底部导航栏始终可见
- ✅ 点击标签直接切换页面，无需返回按钮
- ✅ 页面状态自动保持（IndexedStack）
- ✅ flutter analyze: 0 errors

---

## 代码清理与优化（M15）2026-02-03

### 修复内容

| 修复类型 | 数量 | 状态 |
|---------|------|------|
| **withOpacity 已弃用** | 199 | ✅ 已修复 |
| **prefer_const 构造** | 35 | ✅ 已自动修复 |
| **弃用API (background/onBackground)** | 2 | ✅ 已修复 |
| **unused_local_variable** | 2 | ✅ 已修复 |
| **GestureDetector 冲突** | 7处 | ✅ 已替换为InkWell |

### 修复结果对比

| 指标 | 修复前 | 修复后 |
|------|--------|--------|
| 总警告数 | 262 | **3** |
| withOpacity | 199 | 0 |
| prefer_const | 49 | 0 |

### 剩余警告（可忽略）

| 警告类型 | 文件 | 级别 |
|---------|------|------|
| use_build_context_synchronously | fund_list_screen.dart:795 | info |
| use_build_context_synchronously | home_screen.dart:510 | info |

### 修改文件

| 文件 | 修复内容 |
|------|----------|
| `lib/theme/app_theme.dart` | 修复弃用API、添加颜色扩展常量 |
| `lib/screens/home_screen.dart` | 修复withOpacity、GestureDetector→InkWell |
| `lib/screens/fund_list_screen.dart` | 修复withOpacity、GestureDetector→InkWell |
| `lib/screens/statistics_screen.dart` | 修复withOpacity、添加动画 |
| `lib/screens/rebalance_screen.dart` | 修复withOpacity、GestureDetector→InkWell |
| `lib/screens/main_screen.dart` | 修复withOpacity |
| `lib/widgets/category_card.dart` | 修复withOpacity、GestureDetector→InkWell |
| `lib/widgets/fund_card.dart` | 修复withOpacity、GestureDetector→InkWell、移除未使用变量 |
| `lib/widgets/add_fund_form.dart` | 修复withOpacity、GestureDetector→InkWell |
| `lib/widgets/pie_chart_widget.dart` | 修复withOpacity |
| `lib/widgets/warning_banner.dart` | 修复withOpacity、GestureDetector→InkWell |

### 验证结果

```
flutter analyze: ✅ 0 errors
```

---

## 当前项目状态

| 阶段 | 状态 | 说明 |
|------|------|------|
| M1-M12 | ✅ 已完成 | 基础功能和UI |
| M13 | ✅ 已完成 | UI/UX金融风格重新设计 |
| M14 | ✅ 已完成 | 导航架构重构 |
| M15 | ✅ 已完成 | 代码清理与优化 |

### 技术栈

- **框架：** Flutter 3.38.9
- **状态管理：** Provider
- **本地存储：** Hive
- **设计风格：** Dark Mode 金融风格
- **导航架构：** IndexedStack + 固定底部导航

### 运行命令

```bash
flutter pub get
flutter analyze
flutter run
```

---

## 修复编译错误与UI优化（M16）2026-02-03

### 修复内容

| 问题 | 文件 | 状态 |
|------|------|------|
| 未定义变量 (amount, targetAmount, percentage, target, funds) | home_screen.dart | ✅ 已修复 |
| 缺少 TargetAllocation import | home_screen.dart | ✅ 已添加 |
| 编码问题导致解析错误 | home_screen.dart | ✅ 已修复 |
| 移除 Column 包装解决溢出 | pie_chart_widget.dart | ✅ 已修复 |

### 饼图改进

| 修改项 | 修改前 | 修改后 |
|--------|--------|--------|
| 百分比位置 | 饼图内部 | 饼图外部 |
| 百分比精度 | 0位小数 | **2位小数** (如 35.25%) |
| 类别名称 | 底部图例 | 饼图外部显示 |
| 容器结构 | Column + SizedBox | 直接 SizedBox |

### 饼图代码变更

```dart
// 组合标签：类别名 + 2位小数百分比
title: '${category.displayName}\n${percentage.toStringAsFixed(2)}%',

// 标签位置推至饼图外部
titlePositionPercentageOffset: 1.45,

// 移除Column包装，直接返回SizedBox
return SizedBox(
  height: 200,
  child: Stack(...),
);
```

### 移除重复按钮

**问题：** 首页右上角加号按钮与首页卡片内的"添加基金"按钮功能重复

**解决方案：** 移除 main_screen.dart 中的加号按钮及其关联方法

| 移除项 | 文件 |
|--------|------|
| AppBar actions 中的加号按钮 | main_screen.dart:146-162 |
| _showAddFundDialog 方法 | main_screen.dart:43-115 |
| 未使用的 import (portfolio_provider, add_fund_form, provider) | main_screen.dart |

### 修改文件

| 文件 | 改动 |
|------|------|
| `lib/screens/home_screen.dart` | 修复未定义变量、添加import、修复编码问题 |
| `lib/widgets/pie_chart_widget.dart` | 饼图外部标签、2位小数、移除Column包装 |
| `lib/screens/main_screen.dart` | 移除加号按钮、清理未使用代码 |

### 验证结果

```
flutter analyze: ✅ 0 errors
flutter test: 12 passed (模型测试)
```

---

## 当前项目状态

| 阶段 | 状态 | 说明 |
|------|------|------|
| M1-M12 | ✅ 已完成 | 基础功能和UI |
| M13 | ✅ 已完成 | UI/UX金融风格重新设计 |
| M14 | ✅ 已完成 | 导航架构重构 |
| M15 | ✅ 已完成 | 代码清理与优化 |
| M16 | ✅ 已完成 | 修复编译错误、饼图优化、移除重复按钮 |
| M17 | ✅ 已完成 | 实现再平衡功能（预览、执行、撤销） |
| M18 | ✅ 已完成 | 首页再平衡按钮跳转到再平衡页面 |
| M19 | ✅ 已完成 | 清理代码警告（删除未使用变量、添加const修饰） |

---

## 技术状态

| 指标 | 状态 |
|------|------|
| flutter analyze | ✅ 0 errors, 0 warnings |
| flutter test | ✅ 12 passed (模型测试) |
| Git commit | ✅ 915123e (本地) |

---

## 核心功能

| 功能 | 状态 |
|------|------|
| 基金录入 | ✅ 完整支持 |
| 统计可视化 | ✅ 饼图显示（外部标签、2位小数） |
| 监控提醒 | ✅ 偏离预警 |
| 再平衡指引 | ✅ 预览、执行、撤销功能 |
| 撤销功能 | ✅ 单次撤销，无时间限制 |

---

## M21：基金删除撤销功能 2026-02-03

### 功能描述

为基金删除功能增加撤销能力：
- 保留最多 10 条删除历史记录
- 支持多次撤销
- 用户友好性：提供清晰的撤销提示和操作入口

### 数据模型

```dart
// lib/models/fund_deletion_history.dart
@HiveType(typeId: 5)
class FundDeletionHistory {
  @HiveField(0) final String id;
  @HiveField(1) final DateTime timestamp;
  @HiveField(2) final List<DeletedFundSnapshot> deletedFunds;
  @HiveField(3) final int order; // FIFO 队列管理
}

@HiveType(typeId: 6)
class DeletedFundSnapshot {
  @HiveField(0) final String fundId;
  @HiveField(1) final String name;
  @HiveField(2) final String code;
  @HiveField(3) final PortfolioCategory category;
  @HiveField(4) final double amount;
}
```

### 新增文件

| 文件 | 说明 |
|------|------|
| `lib/models/fund_deletion_history.dart` | 删除历史记录数据模型 |
| `lib/models/fund_deletion_history.g.dart` | Hive 自动生成的适配器 |

### 修改的文件

| 文件 | 变更 |
|------|------|
| `lib/services/hive_service.dart` | 注册新适配器，添加删除历史管理方法 |
| `lib/providers/portfolio_provider.dart` | 添加删除/撤销逻辑和历史状态 |
| `lib/screens/fund_list_screen.dart` | 添加撤销按钮、SnackBar 和历史对话框 |

### 功能特性

1. **自动保存删除记录**：删除基金时自动保存到历史
2. **保留 10 条历史**：FIFO 队列，超过自动清理最旧的
3. **多次撤销支持**：可撤销最近任意一次删除操作
4. **双重撤销入口**：
   - 删除后 5 秒内显示可撤销 SnackBar
   - AppBar 撤销图标点击显示历史列表

### Git 提交

```
fc4e840 feat: 添加基金删除撤销功能（M21）
```

---

## M22：修复基金删除确认对话框重复问题 2026-02-03

### 问题描述

1. **确认对话框出现两次**：滑动删除时会弹出两个确认删除对话框
2. **选择不一致导致错误**：第一次确认后基金已删除，若第二次选择取消，会导致删除历史未记录、后续删除操作报错

### 根因分析

```
用户滑动删除
    ↓
Dismissible.confirmDismiss (fund_card.dart)
    ↓ 第一次 showDialog
Dismissible.onDismissed → onDelete?.call()
    ↓
_fund_list_screen.dart._confirmDelete
    ↓ 第二次 showDialog
```

### 解决方案

1. **移除 fund_card.dart 的确认对话框**：统一由 fund_list_screen.dart 的 `_confirmDelete` 处理确认
2. **添加防重复删除机制**：使用 `_deletingFundIds` Set 防止重复调用

### 修改的文件

| 文件 | 变更 |
|------|------|
| `lib/widgets/fund_card.dart` | 简化 confirmDismiss 回调，直接返回 true |
| `lib/providers/portfolio_provider.dart` | 添加 `_deletingFundIds` 防重复删除机制 |

### Git 提交

```
1d51efb fix: 修复基金删除确认对话框重复问题（M22）
```

---

## 当前项目状态

| 阶段 | 状态 | 说明 |
|------|------|------|
| M1-M16 | ✅ 已完成 | 基础功能和UI |
| M17 | ✅ 已完成 | 再平衡功能 |
| M18 | ✅ 已完成 | 首页跳转 |
| M19 | ✅ 已完成 | 代码清理 |
| M20 | ✅ 已完成 | 全选功能修复 |
| M21 | ✅ 已完成 | 基金删除撤销功能 |
| M22 | ✅ 已完成 | 删除确认对话框修复 |

### 技术状态

| 指标 | 状态 |
|------|------|
| flutter analyze | ✅ 0 errors (6 个 info 警告) |
| Git status | ✅ 已推送到远程 |

### 核心功能状态

| 功能 | 状态 | 描述 |
|------|------|------|
| 基金录入 | ✅ 完整 | 添加、编辑、删除 |
| 统计可视化 | ✅ 完整 | 饼图、类别分布 |
| 监控提醒 | ✅ 完整 | 偏离预警 |
| 再平衡功能 | ✅ 完整 | 预览、执行、撤销 |
| 删除撤销 | ✅ 完整 | 最多 10 条历史，多次撤销 |
| 项目规则 | ✅ 已建立 | superpowers 规范、方案保存、状态记录 |

---

## M23：修复 FundSnapshot Hive 适配器未注册问题 2026-02-04

### 问题描述

执行再平衡操作时，Dart 抛出错误：
```
DartError: HiveError: Cannot write, unknown type: FundSnapshot. Did you forget to register an adapter?
```

### 根因分析

1. **导入隐藏问题**：`hive_service.dart:5` 使用 `hide` 关键字隐藏了 `FundSnapshotAdapter`
2. **适配器注册缺失**：`init()` 方法中未注册 `FundSnapshotAdapter`
3. **嵌套对象序列化失败**：`RebalanceSnapshot.funds` 字段类型为 `List<FundSnapshot>`，写入时需要序列化嵌套对象

### 修复内容

| 文件 | 修改 |
|------|------|
| `lib/services/hive_service.dart` | 移除 `hide FundSnapshot, FundSnapshotAdapter` |
| `lib/services/hive_service.dart` | 添加 `Hive.registerAdapter(FundSnapshotAdapter());` |

### 验证结果

```
flutter analyze: ✅ 0 errors
```

### Git 提交

```
[待提交]
```

### 方案文档

`docs/plans/fix-fundsnapshot-adapter-missing.md`

---

## 移除删除 Snackbar，改用历史记录统一撤销 2026-02-04

### 问题描述

删除基金后弹出的 Snackbar 不会自动消失，用户体验不佳。

### 修改内容

| 文件 | 修改 |
|------|------|
| `lib/screens/home_screen.dart` | 移除删除 Snackbar |
| `lib/screens/fund_list_screen.dart` | 移除 `_showUndoSnackBar` 方法和调用 |
| `lib/screens/fund_list_screen.dart` | 历史记录图标始终显示（移除 `canUndo` 条件） |
| `lib/screens/fund_list_screen.dart` | 添加空状态检查（暂无删除记录） |

### 效果

- 删除基金后不再弹出 Snackbar
- 基金列表页面 AppBar 右侧历史记录图标始终可见
- 点击图标可执行撤销操作或查看空状态

### Git 提交

```
7a46fdb refactor: 移除删除Snackbar，改用历史记录统一撤销
```

---

## 首页类别卡片添加基金编辑功能 2026-02-04

### 功能描述

在首页类别卡片展开后，点击基金项可编辑基金信息（金额等）。

### 修改内容

| 文件 | 修改 |
|------|------|
| `lib/widgets/category_card.dart` | 添加 `onFundTap` 回调参数，基金项添加 InkWell 点击区域 |
| `lib/screens/home_screen.dart` | 添加 `_showEditFundDialog` 方法，传递 `onFundTap` 参数 |

### 效果

- 首页类别展开后显示的基金列表项可点击
- 点击后弹出编辑弹窗，可修改金额等信息
- 编辑保存后自动更新首页数据
- 删除功能保持不受影响

### Git 提交

```
33b6458 feat: 首页类别卡片添加基金编辑功能
```

### 方案文档

`docs/plans/home-screen-fund-edit-20260204.md`

---

## 当前项目状态

| 阶段 | 状态 | 说明 |
|------|------|------|
| M1-M16 | ✅ 已完成 | 基础功能和UI |
| M17-M20 | ✅ 已完成 | 再平衡、跳转、清理 |
| M21 | ✅ 已完成 | 基金删除撤销功能 |
| M22 | ✅ 已完成 | 删除确认对话框修复 |
| M23 | ✅ 已完成 | FundSnapshot 适配器修复 |
| M24 | ✅ 已完成 | 移除删除 Snackbar |
| M25 | ✅ 已完成 | 首页基金编辑功能 |

### 技术状态

| 指标 | 状态 |
|------|------|
| flutter analyze | ✅ 0 errors (3 个 info 警告) |
| Git status | ✅ 已推送到远程 |

### 核心功能状态

| 功能 | 状态 | 描述 |
|------|------|------|
| 基金录入 | ✅ 完整 | 添加、编辑、删除 |
| 统计可视化 | ✅ 完整 | 饼图、类别分布 |
| 监控提醒 | ✅ 完整 | 偏离预警 |
| 再平衡功能 | ✅ 完整 | 预览、执行、撤销 |
| 删除撤销 | ✅ 完整 | 最多 10 条历史，多次撤销 |
| 首页基金编辑 | ✅ 完整 | 展开后点击编辑 |
| 项目规则 | ✅ 已建立 | superpowers 规范、方案保存、状态记录 |

---

## M26：移除 MainScreen 重复标题 2026-02-04

### 问题描述

1. MainScreen 在屏幕左上角显示每个页面的图标和标题
2. 每个子页面自带 AppBar，显示相同或类似的标题
3. 造成标题重复显示

### 修改内容

| 文件 | 修改 |
|------|------|
| `lib/screens/main_screen.dart` | 移除 AppBar、移除 `_titles` 和 `_getCurrentIcon()` |
| `lib/screens/home_screen.dart` | 添加 AppBar（金色图标 + "财富管理"） |
| `lib/screens/fund_list_screen.dart` | 更新 AppBar 样式（金色图标 + 动态标题） |
| `lib/screens/statistics_screen.dart` | 更新 AppBar 样式（金色图标 + "投资统计"） |
| `lib/screens/rebalance_screen.dart` | 更新 AppBar 样式（金色图标 + "再平衡"） |

### AppBar 样式

每个页面使用统一的标题样式：
- 金色渐变图标容器
- 22px 粗体标题文字
- 图标与文字间距 12px

### 验证结果

```
flutter analyze: ✅ 0 errors (4 个 info 警告)
```

### 方案文档

`docs/plans/remove-main-screen-duplicate-titles-20260204.md`

---

## M27：修复基金列表编辑模式全选状态不同步 2026-02-04

### 问题描述

撤销删除后再次进入编辑模式，全选按钮仍显示"取消全选"状态。

### 修复内容

| 文件 | 修改 |
|------|------|
| `lib/screens/fund_list_screen.dart` | 更新 `_toggleEditMode` 方法，进入编辑模式时重新计算全选状态 |

### 验证结果

```
flutter analyze: ✅ 0 errors (4 个 info 警告)
```

### 方案文档

`docs/plans/fix-fund-list-edit-mode-state-20260204.md`

---

## M28：修复总金额为0时显示错误偏离度 2026-02-04

### 问题描述

当总投资金额（totalAmount）为0时，每个类别都显示 -25% 偏离度，但实际上投资组合为空，应被视为"平衡"状态。

### 问题根源

`calculateDeviations()` 方法计算逻辑：0% - 25% = -25%

### 修复内容

| 文件 | 修改 |
|------|------|
| `lib/services/portfolio_calculator.dart` | 修改 `calculateDeviations()`，totalAmount 为 0 时返回 0 偏离度 |
| `lib/screens/statistics_screen.dart` | 修改偏离度显示，0% 时显示"平衡" |
| `lib/screens/rebalance_screen.dart` | 修改偏离度显示，0% 时显示"平衡" |

### 验证结果

```
flutter analyze: ✅ 0 errors (4 个 info 警告)
```

### 方案文档

`docs/plans/fix-zero-total-amount-deviation-display-20260204.md`

---

## M28 补充：修复首页类别卡片偏离度显示 2026-02-04

### 问题描述

在 M28 修复中遗漏了 `category_card.dart` 组件，投资组合为空时仍显示 -25% 偏离度。

### 修复内容

| 文件 | 修改 |
|------|------|
| `lib/widgets/category_card.dart` | 修复偏离度显示，0% 时显示"平衡" |

### 验证结果

```
flutter analyze: ✅ 0 errors (4 个 info 警告)
```

### 方案文档

`docs/plans/fix-category-card-deviation-display-20260204.md`

---

## M29：修复总金额为0时错误显示警告问题 2026-02-04

### 问题描述

当总投资金额（totalAmount）为0时：
1. 首页显示"部分投资类别偏离目标配置，请关注"警告
2. 但点击"查看详情"后，统计页面和再平衡页面显示"投资组合已平衡"

### 问题根源

1. `getCategoriesWithWarning()` 没有考虑 `totalAmount == 0` 的情况
2. `isDeficient(0)` 返回 `true`（0 < 0.2），导致每个类别都被标记为"不足"
3. 之前的修复中 `deviation == 0` 判断有误，应为 `percentage == 0`

### 修复内容

| 文件 | 修改 |
|------|------|
| `lib/services/portfolio_calculator.dart` | `getCategoriesWithWarning()` 增加 totalAmount == 0 判断 |
| `lib/services/rebalance_calculator.dart` | `needsRebalancing()` 增加 totalAmount == 0 判断 |
| `lib/screens/statistics_screen.dart` | `deviation == 0` 改为 `percentage == 0` |
| `lib/screens/rebalance_screen.dart` | `deviation == 0` 改为 `percentage == 0` |

### 验证结果

```
flutter analyze: ✅ 0 errors (4 个 info 警告)
```

### 方案文档

`docs/plans/fix-zero-total-amount-warning-state-20260204.md`

---

## M30：修复总金额为0时百分比显示为0%的问题 2026-02-04

### 问题描述

当总投资金额（totalAmount）为0时：
- 各类别当前百分比显示 0%
- 应该显示 25%（与目标比例一致）

### 问题根源

`calculateCategoryPercentages()` 方法在 total == 0 时返回 0

### 修复内容

| 文件 | 修改 |
|------|------|
| `lib/services/portfolio_calculator.dart` | `calculateCategoryPercentages()` 在 total == 0 时返回 0.25 |
| `lib/services/portfolio_calculator.dart` | `calculateDeviations()` 恢复原有逻辑 |
| `lib/services/portfolio_calculator.dart` | `getCategoriesWithWarning()` 恢复原有逻辑 |
| `lib/services/rebalance_calculator.dart` | `needsRebalancing()` 恢复原有逻辑 |
| `lib/screens/statistics_screen.dart` | `percentage == 0` 恢复为 `deviation == 0` |
| `lib/screens/rebalance_screen.dart` | `percentage == 0` 恢复为 `deviation == 0` |
| `lib/widgets/category_card.dart` | `currentPercentage == 0` 恢复为 `deviation == 0` |

### 预期效果

| 页面 | 空状态显示 |
|------|-----------|
| 首页类别卡片 | 25%，偏离"平衡" |
| 统计页面类别详情 | 25%，偏离"平衡" |
| 再平衡当前配置 | 25%，偏离"平衡" |
| 首页警告 | 不显示 |

### 验证结果

```
flutter analyze: ✅ 0 errors (4 个 info 警告)
```

### 方案文档

`docs/plans/fix-zero-total-amount-percentage-display-20260204.md`

---

## M31：修复首页类别卡片百分比显示错误问题 2026-02-04

### 问题描述

总金额为0时，首页类别卡片显示占比0%，偏离25%，但应该显示占比25%，偏离0%。

### 问题根源

首页类别卡片使用 `Portfolio.getPercentageByCategory()` 获取百分比，该方法在 `totalAmount == 0` 时返回 0。

### 修复内容

| 文件 | 修改 |
|------|------|
| `lib/models/portfolio.dart` | `getPercentageByCategory()` 返回 0.25 |

### 验证结果

```
flutter analyze: ✅ 0 errors (4 个 info 警告)
```

### 方案文档

`docs/plans/fix-home-category-card-percentage-display-20260204.md`

---

## M32：添加空类别无法执行再平衡的检查 2026-02-04

### 问题描述

当四个类别中有类别空缺时（比如只添加了一只股票基金，其它三个类别为空），执行再平衡操作会出现问题：
- 再平衡只调整现有基金的金额
- 空类别中没有基金可以接收资金转移
- 导致资金丢失

### 解决方案

方案A：不执行再平衡，向用户显示原因和解决方案

### 修复内容

| 文件 | 修改 |
|------|------|
| `lib/models/rebalance_check_result.dart` | 新建检查结果类 |
| `lib/providers/portfolio_provider.dart` | 添加 `checkCanRebalance()` 方法 |
| `lib/screens/home_screen.dart` | 显示不可执行状态和原因 |
| `lib/screens/rebalance_screen.dart` | 预览前检查，显示原因对话框和"去添加基金"按钮 |

### 预期效果

**首页再平衡卡片（空类别时）：**
- 显示警告图标和原因文字
- 点击跳转到再平衡页面

**再平衡页面（空类别时）：**
- 显示"无法执行再平衡"状态
- 显示原因和"去添加基金"按钮
- 点击跳转到首页添加基金

### 验证结果

```
flutter analyze: ✅ 0 errors (5 个 info 警告)
```

### 方案文档

`docs/plans/add-rebalance-empty-category-check-20260204.md`

---

## M32 补充：显示所有空类别 2026-02-04

### 问题描述

当多个类别为空时，原实现只显示第一个空类别（如"债券类别为空"），但用户应该知道所有空类别的情况。

### 修复内容

| 文件 | 修改 |
|------|------|
| `lib/models/rebalance_check_result.dart` | 支持多个空类别，返回列表 |
| `lib/providers/portfolio_provider.dart` | 返回所有空类别列表 |

### 预期效果

**空类别提示：**
```
无法执行再平衡：债券、现金、黄金类别为空，无法接收资金转移。请先在这些类别中添加基金。
```

### 验证结果

```
flutter analyze: ✅ 0 errors (6 个 info 警告)
```

---

## M32 补充2：修复"去添加基金"按钮跳转问题 2026-02-04

### 问题描述

点击"去添加基金"按钮后直接白屏，无法跳转到首页并显示添加基金对话框。

### 问题根源

`RebalanceScreen` 是 `MainScreen` 的 Tab 之一（通过 `IndexedStack` 管理），不是独立页面。`Navigator.pop(context)` 无效导致白屏。

### 修复内容

| 文件 | 修改 |
|------|------|
| `lib/providers/portfolio_provider.dart` | 添加 `shouldShowAddFundDialog` 状态和 `triggerShowAddFundDialog()`、`hideAddFundDialog()` 方法 |
| `lib/screens/home_screen.dart` | 监听 `shouldShowAddFundDialog` 状态，显示添加基金对话框 |
| `lib/screens/rebalance_screen.dart` | 移除 `Navigator.pop`，改为触发状态 |

### 预期效果

点击"去添加基金"按钮后：
1. 切换到首页 Tab
2. 自动显示添加基金对话框

### 验证结果

```
flutter analyze: ✅ 0 errors (6 个 info 警告)
```

---

## M33：修复再平衡阈值功能 2026-02-04

### 问题描述

再平衡阈值功能不能正常工作：
1. `generateRebalanceActions()` 使用硬编码 `adjustment.abs() > 1`，未使用阈值
2. `previewRebalance()` 未使用阈值，始终显示所有变化
3. `executeRebalance()` 未使用阈值，始终执行所有调整
4. 输入验证不完善，输入 >= 100 时无明确提示

### 修复内容

| 文件 | 修改 |
|------|------|
| `lib/services/rebalance_calculator.dart` | `generateRebalanceActions()` 使用阈值过滤 |
| `lib/providers/portfolio_provider.dart` | `previewRebalance()` 和 `executeRebalance()` 使用阈值 |
| `lib/screens/rebalance_screen.dart` | 移除内联 TextField，改为可点击卡片 + ModalBottomSheet |
| `test/services/rebalance_calculator_test.dart` | 更新测试用例 |

### 额外修复

1. **输入验证**：输入 >= 100 时自动重置为 10%
2. **除以零保护**：totalAmount == 0 时避免除零错误

### 验证结果

```
flutter test: ✅ 8 passed
flutter analyze: ✅ 0 errors
```

### Git 提交

```
4abc047 feat: 修复再平衡阈值功能，添加阈值设置UI和持久化
```

### 方案文档

`docs/plans/rebalance-threshold-fix.md`

---

## M34：再平衡阈值设置交互优化 2026-02-04

### 问题描述

原始输入框直接显示在内联卡片中，用户体验不佳：
1. 输入框直接显示，用户可能误操作
2. 输入 >= 100 自动重置，无明确提示
3. 无清晰的确认/取消流程

### 解决方案

使用 ModalBottomSheet 弹出独立编辑界面：
1. 点击阈值卡片弹出底部面板
2. 自动弹出键盘
3. 实时验证，错误提示明确
4. 确认按钮状态控制

### 验证逻辑

| 输入值 | 按钮状态 | 错误提示 |
|-------|---------|---------|
| 空值 | 禁用 | 请输入有效的数字 |
| <= 0 | 禁用 | 请输入有效的数字 |
| 0 < value < 100 | 启用 | 无 |
| >= 100 | 禁用 | 阈值不能大于或等于100% |

### 修改文件

| 文件 | 修改 |
|------|------|
| `lib/screens/rebalance_screen.dart` | `_buildThresholdSettingCard()` 改为可点击卡片 |
| `lib/screens/rebalance_screen.dart` | 新增 `_showThresholdBottomSheet()` 方法 |
| `lib/screens/rebalance_screen.dart` | 新增 `_ThresholdEditSheet` 组件 |

### 验证结果

```
flutter test: ✅ 8 passed
flutter analyze: ✅ 0 errors
```

### 方案文档

`docs/plans/rebalance-threshold-modal-sheet.md`

---

## M35：修复首页警告与再平衡阈值不一致问题 2026-02-04

### 问题描述

更新再平衡阈值后，即使所有类别的偏移值都在阈值之内，首页仍然会显示警告"部分投资类别偏离目标配置"。

### 问题根源

首页警告与再平衡判断使用了**不同的阈值标准**：

| 功能 | 判断逻辑 | 阈值来源 |
|-----|---------|---------|
| 首页警告 `hasWarnings` | `TargetAllocation.isExcessive/Deficient()` | **固定阈值 ±20%** |
| 再平衡 `needsRebalancing` | `deviation.abs() > threshold` | **用户自定义阈值** |

### 修复内容

| 文件 | 修改 |
|------|------|
| `lib/providers/portfolio_provider.dart` | 添加 `hasWarningsConsideringThreshold` getter |
| `lib/screens/home_screen.dart` | 使用 `hasWarningsConsideringThreshold` 替换 `hasWarnings` |

### 验证结果

```
flutter test: ✅ 8 passed
flutter analyze: ✅ 0 errors
```

### 方案文档

`docs/plans/fix-warning-threshold-consistency.md`

---

## 当前项目状态

| 阶段 | 状态 | 说明 |
|------|------|------|
| M1-M16 | ✅ 已完成 | 基础功能和UI |
| M17-M20 | ✅ 已完成 | 再平衡、跳转、清理 |
| M21-M25 | ✅ 已完成 | 撤销、编辑功能 |
| M26-M31 | ✅ 已完成 | UI修复和优化 |
| M32 | ✅ 已完成 | 空类别检查 |
| M33 | ✅ 已完成 | 再平衡阈值功能修复 |
| M34 | ✅ 已完成 | 阈值设置交互优化 |
| M35 | ✅ 已完成 | 警告与阈值一致性修复 |

### 技术状态

| 指标 | 状态 |
|------|------|
| flutter analyze | ✅ 0 errors |
| flutter test | ✅ 8 passed |
| Git status | ✅ 待提交 |

### 核心功能状态

| 功能 | 状态 | 描述 |
|------|------|------|
| 基金录入 | ✅ 完整 | 添加、编辑、删除 |
| 统计可视化 | ✅ 完整 | 饼图、类别分布 |
| 监控提醒 | ✅ 完整 | 偏离预警（与阈值一致） |
| 再平衡功能 | ✅ 完整 | 预览、执行、撤销 |
| 删除撤销 | ✅ 完整 | 最多 10 条历史，多次撤销 |
| 首页基金编辑 | ✅ 完整 | 展开后点击编辑 |
| 阈值设置 | ✅ 完整 | ModalBottomSheet 交互优化 |
| 项目规则 | ✅ 已建立 | superpowers 规范、方案保存、状态记录 |

---

## 已修复 Bug

- [2026-02-05] CategoryCard RenderFlex 溢出问题
