import 'package:hive/hive.dart';
import '../models/expense.dart';

class ExpenseService {
  static const String _expensesBoxName = 'expenses';
  static const String _totalExpenseBoxName = 'totalExpense';

  Future<void> addExpense(Expense expense) async {
    var box = await Hive.openBox(_expensesBoxName);
    var totalExpenseBox = await Hive.openBox(_totalExpenseBoxName);

    await box.add(expense.toMap());

    double currentTotal = totalExpenseBox.get('totalAmount', defaultValue: 0.0);
    await totalExpenseBox.put('totalAmount', currentTotal + expense.amount);
  }

  Future<double> loadTotalExpenses() async {
    var totalExpenseBox = await Hive.openBox(_totalExpenseBoxName);
    return totalExpenseBox.get('totalAmount', defaultValue: 0.0);
  }

  Future<List<Expense>> loadAllExpenses() async {
    var box = await Hive.openBox(_expensesBoxName);
    return box.values.map((e) => Expense.fromMap(Map<String, dynamic>.from(e))).toList();
  }
}
