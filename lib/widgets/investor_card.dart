import 'package:flutter/material.dart';

class InvestorCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const InvestorCard({required this.name, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
