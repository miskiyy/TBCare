// import 'package:flutter/material.dart';

class DokterDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Dokter'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Tambahkan logika logout di sini
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Selamat datang, Dokter!'),
      ),
    );
  }
}
