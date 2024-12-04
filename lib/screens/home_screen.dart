import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalExpenses = 0.0;
  double budget = 0.0;
  final TextEditingController _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBudget();
    _loadTotalExpenses();
  }

  void _loadBudget() async {
    var budgetBox = await Hive.openBox('budgetBox');
    setState(() {
      budget = budgetBox.get('budget', defaultValue: 0.0);
    });
  }

  // Save the budget in Hive
  void _saveBudget() async {
    var budgetBox = await Hive.openBox('budgetBox');
    await budgetBox.put('budget', double.tryParse(_budgetController.text) ?? 0.0);
    setState(() {
      budget = double.tryParse(_budgetController.text) ?? 0.0;
    });
  }


  void _loadTotalExpenses() async {
    var expenseBox = await Hive.openBox('expenses');
    double total = 0.0;
    totalExpenses = 0.0;

    for (var i = 0; i < expenseBox.length; i++) {
      final expense = expenseBox.getAt(i);
      total += expense['amount'];
    }

    setState(() {
      totalExpenses = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = budget == 0 ? 0 : totalExpenses / budget;

    return Scaffold(
      appBar: AppBar(title: const Text("Expense Tracker")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CircularPercentIndicator(
              radius: 150.0, // Size of the circle
              lineWidth: 20.0, // Width of the arc
              animation: true, // Enable animation for the progress bar
              animationDuration: 1000, // Duration of the animation in milliseconds
              percent: progress > 1 ? 1 : progress, // Ensure the value doesn't exceed 100%
              center: Text(
                "${(progress * 100).toStringAsFixed(0)}%", // Show percentage in the center
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Colors.grey.shade300,
              progressColor: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              "Total Expenses: \$${totalExpenses.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "Budget: \$${budget.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20),
            ),
            // Input for budget
            if (budget == 0.0) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Enter your budget",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _saveBudget,
                child: const Text("Save Budget"),
              ),
            ],

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddExpenseScreen()),
                );
              },
              child: const Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
