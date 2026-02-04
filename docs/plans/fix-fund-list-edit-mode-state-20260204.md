# 修复基金列表编辑模式全选状态不同步问题

## 问题描述

1. 在基金列表页面，点击"编辑"进入编辑模式
2. 点击"全选" -> `_isAllSelected = true`
3. 删除基金 -> 退出编辑模式，`_selectedFundIds` 清空
4. 撤销删除 -> 基金恢复，但 `_selectedFundIds` 为空
5. 再次点击"编辑" -> 进入编辑模式，`_isAllSelected` 仍为 true（未重新计算）

## 问题根源

`_toggleEditMode` 方法中，进入编辑模式时没有重新计算 `_isAllSelected`。

## 修复方案

**修改文件：** `lib/screens/fund_list_screen.dart`

**修改内容：**
```dart
void _toggleEditMode() {
  setState(() {
    _isEditMode = !_isEditMode;
    if (!_isEditMode) {
      _selectedFundIds.clear();
      _isAllSelected = false;
    } else {
      // 进入编辑模式时，重新计算全选状态
      final provider = Provider.of<PortfolioProvider>(context, listen: false);
      final funds = provider.getAllFunds();
      _isAllSelected = _selectedFundIds.isNotEmpty &&
          _selectedFundIds.length == funds.length;
    }
  });
}
```

## 验证步骤

1. 运行 `flutter analyze` 检查是否有错误
2. 测试以下场景：
   - 进入编辑模式 -> 全选 -> 删除 -> 撤销 -> 再次进入编辑模式
   - 确认全选按钮状态正确显示

## 修改文件清单

| 文件 | 操作 | 说明 |
|------|------|------|
| `lib/screens/fund_list_screen.dart` | 修改 | 更新 `_toggleEditMode` 方法 |
