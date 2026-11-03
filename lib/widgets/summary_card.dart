import 'package:flutter/material.dart';

import '../providers/budget_provider.dart';

/// Dashboard card showing income, expenses, balance and status.
class SummaryCard extends StatelessWidget {
  final BudgetProvider budget;

  const SummaryCard({super.key, required this.budget});

  (String, Color, IconData) get _statusInfo {
    switch (budget.status) {
      case BudgetStatus.noIncome:
        return ('Enter your income to begin', Colors.grey, Icons.info_outline);
      case BudgetStatus.healthy:
        return (
          'Healthy – you are within budget',
          Colors.green,
          Icons.check_circle,
        );
      case BudgetStatus.tight:
        return (
          'Careful – 80%+ of income spent',
          Colors.orange,
          Icons.warning_amber,
        );
      case BudgetStatus.overspent:
        return ('Overspent – expenses exceed income', Colors.red, Icons.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = _statusInfo;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _Stat(
                  title: 'Income',
                  value: budget.income,
                  color: Colors.green.shade700,
                ),
                _Stat(
                  title: 'Expenses',
                  value: budget.totalExpenses,
                  color: Colors.red.shade700,
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              'Remaining Balance',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              '₹${budget.balance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: budget.balance < 0 ? Colors.red : null,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: budget.spentRatio.clamp(0.0, 1.0),
                minHeight: 10,
                color: color,
                backgroundColor: color.withValues(alpha: 0.15),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(color: color, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String title;
  final double value;
  final Color color;

  const _Stat({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(title),
          Text(
            '₹${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
