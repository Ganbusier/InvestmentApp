import 'package:flutter/material.dart';
import 'package:investment_app/theme/app_theme.dart';

class WarningBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onAction;

  const WarningBanner({
    super.key,
    required this.message,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.warning.withValues(alpha: 0.15),
            AppTheme.warning.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: AppTheme.warning.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.warning.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.warning_amber_rounded, color: AppTheme.warning, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppTheme.warning,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
           ),
          if (onAction != null)
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(10),
              splashColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.warning.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Text(
                  '查看详情',
                  style: TextStyle(
                    color: AppTheme.warning,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
