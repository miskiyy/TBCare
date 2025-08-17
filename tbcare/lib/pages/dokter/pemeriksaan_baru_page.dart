// lib/pages/dokter/pemeriksaan_baru_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../providers/firebase_provider.dart';

class PemeriksaanBaruPage extends StatefulWidget {
  @override
  _PemeriksaanBaruPageState createState() => _PemeriksaanBaruPageState();
}

class _PemeriksaanBaruPageState extends State<PemeriksaanBaruPage> {
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  
  File? _audioFile;
  String? _audioDiagnosis;
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    super.dispose();
  }

  // Metode untuk memilih file audio dari perangkat
  Future<void> _pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _audioFile = File(result.files.single.path!);
      });
      // TODO: Di sini nanti kamu bisa langsung panggil model AI
      // Untuk sementara, kita hanya tampilkan nama filenya
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File dipilih: ${result.files.single.name}')),
      );
    }
  }

  // Metode untuk mengunggah file audio yang sudah dipilih
  Future<void> _uploadAudioToFirebase(String pemeriksaanId) async {
    if (_audioFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih file audio terlebih dahulu')),
      );
      return;
    }

    setState(() { _isLoading = true; });

    try {
      final firebaseProvider = Provider.of<FirebaseProvider>(context, listen: false);
      final audioUrl = await firebaseProvider.uploadAudio(_audioFile!, pemeriksaanId);
      
      // Setelah berhasil diunggah, kamu bisa menyimpan URL ini ke Firestore atau SQL
      print('Audio berhasil diunggah. URL: $audioUrl');
      
      // TODO: Logika untuk memanggil model AI di backend
      // Untuk sementara, kita asumsikan hasilnya
      _audioDiagnosis = 'TB';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Audio berhasil diunggah dan didiagnosis!')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pemeriksaan Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Data Pasien', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 16),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama Pasien'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nikController,
              decoration: InputDecoration(labelText: 'NIK Pasien'),
            ),
            SizedBox(height: 32),
            
            Text('Unggah Audio', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 16),
            _audioFile == null
                ? Text('Belum ada file audio yang dipilih.')
                : Text('File terpilih: ${_audioFile!.path.split('/').last}'),
            
            ElevatedButton.icon(
              onPressed: _pickAudioFile,
              icon: Icon(Icons.upload_file),
              label: Text('Pilih File Audio Batuk'),
            ),
            
            if (_audioDiagnosis != null) ...[
              SizedBox(height: 24),
              Text(
                'Hasil Pra-Diagnosis AI: $_audioDiagnosis',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
            
            SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: _isLoading ? null : () {
                // TODO: Di sini kamu akan memanggil _uploadAudioToFirebase
                // Anggap saja kita punya id pemeriksaan
                // Misalnya, 'pemeriksaan_uuid_123'
                _uploadAudioToFirebase('pemeriksaan_uuid_123');
              },
              child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Unggah & Deteksi'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}