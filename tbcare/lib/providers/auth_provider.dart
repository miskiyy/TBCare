// lib/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _currentUser;
  String? _userRole; // 'dokter' atau 'pasien'

  User? get currentUser => _currentUser;
  String? get userRole => _userRole;

  bool get isLoggedIn => _currentUser != null;

  // Constructor untuk mendengarkan perubahan status autentikasi
  AuthProvider() {
    _auth.authStateChanges().listen((User? user) async {
      _currentUser = user;
      if (user != null) {
        // Ambil peran pengguna dari Firestore
        final docSnapshot = await _firestore.collection('users').doc(user.uid).get();
        if (docSnapshot.exists) {
          _userRole = docSnapshot.data()?['role'];
        }
      } else {
        _userRole = null;
      }
      notifyListeners();
    });
  }

  // Metode untuk login dengan email dan password
  Future<void> login(String email, String password, String role) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Simpan peran pengguna di Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role,
      });
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw Exception('Email atau password salah.');
      }
      rethrow;
    }
  }

  // Metode untuk registrasi (opsional, jika nakes bisa mendaftar)
  Future<void> register(String email, String password, String role) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Simpan peran pengguna di Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role,
      });
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Password terlalu lemah.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Akun sudah terdaftar untuk email tersebut.');
      }
      rethrow;
    }
  }

  // Metode untuk logout
  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}