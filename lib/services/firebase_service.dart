import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchPortfolios(String uid) async {
    final snapshot = await _db.collection('portfolios').where('uid', isEqualTo: uid).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> fetchTransactions(String uid) async {
    final snapshot = await _db
        .collection('transactions')
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> addTransaction(Map<String, dynamic> data) async {
    await _db.collection('transactions').add(data);
  }

  Future<void> addPortfolio(Map<String, dynamic> data) async {
    await _db.collection('portfolios').add(data);
  }

  Future<void> updatePortfolio(String docId, Map<String, dynamic> data) async {
    await _db.collection('portfolios').doc(docId).update(data);
  }

  Future<void> deletePortfolio(String docId) async {
    await _db.collection('portfolios').doc(docId).delete();
  }
}