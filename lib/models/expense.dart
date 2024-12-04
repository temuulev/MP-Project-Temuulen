class Expense {
  final String title;
  final double amount;

  Expense({required this.title, required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      title: map['title'],
      amount: map['amount'],
    );
  }
}