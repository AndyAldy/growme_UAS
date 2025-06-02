class TransactionModel {
  final String id;
  final String type; // pembelian, penjualan, pengalihan
  final String investment;
  final int amount;
  final DateTime timestamp;
  final int? profit;
  final String? destinationBranch;
  final int? fee;

  TransactionModel({
    required this.id,
    required this.type,
    required this.investment,
    required this.amount,
    required this.timestamp,
    this.profit,
    this.destinationBranch,
    this.fee,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return TransactionModel(
      id: id,
      type: map['type'],
      investment: map['investment'],
      amount: map['amount'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      profit: map['profit'],
      destinationBranch: map['destination_branch'],
      fee: map['fee'],
    );
  }
}
