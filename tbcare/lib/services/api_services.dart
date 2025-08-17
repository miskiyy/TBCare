// lib/services/api_services.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// Ganti IP ini dengan IP lokal atau alamat server Flask Anda
const String _baseURL = 'http://127.0.0.1:5000/api';

class ApiService {
  // Metode untuk login dokter (tetap menggunakan simulasi untuk saat ini)
  Future<Map<String, dynamic>> login(String email, String password, String role) async {
    await Future.delayed(Duration(seconds: 2));
    if (email == 'dokter@example.com' && password == 'password') {
      return {'success': true, 'token': 'some_jwt_token', 'user': {'id': 1, 'nama': 'Dr. Budi', 'email': email}};
    } else {
      return {'success': false, 'message': 'Kredensial tidak valid'};
    }
  }

  // Metode untuk membuat pasien baru
  Future<Map<String, dynamic>> createPasien(Map<String, dynamic> pasienData) async {
    final response = await http.post(
      Uri.parse('$_baseURL/pasien'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pasienData),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal membuat pasien: ${response.body}');
    }
  }

  // Metode untuk membuat pemeriksaan baru
  Future<Map<String, dynamic>> createPemeriksaan(Map<String, dynamic> pemeriksaanData) async {
    final response = await http.post(
      Uri.parse('$_baseURL/pemeriksaan'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pemeriksaanData),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal membuat pemeriksaan: ${response.body}');
    }
  }

  // Metode untuk menyimpan metadata audio (URL dari Firebase)
  Future<Map<String, dynamic>> saveAudioMetadata(Map<String, dynamic> audioData) async {
    final response = await http.post(
      Uri.parse('$_baseURL/audio'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(audioData),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal menyimpan metadata audio: ${response.body}');
    }
  }

  // Metode untuk memanggil model AI di backend Flask
  Future<Map<String, dynamic>> getMlDiagnosis(String audioUrl) async {
    final response = await http.post(
      Uri.parse('$_baseURL/ml-diagnosis'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'audio_url': audioUrl}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mendapatkan diagnosis ML: ${response.body}');
    }
  }

  // Metode untuk mengambil daftar pemeriksaan
  Future<List<dynamic>> getPemeriksaanList() async {
    // TODO: Buat endpoint di Flask untuk ini
    final response = await http.get(Uri.parse('$_baseURL/pemeriksaan_list'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load pemeriksaan list: ${response.body}');
    }
  }

  // Metode untuk mengambil detail pemeriksaan spesifik
  Future<Map<String, dynamic>> getPemeriksaanDetail(int id) async {
    // TODO: Buat endpoint di Flask untuk ini
    final response = await http.get(Uri.parse('$_baseURL/pemeriksaan/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load pemeriksaan detail: ${response.body}');
    }
  }
  
}
