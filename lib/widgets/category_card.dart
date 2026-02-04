import 'package:flutter/material.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/theme/app_theme.dart';
import 'package:investment_app/utils/formatters.dart';

class CategoryCard extends StatefulWidget {
  final PortfolioCategory category;
  final double currentAmount;
  final double targetAmount;
  final double currentPercentage;
  final double targetPercentage;
  final List<Fund> funds;
  final Function(Fund fund)? onDeleteFund;
  final Function(Fund fund)? onFundTap;
  final Function(PortfolioCategory category)? onAddFund;

  const CategoryCard({
    super.key,
    required this.category,
    required this.currentAmount,
    required this.targetAmount,
    required this.currentPercentage,
    required this.targetPercentage,
    required this.funds,
    this.onDeleteFund,
    this.onFundTap,
    this.onAddFund,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _confirmDelete(BuildContext context, Fund fund) {
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
            border: Border.all(
              color: AppTheme.deleteColor.withValues(alpha: 0.3),
              width: 1,
            ),
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
                child: const Icon(Icons.delete_forever, color: AppTheme.deleteColor, size: 40),
              ),
              const SizedBox(height: 20),
              const Text(
                '确认删除',
                style: TextStyle(
                  fontSize: 20,
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
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onDeleteFund?.call(fund);
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
    final color = AppTheme.getCategoryColor(widget.category);
    final deviation = widget.currentPercentage - widget.targetPercentage;
    final deviationText = deviation == 0
        ? '平衡'
        : deviation >= 0
            ? '+${(deviation * 100).toStringAsFixed(1)}%'
            : '${(deviation * 100).toStringAsFixed(1)}%';
    final deviationColor = deviation > 0 ? AppTheme.error : deviation < 0 ? color.withValues(alpha: 0.8) : AppTheme.success;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppTheme.getCardDecoration(),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpanded,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color.withValues(alpha: 0.3),
                                color.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: color.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            _getCategoryIcon(widget.category),
                            color: color,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.category.displayName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
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
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '目标: ${Formatters.formatPercent(widget.targetPercentage)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color.withValues(alpha: 0.2),
                                color.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: color.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            Formatters.formatPercent(widget.currentPercentage),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (widget.onAddFund != null)
                          InkWell(
                            onTap: () => widget.onAddFund!(widget.category),
                            borderRadius: BorderRadius.circular(10),
                            splashColor: Colors.transparent,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppTheme.accentGold.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppTheme.accentGold.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: AppTheme.accentGold,
                                size: 20,
                              ),
                            ),
                          ),
                        const SizedBox(width: 4),
                        RotationTransition(
                          turns: _rotateAnimation,
                          child: const Icon(
                            Icons.expand_more,
                            color: AppTheme.accentGold,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        Container(
                          height: 12,
                          width: (MediaQuery.of(context).size.width * widget.currentPercentage.clamp(0.0, 1.0) - 80).clamp(0.0, double.infinity),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color,
                                color.withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem('当前金额', Formatters.formatCurrency(widget.currentAmount)),
                        _buildInfoItem('目标金额', Formatters.formatCurrency(widget.targetAmount)),
                        _buildInfoItem('偏离', deviationText, textColor: deviationColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isExpanded)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                children: widget.funds.map((fund) => _buildFundItem(context, fund)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {Color? textColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: textColor ?? Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFundItem(BuildContext context, Fund fund) {
    final color = AppTheme.getCategoryColor(widget.category);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onFundTap?.call(fund),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.surface.withValues(alpha: 0.5),
                AppTheme.surface.withValues(alpha: 0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          child: Row(
        children: [
          Container(
            width: 6,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.6)],
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 14),
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
                ),
                Text(
                  fund.code,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Text(
            Formatters.formatCurrency(fund.amount),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
           const SizedBox(width: 12),
            InkWell(
            onTap: () => _confirmDelete(context, fund),
            borderRadius: BorderRadius.circular(10),
            splashColor: Colors.transparent,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.deleteColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppTheme.deleteColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: const Icon(
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
}
