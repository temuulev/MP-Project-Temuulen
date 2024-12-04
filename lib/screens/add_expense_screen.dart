import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddExpenseScreen extends StatelessWidget {
  AddExpenseScreen({super.key});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final expenseBox = await Hive.openBox('expenses');
                final title = _titleController.text;
                final amount = double.tryParse(_amountController.text);

                if (title.isNotEmpty && amount != null) {
                  // Log the data being added to Hive
                  print("Adding Expense: Title: $title, Amount: $amount");

                  // Add the expense to Hive
                  await expenseBox.add({
                    'title': title,
                    'amount': amount,
                  });
                  Navigator.pop(context); // Go back to the HomeScreen
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter valid data")),
                  );
                }
              },
              child: const Text("Add Expense"),
            )

          ],
        ),
      ),
    );
  }
}
