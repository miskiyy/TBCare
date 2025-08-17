// lib/pages/pasien/pasien_dashboard.dart

import 'package:flutter/material.dart';

class PasienDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Pasien'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Tambahkan logika logout di sini
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Selamat datang, Pasien!'),
      ),
    );
  }
}
