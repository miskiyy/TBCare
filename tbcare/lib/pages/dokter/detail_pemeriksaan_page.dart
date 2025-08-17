// lib/pages/dokter/detail_pemeriksaan_page.dart

import 'package:flutter/material.dart';

class DetailPemeriksaanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Pastikan argumen tidak null
    final Map<String, dynamic>? data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (data == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Pemeriksaan')),
        body: const Center(child: Text('Data tidak ditemukan.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pemeriksaan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama Pasien: ${data['nama']}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Tanggal: ${data['tanggal']}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('Diagnosis: ${data['diagnosis']}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            // TODO: Tambahkan widget untuk menampilkan visualisasi audio seperti spektogram
            Container(
              height: 200,
              color: Colors.grey[300],
              child: const Center(child: Text('Placeholder untuk Spektogram')),
            ),
            const SizedBox(height: 24),
            Text('Catatan Dokter', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            // TODO: Tampilkan catatan riwayat penyakit dan diagnosis dokter
            Text('Ini adalah catatan dari dokter.', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}