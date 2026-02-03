import 'package:flutter/material.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/theme/app_theme.dart';
import 'package:investment_app/utils/formatters.dart';
import 'package:investment_app/widgets/add_fund_form.dart';
import 'package:investment_app/widgets/fund_card.dart';
import 'package:provider/provider.dart';

class FundListScreen extends StatefulWidget {
  const FundListScreen({super.key});

  @override
  State<FundListScreen> createState() => _FundListScreenState();
}

class _FundListScreenState extends State<FundListScreen> {
  bool _isEditMode = false;
  final Set<String> _selectedFundIds = {};
  bool _isAllSelected = false;

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        _selectedFundIds.clear();
        _isAllSelected = false;
      }
    });
  }

  void _toggleFundSelection(String fundId) {
    final provider = Provider.of<PortfolioProvider>(context, listen: false);
    final funds = provider.getAllFunds();
    
    setState(() {
      if (_selectedFundIds.contains(fundId)) {
        _selectedFundIds.remove(fundId);
      } else {
        _selectedFundIds.add(fundId);
      }
      _isAllSelected = _selectedFundIds.isNotEmpty && _selectedFundIds.length == funds.length;
    });
  }

  void _selectAll(List<Fund> funds) {
    setState(() {
      if (_isAllSelected) {
        _selectedFundIds.clear();
        _isAllSelected = false;
      } else {
        _selectedFundIds.clear();
        _selectedFundIds.addAll(funds.map((f) => f.id));
        _isAllSelected = true;
      }
    });
  }

  void _batchDelete(BuildContext context, PortfolioProvider provider) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppTheme.cardBackground,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.cardBackground,
                AppTheme.cardBackgroundAlt,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.deleteColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.delete_sweep, color: AppTheme.deleteColor, size: 36),
              ),
              const SizedBox(height: 20),
              const Text(
                '批量删除',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '确定要删除选中的 ${_selectedFundIds.length} 只基金吗？',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        '取消',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        for (final fundId in _selectedFundIds) {
                          await provider.deleteFund(fundId);
                        }
                        setState(() {
                          _selectedFundIds.clear();
                          _isEditMode = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.white),
                                const SizedBox(width: 10),
                                Text('已删除 ${_selectedFundIds.length} 只基金'),
                              ],
                            ),
                            backgroundColor: AppTheme.success,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.deleteColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('删除'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _isEditMode ? '选择基金' : '我的基金',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          if (_isEditMode)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
                onPressed: _toggleEditMode,
              ),
            ),
          if (!_isEditMode)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: _toggleEditMode,
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.edit_outlined, color: AppTheme.accentGold),
                ),
                label: const Text(
                  '编辑',
                  style: TextStyle(color: AppTheme.accentGold),
                ),
              ),
            ),
          if (_isEditMode && _selectedFundIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: () => _batchDelete(
                  context,
                  Provider.of<PortfolioProvider>(context, listen: false),
                ),
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.delete_outline, color: AppTheme.deleteColor),
                ),
                label: Text(
                  '删除 ${_selectedFundIds.length}',
                  style: const TextStyle(color: AppTheme.deleteColor),
                ),
              ),
            ),
        ],
      ),
      body: Consumer<PortfolioProvider>(
        builder: (context, provider, child) {
          final funds = provider.getAllFunds();

          if (funds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.surfaceLight.withValues(alpha: 0.3),
                          AppTheme.surfaceLight.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppTheme.accentGold.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet,
                      size: 42,
                      color: AppTheme.accentGold.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '暂无基金',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '点击下方按钮添加您的第一只基金',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                   const SizedBox(height: 32),
                  InkWell(
                    onTap: () => _showAddFundDialog(context),
                    borderRadius: BorderRadius.circular(14),
                    splashColor: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.accentGold, Color(0xFFE8C560)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentGold.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: AppTheme.primaryDark),
                          SizedBox(width: 8),
                          Text(
                            '添加基金',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              if (_isEditMode)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.accentGold.withValues(alpha: 0.15),
                        AppTheme.accentGold.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.accentGold.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => _selectAll(funds),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _isAllSelected
                                  ? AppTheme.accentGold
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _isAllSelected
                                    ? AppTheme.accentGold
                                    : Colors.white.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isAllSelected
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: _isAllSelected
                                      ? AppTheme.primaryDark
                                      : Colors.white.withValues(alpha: 0.5),
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _isAllSelected ? '取消全选' : '全选',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _isAllSelected
                                        ? AppTheme.primaryDark
                                        : Colors.white.withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '已选择 ${_selectedFundIds.length}/${funds.length} 项',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: funds.length,
                  itemBuilder: (context, index) {
                    final fund = funds[index];
                    final isSelected = _selectedFundIds.contains(fund.id);

                    if (_isEditMode) {
                      return _buildSelectableFundItem(context, fund, isSelected, provider);
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: FundCard(
                        fund: fund,
                        onTap: () => _showEditFundDialog(context, fund),
                        onDelete: () => _confirmDelete(context, fund, provider),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: () => _showAddFundDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('添加基金'),
          backgroundColor: AppTheme.accentGold,
          foregroundColor: AppTheme.primaryDark,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableFundItem(
    BuildContext context,
    Fund fund,
    bool isSelected,
    PortfolioProvider provider,
  ) {
    final color = AppTheme.getCategoryColor(fund.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [
                  AppTheme.accentGold.withValues(alpha: 0.15),
                  AppTheme.accentGold.withValues(alpha: 0.05),
                ],
              )
            : LinearGradient(
                colors: [
                  AppTheme.surface.withValues(alpha: 0.5),
                  AppTheme.surface.withValues(alpha: 0.3),
                ],
              ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppTheme.accentGold : Colors.white.withValues(alpha: 0.08),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _toggleFundSelection(fund.id),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSelected
                        ? [AppTheme.accentGold, AppTheme.accentGold.withValues(alpha: 0.8)]
                        : [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppTheme.accentGold : color.withValues(alpha: 0.3),
                    width: isSelected ? 0 : 1,
                  ),
                ),
                child: Icon(
                  isSelected ? Icons.check_circle : _getCategoryIcon(fund.category),
                  color: isSelected ? AppTheme.primaryDark : color,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fund.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            fund.category.displayName,
                            style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          fund.code,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                Formatters.formatCurrency(fund.amount),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(PortfolioCategory category) {
    switch (category) {
      case PortfolioCategory.stock:
        return Icons.trending_up;
      case PortfolioCategory.bond:
        return Icons.account_balance;
      case PortfolioCategory.cash:
        return Icons.account_balance_wallet;
      case PortfolioCategory.gold:
        return Icons.grain;
    }
  }

  void _showAddFundDialog(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context, listen: false);
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
                          AppTheme.accentGold.withValues(alpha: 0.2),
                          AppTheme.accentGold.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add_circle, color: AppTheme.accentGold),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '添加基金',
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
                    onSaved: (fund) {
                      Navigator.of(context).pop();
                      provider.addFund(fund);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white),
                              const SizedBox(width: 10),
                              Text('已添加 ${fund.name}'),
                            ],
                          ),
                          backgroundColor: AppTheme.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
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

  void _showEditFundDialog(BuildContext context, Fund fund) {
    final provider = Provider.of<PortfolioProvider>(context, listen: false);
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
                      Navigator.of(context).pop();
                      provider.updateFund(updatedFund);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white),
                              const SizedBox(width: 10),
                              Text('已更新 ${updatedFund.name}'),
                            ],
                          ),
                          backgroundColor: AppTheme.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
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

  void _confirmDelete(BuildContext context, Fund fund, PortfolioProvider provider) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppTheme.cardBackground,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.cardBackground,
                AppTheme.cardBackgroundAlt,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.deleteColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.delete_forever, color: AppTheme.deleteColor, size: 36),
              ),
              const SizedBox(height: 20),
              const Text(
                '确认删除',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '确定要删除 ${fund.name} 吗？',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                Formatters.formatCurrency(fund.amount),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        '取消',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await provider.deleteFund(fund.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.white),
                                const SizedBox(width: 10),
                                Text('已删除 ${fund.name}'),
                              ],
                            ),
                            backgroundColor: AppTheme.success,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.deleteColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('删除'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
