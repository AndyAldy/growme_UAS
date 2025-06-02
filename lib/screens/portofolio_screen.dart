import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/auth_service.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _portfolios = [];

  @override
  void initState() {
    super.initState();
    _loadPortfolios();
  }

  void _loadPortfolios() async {
    final uid = AuthService().currentUser?.uid;
    if (uid != null) {
      final data = await _firebaseService.fetchPortfolios(uid);
      setState(() {
        _portfolios = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Portofolio')), 
      body: _portfolios.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _portfolios.length,
            itemBuilder: (context, index) {
              final item = _portfolios[index];
              final unit = item['unit'] ?? 0;
              final price = item['price'] ?? 0;
              final total = unit * price;
              return ListTile(
                title: Text(item['fund_name']),
                subtitle: Text('Unit: $unit | Harga/unit: Rp$price'),
                trailing: Text('Total: Rp$total'),
              );
            },
          ),
    );
  }
}
