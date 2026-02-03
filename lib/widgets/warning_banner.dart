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
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.warning.withOpacity(0.1),
        border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppTheme.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppTheme.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onAction != null)
            TextButton(
              onPressed: onAction,
              child: const Text(
                '查看详情',
                style: TextStyle(color: AppTheme.warning),
              ),
            ),
        ],
      ),
    );
  }
}
