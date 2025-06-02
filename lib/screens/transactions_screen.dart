import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../services/auth_service.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() async {
    final uid = AuthService().currentUser?.uid;
    if (uid != null) {
      final data = await _firebaseService.fetchTransactions(uid);
      setState(() {
        transactions = data;
      });
    }
  }

  String _capitalize(String text) => text[0].toUpperCase() + text.substring(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: transactions.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final date = (tx['timestamp'] as Timestamp).toDate();
              final type = _capitalize(tx['type']);
              return ListTile(
                title: Text('$type - ${tx['fund_name']}'),
                subtitle: Text('Unit: ${tx['unit']} | Total: Rp${tx['total']}'),
                trailing: Text('${date.day}/${date.month}/${date.year}'),
              );
            },
          ),
    );
  }
}