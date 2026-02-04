# 再平衡阈值设置交互优化方案

## 1. 概述

### 1.1 目标
将再平衡阈值设置从当前的内联 TextField 改为点击卡片后弹出 ModalBottomSheet 的形式，提供更好的输入体验和验证反馈。

### 1.2 用户体验改进

| 现状 | 改进后 |
|-----|-------|
| 输入框直接显示，用户可能误操作 | 点击卡片后才进入编辑模式 |
| 输入 >=100 自动重置，无明确提示 | 确认按钮禁用，显示红色警告文案 |
| 无清晰的确认/取消流程 | 明确的"确认"和"取消"按钮 |

---

## 2. UI 设计

### 2.1 触发入口

**修改 `_buildThresholdSettingCard()`**

移除内联 TextField 和重置按钮，改为可点击的卡片：

```dart
Widget _buildThresholdSettingCard(PortfolioProvider provider) {
  final threshold = provider.rebalanceThreshold;

  return InkWell(
    onTap: () => _showThresholdBottomSheet(context, provider),
    borderRadius: BorderRadius.circular(20),
    child: Container(
      decoration: AppTheme.getCardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(Icons.tune, color: AppTheme.accentGold),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '再平衡阈值',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(threshold * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.4)),
        ],
      ),
    ),
  );
}
```

### 2.2 ModalBottomSheet 设计

```dart
void _showThresholdBottomSheet(BuildContext context, PortfolioProvider provider) {
  final controller = TextEditingController(
    text: (provider.rebalanceThreshold * 100).toStringAsFixed(2),
  );
  final focusNode = FocusNode();

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true, // 支持输入法弹出
    builder: (context) => Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A2D47), Color(0xFF0D1B2A)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(
            color: AppTheme.accentGold.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: _ThresholdEditSheet(
        controller: controller,
        focusNode: focusNode,
        currentThreshold: provider.rebalanceThreshold,
        onConfirm: (value) {
          provider.setRebalanceThreshold(value / 100);
          Navigator.pop(context);
        },
        onCancel: () => Navigator.pop(context),
      ),
    ),
  );

  // 自动弹出键盘
  Future.delayed(const Duration(milliseconds: 100), () {
    focusNode.requestFocus();
  });
}
```

### 2.3 `_ThresholdEditSheet` 组件

```dart
class _ThresholdEditSheet extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final double currentThreshold;
  final void Function(double value) onConfirm;
  final VoidCallback onCancel;

  const _ThresholdEditSheet({
    required this.controller,
    required this.focusNode,
    required this.currentThreshold,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<_ThresholdEditSheet> createState() => _ThresholdEditSheetState();
}

class _ThresholdEditSheetState extends State<_ThresholdEditSheet> {
  String? _errorText;

  void _validateInput(String value) {
    final parsed = double.tryParse(value);

    if (parsed == null || parsed <= 0) {
      setState(() {
        _errorText = '请输入有效的数字';
      });
    } else if (parsed >= 100) {
      setState(() {
        _errorText = '阈值不能大于或等于100%';
      });
    } else {
      setState(() {
        _errorText = null;
      });
    }
  }

  bool get _isValid {
    final parsed = double.tryParse(widget.controller.text);
    return parsed != null && parsed > 0 && parsed < 100;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          Row(
            children: [
              IconButton(
                onPressed: widget.onCancel,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
              const Expanded(
                child: Text(
                  '设置再平衡阈值',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48), // 占位保持居中
            ],
          ),
          const SizedBox(height: 24),

          // 说明文字
          const Text(
            '当某个类别偏离目标超过此阈值时，系统将建议进行再平衡操作',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // 输入框
          TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white, fontSize: 24),
            decoration: InputDecoration(
              suffix: const Text('%', style: TextStyle(color: Colors.white70, fontSize: 18)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _errorText != null ? AppTheme.error : Colors.white.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _errorText != null ? AppTheme.error : AppTheme.accentGold,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onChanged: _validateInput,
          ),

          // 错误提示
          if (_errorText != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.error_outline, color: AppTheme.error, size: 16),
                const SizedBox(width: 6),
                Text(
                  _errorText!,
                  style: TextStyle(color: AppTheme.error, fontSize: 13),
                ),
              ],
            ),
          ],

          // 当前值显示
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '当前阈值',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              ),
              Text(
                '${(widget.currentThreshold * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: AppTheme.accentGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 确认按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isValid ? () => widget.onConfirm(double.parse(widget.controller.text)) : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: _isValid ? AppTheme.accentGold : Colors.white.withValues(alpha: 0.1),
                foregroundColor: _isValid ? AppTheme.primaryDark : Colors.white.withValues(alpha: 0.3),
              ),
              child: const Text(
                '确认',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 3. 验证逻辑

### 3.1 输入验证规则

| 输入值 | 确认按钮 | 错误提示 |
|-------|---------|---------|
| 空值 | 禁用 | 请输入有效的数字 |
| <= 0 | 禁用 | 请输入有效的数字 |
| 0 < value < 100 | 启用 | 无 |
| >= 100 | 禁用 | 阈值不能大于或等于100% |

### 3.2 验证时机

- **实时验证**：用户每次输入字符后立即更新错误提示和按钮状态
- **数字验证**：使用 `double.tryParse()` 确保输入的是有效数字

---

## 4. 数据流

```
用户点击卡片
    ↓
showModalBottomSheet 弹出
    ↓
_ThresholdEditSheet 显示
    ↓
用户输入 → onChanged → 验证 → 更新 UI
    ↓
点击"确认" → onConfirm(value) → provider.setRebalanceThreshold() → 保存 → 关闭
点击"取消"/遮罩 → 关闭 → 不保存
```

---

## 5. 组件关系

```
RebalanceScreen
    └── _buildThresholdSettingCard()
            └── onTap → _showThresholdBottomSheet()
                    └── ModalBottomSheet
                            └── _ThresholdEditSheet
                                    ├── TextField (输入)
                                    ├── 错误提示 (条件显示)
                                    ├── 确认按钮 (状态控制)
                                    └── 取消 (IconButton)
```

---

## 6. 需要修改的文件

| 文件 | 修改内容 |
|-----|---------|
| `lib/screens/rebalance_screen.dart` | 修改 `_buildThresholdSettingCard()` 为可点击卡片，移除内联 TextField |
| `lib/screens/rebalance_screen.dart` | 新增 `_showThresholdBottomSheet()` 方法 |
| `lib/screens/rebalance_screen.dart` | 新增 `_ThresholdEditSheet` StatefulWidget |

---

## 7. 测试点

### 7.1 功能测试
- [ ] 点击卡片能正确弹出 BottomSheet
- [ ] 自动弹出键盘
- [ ] 输入有效值（10-99）确认按钮启用
- [ ] 输入无效值（空、<=0、>=100）确认按钮禁用
- [ ] 错误提示正确显示
- [ ] 点击确认保存并关闭
- [ ] 点击取消/遮罩关闭不保存
- [ ] 输入法弹出时 BottomSheet 正确适配

### 7.2 边界测试
- [ ] 输入 "0" 时显示错误提示
- [ ] 输入 "100" 时显示错误提示
- [ ] 输入 "99.99" 正常保存
- [ ] 输入非数字字符时显示错误提示

---

## 8. 依赖和前提条件

- 项目已有 `showModalBottomSheet` 的实现参考 (`_showRebalanceSheet`)
- `PortfolioProvider.setRebalanceThreshold()` 方法已存在
- AppTheme 中的样式定义可以直接使用

---

## 9. 预估工作量

- **UI 实现**：约 30 分钟
- **逻辑验证**：约 10 分钟
- **测试**：约 15 分钟
- **总计**：约 55 分钟
