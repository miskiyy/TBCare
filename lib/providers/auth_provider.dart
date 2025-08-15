// import 'package:flutter/foundation.dart';
// import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userRole; // 'dokter' atau 'pasien'
  // User? _currentUser; // Placeholder untuk data user

  bool get isLoggedIn => _isLoggedIn;
  String? get userRole => _userRole;
  // User? get currentUser => _currentUser;

  void login(String role) {
    _isLoggedIn = true;
    _userRole = role;
    // _currentUser = userData; // Simpan data user setelah login
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userRole = null;
    // _currentUser = null;
    notifyListeners();
  }
}