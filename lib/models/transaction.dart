class Transaction {
  int id;
  String userId;
  final DateTime date;
  final double amount;
  final int totalProductsSoled;
  bool shouldAddTime;
  Transaction(
      {this.date,
      this.amount,
      this.userId,
      this.totalProductsSoled,
      this.shouldAddTime = true});

  Transaction.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        totalProductsSoled = data['totalProductsSoled'],
        userId = data['user_id'],
        date = DateTime.tryParse(data['date']),
        amount = data['amount'],
        shouldAddTime = true;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'totalProductsSoled': totalProductsSoled,
      'date': shouldAddTime
          ? date.toIso8601String()
          : date.toString().substring(0, 10),
      'amount': amount
    };
  }
}
