import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/budget_provider.dart';
import '../widgets/expense_tile.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _incomeFormKey = GlobalKey<FormState>();
  final _expenseFormKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  static final _decimalOnly = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
  ];

  String? _amountValidator(String? v, String name) {
    if (v == null || v.trim().isEmpty) return 'Enter $name';
    final n = double.tryParse(v.trim());
    if (n == null) return 'Enter a valid number';
    if (n <= 0) return '$name must be greater than zero';
    return null;
  }

  void _saveIncome() {
    if (_incomeFormKey.currentState!.validate()) {
      context.read<BudgetProvider>().setIncome(
        double.parse(_incomeController.text.trim()),
      );
      FocusScope.of(context).unfocus();
    }
  }

  void _addExpense() {
    if (_expenseFormKey.currentState!.validate()) {
      context.read<BudgetProvider>().addExpense(
        _titleController.text.trim(),
        double.parse(_amountController.text.trim()),
      );
      _titleController.clear();
      _amountController.clear();
      _expenseFormKey.currentState!.reset();
    }
  }

  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset budget?'),
        content: const Text('This clears your income and all expenses.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      context.read<BudgetProvider>().reset();
      _incomeController.clear();
      _incomeFormKey.currentState?.reset();
    }
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final budget = context.watch<BudgetProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Budget Calculator'),
        actions: [
          IconButton(
            tooltip: 'Reset',
            icon: const Icon(Icons.restart_alt),
            onPressed: _confirmReset,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SummaryCard(budget: budget),
              const SizedBox(height: 16),
              Form(
                key: _incomeFormKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _incomeController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: _decimalOnly,
                        decoration: const InputDecoration(
                          labelText: 'Monthly income',
                          prefixText: '₹ ',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => _amountValidator(v, 'Income'),
                        onFieldSubmitted: (_) => _saveIncome(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: FilledButton(
                        onPressed: _saveIncome,
                        child: const Text('Set'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Add expense',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Form(
                key: _expenseFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Expense name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Enter expense name'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: _decimalOnly,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        prefixText: '₹ ',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => _amountValidator(v, 'Amount'),
                      onFieldSubmitted: (_) => _addExpense(),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        onPressed: _addExpense,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Expense'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Expenses (${budget.expenses.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (budget.expenses.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No expenses added yet.')),
                )
              else
                for (final e in budget.expenses)
                  ExpenseTile(
                    key: ValueKey(e.id),
                    expense: e,
                    onDelete: () =>
                        context.read<BudgetProvider>().removeExpense(e.id),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
