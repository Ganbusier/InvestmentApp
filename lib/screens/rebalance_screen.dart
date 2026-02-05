import 'package:flutter/material.dart';
import 'package:permanent_portfolio/models/fund.dart';
import 'package:permanent_portfolio/providers/portfolio_provider.dart';
import 'package:permanent_portfolio/theme/app_theme.dart';
import 'package:permanent_portfolio/utils/formatters.dart';
import 'package:permanent_portfolio/widgets/cannot_rebalance_card.dart';
import 'package:provider/provider.dart';

class RebalanceScreen extends StatefulWidget {
  const RebalanceScreen({super.key});

  @override
  State<RebalanceScreen> createState() => _RebalanceScreenState();
}

class _RebalanceScreenState extends State<RebalanceScreen> {
  bool _showPreview = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentGold,
                    AppTheme.accentGold.withValues(alpha: 0.8)
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.swap_horiz,
                  color: AppTheme.primaryDark, size: 20),
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
      body: Consumer<PortfolioProvider>(
        builder: (context, provider, child) {
          final needsRebalancing = provider.needsRebalancing;
          final canUndo = provider.canUndoRebalance;

          if (_showPreview) {
            return _buildPreviewPage(provider, context);
          }

          if (canUndo) {
            return _buildUndoPage(provider, context);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(needsRebalancing, provider, context),
                const SizedBox(height: 20),
                _buildCurrentAllocation(context, provider),
                const SizedBox(height: 20),
                _buildActionsCard(provider.getRebalanceActions()),
                const SizedBox(height: 20),
                _buildThresholdSettingCard(provider),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

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
            const Icon(Icons.tune, color: AppTheme.accentGold),
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
            Icon(Icons.chevron_right,
                color: Colors.white.withValues(alpha: 0.4)),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewPage(PortfolioProvider provider, BuildContext context) {
    final preview = provider.previewRebalance();
    final meaningfulChanges = preview.meaningfulChanges;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _showPreview = false;
                  });
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Text(
                '再平衡预览',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPreviewSummary(preview),
          const SizedBox(height: 20),
          _buildFundChangesList(meaningfulChanges),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _showPreview = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side:
                        BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    '取消',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => _showConfirmDialog(context, provider),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.swap_horiz, color: AppTheme.primaryDark),
                        SizedBox(width: 10),
                        Text(
                          '确认执行',
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
              ),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildUndoPage(PortfolioProvider provider, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.success.withValues(alpha: 0.15),
                  AppTheme.success.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.success.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppTheme.success,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '再平衡已完成',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.success,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '您的投资组合已按目标比例进行调整',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.6),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          '返回首页',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _showUndoConfirmDialog(context, provider),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.error.withValues(alpha: 0.8),
                                AppTheme.error,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.undo, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                '撤销',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildCurrentAllocation(context, provider),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildPreviewSummary(RebalancePreview preview) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentGold.withValues(alpha: 0.15),
            AppTheme.accentGold.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accentGold.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.preview, color: AppTheme.accentGold),
              ),
              const SizedBox(width: 12),
              const Text(
                '执行后变化',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    Formatters.formatCurrency(preview.totalBuy),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.success,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '总买入',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              Column(
                children: [
                  Text(
                    Formatters.formatCurrency(preview.totalSell),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '总卖出',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFundChangesList(List<FundChange> changes) {
    if (changes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          children: [
            Icon(Icons.check_circle, color: AppTheme.success, size: 48),
            SizedBox(height: 12),
            Text(
              '投资组合已接近目标配置',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.success,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: AppTheme.getCardDecoration(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '基金调整明细',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...changes.map((change) {
            final isBuy = change.isBuy;
            final color = isBuy ? AppTheme.success : AppTheme.error;
            final changeText = isBuy
                ? '+${Formatters.formatCurrency(change.change)}'
                : Formatters.formatCurrency(change.change);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.1),
                    color.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isBuy ? Icons.arrow_upward : Icons.arrow_downward,
                      color: color,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          change.fundName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${Formatters.formatCurrency(change.currentAmount)} → ${Formatters.formatCurrency(change.targetAmount)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    changeText,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, PortfolioProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.warning.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.warning_amber, color: AppTheme.warning),
            ),
            const SizedBox(width: 12),
            const Text(
              '确认执行再平衡',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              '执行后将对以下基金进行调整：',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ...provider
                .previewRebalance()
                .meaningfulChanges
                .take(4)
                .map((change) {
              final isBuy = change.isBuy;
              final color = isBuy ? AppTheme.success : AppTheme.error;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        change.fundName,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    Text(
                      '${isBuy ? '+' : ''}${Formatters.formatCurrency(change.change)}',
                      style:
                          TextStyle(color: color, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }),
            if (provider.previewRebalance().meaningfulChanges.length > 4) ...[
              Text(
                '...及其他 ${provider.previewRebalance().meaningfulChanges.length - 4} 只基金',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: Colors.white54, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '执行后可以随时撤销此操作',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.executeRebalance();
              if (success && mounted) {
                setState(() {
                  _showPreview = false;
                });
                _showSuccessSnackBar(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentGold,
              foregroundColor: AppTheme.primaryDark,
            ),
            child: const Text('确认执行'),
          ),
        ],
      ),
    );
  }

  void _showUndoConfirmDialog(
      BuildContext context, PortfolioProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.undo, color: AppTheme.error),
            ),
            const SizedBox(width: 12),
            const Text(
              '确认撤销',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              '撤销后，投资组合将恢复到再平衡之前的状态。',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, color: AppTheme.warning, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '此操作只能执行一次，请确认是否继续',
                      style: TextStyle(
                        color: AppTheme.warning,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.undoRebalance();
              if (success && mounted) {
                _showUndoSuccessSnackBar(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('确认撤销'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text('再平衡执行成功'),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showUndoSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.undo, color: Colors.white),
            SizedBox(width: 10),
            Text('已撤销到再平衡前的状态'),
          ],
        ),
        backgroundColor: AppTheme.warning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildStatusCard(
      bool needsRebalancing, PortfolioProvider provider, BuildContext context) {
    final statusColor = needsRebalancing ? AppTheme.warning : AppTheme.success;
    final checkResult = provider.checkCanRebalance();
    final canRebalance = checkResult?.canExecute ?? true;

    if (needsRebalancing && !canRebalance) {
      return CannotRebalanceCard(
        checkResult: checkResult!,
        provider: provider,
        onBack: () => provider.selectTab(0),
        onAddFund: null,
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withValues(alpha: 0.15),
            statusColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              needsRebalancing ? Icons.warning_amber : Icons.check_circle,
              color: statusColor,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            needsRebalancing ? '需要再平衡' : '投资组合已平衡',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            needsRebalancing
                ? '当前投资比例偏离目标配置，建议进行调整以恢复平衡'
                : '各类别比例在目标范围内，投资组合保持健康',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (needsRebalancing) ...[
            const SizedBox(height: 24),
            InkWell(
              onTap: () {
                setState(() {
                  _showPreview = true;
                });
              },
              borderRadius: BorderRadius.circular(14),
              splashColor: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.preview, color: AppTheme.primaryDark),
                    SizedBox(width: 10),
                    Text(
                      '预览再平衡',
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
        ],
      ),
    );
  }

  Widget _buildCurrentAllocation(
      BuildContext context, PortfolioProvider provider) {
    final percentages = provider.categoryPercentages;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: AppTheme.getCardDecoration(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                child: const Icon(Icons.pie_chart,
                    color: AppTheme.accentGold, size: 22),
              ),
              const SizedBox(width: 12),
              const Text(
                '当前配置',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...PortfolioCategory.values.map((category) {
            final percentage = percentages[category] ?? 0;
            final color = AppTheme.getCategoryColor(category);
            final deviation = percentage - 0.25;
            final deviationColor = deviation > 0
                ? AppTheme.error
                : deviation < 0
                    ? color
                    : AppTheme.success;
            final deviationText = deviation == 0
                ? '平衡'
                : deviation >= 0
                    ? '+${(deviation * 100).toStringAsFixed(1)}%'
                    : '${(deviation * 100).toStringAsFixed(1)}%';

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        category.displayName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          Formatters.formatPercent(percentage),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        deviationText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: deviationColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Container(
                        height: 10,
                        width: (screenWidth - 88).clamp(0, double.infinity) *
                            percentage.clamp(0.0, 1.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withValues(alpha: 0.7)],
                          ),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionsCard(List<dynamic> actions) {
    return Container(
      decoration: AppTheme.getCardDecoration(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.success.withValues(alpha: 0.2),
                      AppTheme.success.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.lightbulb_outline,
                    color: AppTheme.success, size: 22),
              ),
              const SizedBox(width: 12),
              const Text(
                '操作建议',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (actions.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.success.withValues(alpha: 0.1),
                    AppTheme.success.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.success.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle,
                      color: AppTheme.success, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    '无需进行再平衡操作',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.success,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '您的投资组合已接近目标配置',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            )
          else
            ...actions.map((action) {
              final rebalanceAction = action as dynamic;
              final isBuy = rebalanceAction.isBuy;
              final actionColor = isBuy ? AppTheme.success : AppTheme.error;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      actionColor.withValues(alpha: 0.1),
                      actionColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: actionColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: actionColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isBuy ? Icons.add_circle : Icons.remove_circle,
                        color: actionColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rebalanceAction.description,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isBuy ? '建议买入以恢复平衡' : '建议卖出以恢复平衡',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: actionColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isBuy ? '买入' : '卖出',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: actionColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  void _showThresholdBottomSheet(
      BuildContext context, PortfolioProvider provider) {
    final controller = TextEditingController(
      text: (provider.rebalanceThreshold * 100).toStringAsFixed(2),
    );
    final focusNode = FocusNode();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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

    Future.delayed(const Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
  }
}

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
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            '当某个类别偏离目标超过此阈值时，系统将建议进行再平衡操作',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white, fontSize: 24),
            decoration: InputDecoration(
              suffix: const Text('%',
                  style: TextStyle(color: Colors.white70, fontSize: 18)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _errorText != null
                      ? AppTheme.error
                      : Colors.white.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color:
                      _errorText != null ? AppTheme.error : AppTheme.accentGold,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onChanged: _validateInput,
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.error_outline,
                    color: AppTheme.error, size: 16),
                const SizedBox(width: 6),
                Text(
                  _errorText!,
                  style: const TextStyle(color: AppTheme.error, fontSize: 13),
                ),
              ],
            ),
          ],
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isValid
                  ? () => widget.onConfirm(double.parse(widget.controller.text))
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: _isValid
                    ? AppTheme.accentGold
                    : Colors.white.withValues(alpha: 0.1),
                foregroundColor: _isValid
                    ? AppTheme.primaryDark
                    : Colors.white.withValues(alpha: 0.3),
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
