import 'package:flutter/foundation.dart';

import '../models/expense.dart';

enum BudgetStatus { noIncome, healthy, tight, overspent }

/// Holds income and expenses; every change notifies listeners so the UI rebuilds.
class BudgetProvider extends ChangeNotifier {
  double _income = 0;
  final List<Expense> _expenses = [];
  int _nextId = 1;

  double get income => _income;
  List<Expense> get expenses => List.unmodifiable(_expenses);
  double get totalExpenses => _expenses.fold(0.0, (sum, e) => sum + e.amount);
  double get balance => _income - totalExpenses;

  /// Fraction of income that has been spent (0 when no income is set).
  double get spentRatio => _income <= 0 ? 0 : totalExpenses / _income;

  BudgetStatus get status {
    if (_income <= 0) return BudgetStatus.noIncome;
    if (balance < 0) return BudgetStatus.overspent;
    if (spentRatio >= 0.8) return BudgetStatus.tight;
    return BudgetStatus.healthy;
  }

  void setIncome(double value) {
    _income = value;
    notifyListeners();
  }

  void addExpense(String title, double amount) {
    _expenses.add(Expense(id: _nextId++, title: title, amount: amount));
    notifyListeners();
  }

  void removeExpense(int id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void reset() {
    _income = 0;
    _expenses.clear();
    notifyListeners();
  }
}
