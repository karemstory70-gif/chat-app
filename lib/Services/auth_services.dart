import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? get currentUser => _auth.currentUser;

  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
      await _firestore.collection('users').doc(cred.user!.uid).set({
      'name' : name,
      'email': email,
      'uid': cred.user!.uid,
      'image': '',
      'status': true,
      'lastSeen': Timestamp.now(),
    });
    await cred.user!.updateDisplayName(name.trim());
    await cred.user!.reload();
    return cred.user;
  }
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestore.collection('users').doc(cred.user!.uid).update({
      'status': true,
      'lastSeen': Timestamp.now(),
    });
    return cred.user;
  }

  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return 'تم إرسال لينك إعادة تعيين الباسورد';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'حدث خطا اثناء الارسال';
    }
  }

  Future<void> signOut() async {
    await _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .update({
    'status': false,
    'lastSeen': Timestamp.now(),
    });
    await _auth.signOut();
  }
}

