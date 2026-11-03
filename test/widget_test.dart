import 'package:flutter_test/flutter_test.dart';

import 'package:exp5_budget_calculator/providers/budget_provider.dart';

void main() {
  test('budget provider calculates balance and status', () {
    final b = BudgetProvider();
    expect(b.status, BudgetStatus.noIncome);

    b.setIncome(1000);
    b.addExpense('Rent', 500);
    expect(b.balance, 500);
    expect(b.status, BudgetStatus.healthy);

    b.addExpense('Food', 350);
    expect(b.status, BudgetStatus.tight);

    b.addExpense('Fun', 300);
    expect(b.balance, -150);
    expect(b.status, BudgetStatus.overspent);

    b.removeExpense(b.expenses.first.id);
    expect(b.totalExpenses, 650);

    b.reset();
    expect(b.income, 0);
    expect(b.expenses, isEmpty);
  });
}
