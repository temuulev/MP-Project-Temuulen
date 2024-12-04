import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'screens/add_expense_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('expenses');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalExpenses = 0.0;
  double budget = 1000.0;

  @override
  void initState() {
    super.initState();
    _loadTotalExpenses();
  }

  void _loadTotalExpenses() async {
    var expenseBox = await Hive.openBox('expenses');
    double total = 0.0;
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
    double progress = totalExpenses / budget;

    return Scaffold(
      appBar: AppBar(title: const Text("Expense Tracker")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CircularPercentIndicator widget to display the arc progress
            CircularPercentIndicator(
              radius: 150.0, // Size of the circle
              lineWidth: 20.0, // Width of the arc
              animation: true, // Enable animation for the progress bar
              animationDuration: 1000, // Duration of the animation in milliseconds
              percent: progress > 1 ? 1 : progress,  // Ensure the value doesn't exceed 100%
              center: Text(
                "${(progress * 100).toStringAsFixed(0)}%",  // Show percentage in the center
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              circularStrokeCap: CircularStrokeCap.round,  // Smooth rounded ends for the arc
              backgroundColor: Colors.grey.shade300,  // Background color of the circle
              progressColor: Colors.blue,  // Color of the arc progress
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
