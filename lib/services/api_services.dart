// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../models/user.dart';

// Ganti IP ini dengan IP lokal Anda saat testing
const String _localHostIP = '192.168.1.10'; 
const String _localHostPort = '5000';
const String _baseURL = 'http://$_localHostIP:$_localHostPort/api';

class ApiService {
  Future<Map<String, dynamic>> login(String email, String password, String role) async {
    // Placeholder untuk logika HTTP POST ke API Flask
    // final response = await http.post(
    //   Uri.parse('$_baseURL/login'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({'email': email, 'password': password, 'role': role}),
    // );
    // return jsonDecode(response.body);

    // Simulasi respons API
    await Future.delayed(Duration(seconds: 2));
    if (email == 'dokter@example.com' && password == 'password') {
      return {'success': true, 'token': 'some_jwt_token', 'user': {'id': 1, 'nama': 'Dr. Budi', 'email': email}};
    } else {
      return {'success': false, 'message': 'Kredensial tidak valid'};
    }
  }
  
  // Placeholder untuk method API lainnya
  // Future<Map<String, dynamic>> getPasienData(String token) async { ... }
}
