import 'package:flutter/material.dart';
import 'package:permanent_portfolio/services/rebalance_calculator.dart';

class RebalanceActionsWidget extends StatelessWidget {
  final List<RebalanceAction> actions;

  const RebalanceActionsWidget({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 64),
            SizedBox(height: 16),
            Text(
              '投资组合已平衡',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '无需进行再平衡操作',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '再平衡操作建议',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...actions.map((action) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: Icon(
              action.isBuy ? Icons.add_circle : Icons.remove_circle,
              color: action.isBuy ? Colors.green : Colors.red,
            ),
            title: Text(action.description),
            subtitle: Text(
              action.isBuy ? '建议买入以恢复平衡' : '建议卖出以恢复平衡',
            ),
          ),
        )),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('执行再平衡'),
          ),
        ),
      ],
    );
  }
}
