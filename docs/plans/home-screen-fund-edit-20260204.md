# 首页类别卡片添加基金编辑功能

## 需求描述

在首页中，点击每个类别的展开按钮可以显示该类别中的每只基金。希望能够通过点击该基金卡片来编辑它的信息，如更改金额。

## 修改目标

1. 类别展开后显示的基金列表项可点击
2. 点击后弹出编辑弹窗，可修改基金信息（金额等）
3. 编辑保存后自动更新首页数据
4. 删除功能保持不受影响

## 修改内容

### 1. CategoryCard 添加 onFundTap 回调参数

**文件**: `lib/widgets/category_card.dart`

**修改点1.1**: 添加 `onFundTap` 回调参数到类定义

```dart
class CategoryCard extends StatefulWidget {
  final PortfolioCategory category;
  final double currentAmount;
  final double targetAmount;
  final double currentPercentage;
  final double targetPercentage;
  final List<Fund> funds;
  final Function(Fund fund)? onDeleteFund;
  final Function(Fund fund)? onFundTap;  // 新增：基金点击回调
  final Function(PortfolioCategory category)? onAddFund;

  const CategoryCard({
    super.key,
    required this.category,
    // ... 其他参数
    this.onDeleteFund,
    this.onFundTap,  // 新增
    this.onAddFund,
  });
}
```

**修改点1.2**: 在 `_buildFundItem` 方法中添加点击区域

```dart
Widget _buildFundItem(BuildContext context, Fund fund) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () => widget.onFundTap?.call(fund),  // 新增点击事件
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    categoryColors[widget.category]?.withValues(alpha: 0.3) ?? AppTheme.primary.withValues(alpha: 0.3),
                    categoryColors[widget.category]?.withValues(alpha: 0.1) ?? AppTheme.primary.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                categoryIcons[widget.category],
                color: categoryColors[widget.category] ?? AppTheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fund.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    fund.code,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              Formatters.formatCurrency(fund.amount),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => widget.onDeleteFund?.call(fund),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.deleteColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: AppTheme.deleteColor,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
```

### 2. HomeScreen 传递 onFundTap 参数

**文件**: `lib/screens/home_screen.dart`

**修改点2.1**: 在 HomeScreen 中添加 `_showEditFundDialog` 方法

```dart
void _showEditFundDialog(BuildContext context, PortfolioProvider provider, Fund fund) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: AppTheme.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(24),
        decoration: AppTheme.getCardDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primary.withValues(alpha: 0.2),
                        AppTheme.primary.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.edit, color: AppTheme.primary),
                ),
                const SizedBox(width: 12),
                const Text(
                  '编辑基金',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Flexible(
              child: SingleChildScrollView(
                child: AddFundForm(
                  existingFund: fund,
                  onSaved: (updatedFund) {
                    provider.updateFund(updatedFund);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
```

**修改点2.2**: 在 CategoryCard 中传递 `onFundTap` 参数

```dart
CategoryCard(
  category: category,
  currentAmount: provider.portfolio?.getAmountByCategory(category) ?? 0.0,
  targetAmount: (provider.portfolio?.totalAmount ?? 0.0) * TargetAllocation.getTarget(category),
  currentPercentage: provider.portfolio?.getPercentageByCategory(category) ?? 0.0,
  targetPercentage: TargetAllocation.getTarget(category),
  funds: provider.getFundsByCategory(category),
  onDeleteFund: (fund) async {
    await provider.deleteFund(fund.id);
  },
  onFundTap: (fund) => _showEditFundDialog(context, provider, fund),  // 新增
  onAddFund: (category) {
    _showAddFundDialogWithCategory(category);
  },
),
```

### 3. 添加 AddFundForm 导入

**文件**: `lib/screens/home_screen.dart`

在文件顶部添加导入：

```dart
import 'package:InvestmentApp/widgets/add_fund_form.dart';
```

## 文件清单

| 文件 | 修改内容 |
|-----|---------|
| `lib/widgets/category_card.dart` | 添加 `onFundTap` 回调参数，在 `_buildFundItem` 中添加点击区域 |
| `lib/screens/home_screen.dart` | 添加 `_showEditFundDialog` 方法，传递 `onFundTap` 参数 |
| `lib/screens/home_screen.dart` | 添加 `AddFundForm` 导入 |

## 验收标准

1. ✅ 首页类别展开后显示的基金列表项可点击
2. ✅ 点击后弹出编辑弹窗，可修改金额等信息
3. ✅ 编辑保存后自动更新首页数据
4. ✅ 删除功能保持不受影响
5. ✅ 代码分析无错误
