import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/auth_service.dart';

class ReksadanaScreen extends StatefulWidget {
  const ReksadanaScreen({super.key});

  @override
  State<ReksadanaScreen> createState() => _ReksadanaScreenState();
}

class _ReksadanaScreenState extends State<ReksadanaScreen> {
  final _firebaseService = FirebaseService();
  final _authService = AuthService();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _targetFundController = TextEditingController();
  String selectedFund = 'Reksa Dana A';
  final List<String> funds = ['Reksa Dana A', 'Reksa Dana B', 'Reksa Dana C'];
  double pricePerUnit = 10000;

  void _buy() async {
    final uid = _authService.currentUser?.uid;
    final unit = double.tryParse(_unitController.text);
    if (uid == null || unit == null || unit <= 0) return;

    final total = unit * pricePerUnit;
    final portfolio = await _firebaseService.fetchPortfolios(uid);
    final existing = portfolio.firstWhere(
      (e) => e['fund_name'] == selectedFund,
      orElse: () => {},
    );

    if (existing.isNotEmpty) {
      final updatedUnit = existing['unit'] + unit;
      final docId = existing['id'];
      await _firebaseService.updatePortfolio(docId, {'unit': updatedUnit});
    } else {
      await _firebaseService.addPortfolio({
        'uid': uid,
        'fund_name': selectedFund,
        'unit': unit,
        'price': pricePerUnit,
      });
    }

    await _firebaseService.addTransaction({
      'uid': uid,
      'type': 'buy',
      'fund_name': selectedFund,
      'unit': unit,
      'price': pricePerUnit,
      'total': total,
      'fee': 0,
      'timestamp': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pembelian berhasil!')),
    );
  }

  void _sell() async {
    final uid = _authService.currentUser?.uid;
    final unit = double.tryParse(_unitController.text);
    if (uid == null || unit == null || unit <= 0) return;

    final portfolio = await _firebaseService.fetchPortfolios(uid);
    final existing = portfolio.firstWhere(
      (e) => e['fund_name'] == selectedFund,
      orElse: () => {},
    );

    if (existing.isEmpty || existing['unit'] < unit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unit tidak mencukupi')), 
      );
      return;
    }

    final newUnit = existing['unit'] - unit;
    await _firebaseService.updatePortfolio(existing['id'], {'unit': newUnit});

    await _firebaseService.addTransaction({
      'uid': uid,
      'type': 'sell',
      'fund_name': selectedFund,
      'unit': unit,
      'price': pricePerUnit,
      'total': unit * pricePerUnit,
      'fee': 0,
      'timestamp': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Penjualan berhasil!')),
    );
  }

  void _switch() async {
    final uid = _authService.currentUser?.uid;
    final unit = double.tryParse(_unitController.text);
    final targetFund = _targetFundController.text;
    if (uid == null || unit == null || unit <= 0 || targetFund.isEmpty) return;
    if (targetFund == selectedFund) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih fund yang berbeda')), 
      );
      return;
    }

    final fee = 2000;
    final total = (unit * pricePerUnit) - fee;
    final portfolio = await _firebaseService.fetchPortfolios(uid);

    final from = portfolio.firstWhere(
      (e) => e['fund_name'] == selectedFund,
      orElse: () => {},
    );
    if (from.isEmpty || from['unit'] < unit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unit tidak mencukupi')), 
      );
      return;
    }

    final to = portfolio.firstWhere(
      (e) => e['fund_name'] == targetFund,
      orElse: () => {},
    );

    await _firebaseService.updatePortfolio(from['id'], {
      'unit': from['unit'] - unit,
    });

    if (to.isNotEmpty) {
      await _firebaseService.updatePortfolio(to['id'], {
        'unit': to['unit'] + unit,
      });
    } else {
      await _firebaseService.addPortfolio({
        'uid': uid,
        'fund_name': targetFund,
        'unit': unit,
        'price': pricePerUnit,
      });
    }

    await _firebaseService.addTransaction({
      'uid': uid,
      'type': 'switch',
      'fund_name': selectedFund,
      'unit': unit,
      'price': pricePerUnit,
      'total': total,
      'fee': fee,
      'timestamp': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengalihan berhasil!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reksa Dana')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedFund,
              onChanged: (val) => setState(() => selectedFund = val!),
              items: funds.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
            ),
            TextField(
              controller: _unitController,
              decoration: const InputDecoration(labelText: 'Jumlah Unit'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(onPressed: _buy, child: const Text('Beli')),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _sell, child: const Text('Jual')),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text('Alihkan ke Fund Lain:'),
            TextField(
              controller: _targetFundController,
              decoration: const InputDecoration(labelText: 'Fund Tujuan'),
            ),
            ElevatedButton(onPressed: _switch, child: const Text('Alihkan')),
          ],
        ),
      ),
    );
  }
}