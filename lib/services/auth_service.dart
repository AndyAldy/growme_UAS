import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // sukses
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Simpan data tambahan di Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'email': email, 'fullName': fullName, 'createdAt': DateTime.now()});

      return null; // sukses
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    if (currentUser == null) return null;
    final doc =
        await _firestore.collection('users').doc(currentUser!.uid).get();
    return doc.data();
  }
}
