// lib/pages/index_page.dart

import 'package:flutter/material.dart';

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MedSense'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selamat Datang di MedSense',
              style: Theme.of(context).textTheme.headlineSmall, // Perbaikan TextTheme
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/login-dokter');
              },
              icon: const Icon(Icons.medical_services, size: 24),
              label: const Text('Login sebagai Dokter'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/login-user');
              },
              icon: const Icon(Icons.person, size: 24),
              label: const Text('Login sebagai Pasien'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
