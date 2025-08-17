// lib/pages/dokter/form_progress_pasien_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../services/api_services.dart';
import '../../providers/firebase_provider.dart';

class FormProgressPasienPage extends StatefulWidget {
  @override
  _FormProgressPasienPageState createState() => _FormProgressPasienPageState();
}

class _FormProgressPasienPageState extends State<FormProgressPasienPage> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _tbController = TextEditingController();
  final _bbController = TextEditingController();
  final _detakJantungController = TextEditingController();
  final _suhuTubuhController = TextEditingController();
  final _durasiBatukController = TextEditingController();
  final _diagnosisDokterController = TextEditingController();
  final _diagnosisMlFinalController = TextEditingController();

  bool _hemoptisis = false;
  bool _penurunanBeratBadan = false;
  bool _demam = false;
  bool _keringatMalam = false;
  bool _merokok7HariTerakhir = false;

  File? _audioFile;
  bool _isLoading = false;

  @override
  void dispose() {
    _nikController.dispose();
    _tbController.dispose();
    _bbController.dispose();
    _detakJantungController.dispose();
    _suhuTubuhController.dispose();
    _durasiBatukController.dispose();
    _diagnosisDokterController.dispose();
    _diagnosisMlFinalController.dispose();
    super.dispose();
  }
  
  Future<void> _pickAndUploadAudio() async {
    final firebaseProvider = Provider.of<FirebaseProvider>(context, listen: false);
    final apiService = ApiService();
    
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() { _isLoading = true; });
      try {
        final audioFile = File(result.files.single.path!);
        
        // Asumsi kita sudah punya id_pemeriksaan dari langkah sebelumnya
        // Untuk sekarang, kita pakai ID dummy
        final pemeriksaanId = 'pemeriksaan_123';
        
        // Unggah ke Firebase Cloud Storage
        final audioUrl = await firebaseProvider.uploadAudio(audioFile, pemeriksaanId);
        
        // Panggil model AI di backend Flask
        final mlResponse = await apiService.getMlDiagnosis(audioUrl);
        final diagnosisMl = mlResponse['diagnosis'];
        
        // Simpan metadata ke database SQL melalui Flask
        final audioMetadata = {
          'id_pemeriksaan': 1, // Ganti dengan ID yang sebenarnya dari backend
          'nama_file': audioFile.path.split('/').last,
          'url_file': audioUrl,
          'diagnosis_ml_per_audio': diagnosisMl,
          'waktu_unggah': DateTime.now().toIso8601String(),
        };
        await apiService.saveAudioMetadata(audioMetadata);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Diagnosis ML: $diagnosisMl')),
        );
        setState(() {
          _diagnosisMlFinalController.text = diagnosisMl;
          _audioFile = audioFile; // Simpan file untuk UI
        });
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
        );
      } finally {
        setState(() { _isLoading = false; });
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });
      try {
        final apiService = ApiService();
        final pemeriksaanData = {
          'id_pasien': 1, // Ganti dengan ID pasien yang sebenarnya
          'id_dokter': 1, // Ganti dengan ID dokter yang sebenarnya
          'tanggal_pemeriksaan': DateTime.now().toIso8601String(),
          'tinggi_badan': double.tryParse(_tbController.text),
          'berat_badan': double.tryParse(_bbController.text),
          'detak_jantung': int.tryParse(_detakJantungController.text),
          'suhu_tubuh': double.tryParse(_suhuTubuhController.text),
          'durasi_batuk': int.tryParse(_durasiBatukController.text),
          'hemoptisis': _hemoptisis,
          'penurunan_berat_badan': _penurunanBeratBadan,
          'demam': _demam,
          'keringat_malam': _keringatMalam,
          'merokok_7_hari_terakhir': _merokok7HariTerakhir,
          'diagnosis_dokter': _diagnosisDokterController.text,
          'diagnosis_ml_final': _diagnosisMlFinalController.text,
        };
        
        final response = await apiService.createPemeriksaan(pemeriksaanData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        Navigator.pop(context);
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
        );
      } finally {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Progress Pasien'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nikController,
                decoration: InputDecoration(labelText: 'NIK Pasien'),
                validator: (value) => value!.isEmpty ? 'NIK tidak boleh kosong' : null,
              ),
              SizedBox(height: 16),
              // --- Data Fisik ---
              TextFormField(
                controller: _tbController,
                decoration: InputDecoration(labelText: 'Tinggi Badan (cm)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _bbController,
                decoration: InputDecoration(labelText: 'Berat Badan (kg)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _detakJantungController,
                decoration: InputDecoration(labelText: 'Detak Jantung (bpm)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _suhuTubuhController,
                decoration: InputDecoration(labelText: 'Suhu Tubuh (°C)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 32),
              
              // --- Gejala yang Dilaporkan ---
              Text('Gejala yang Dilaporkan', style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 16),
              TextFormField(
                controller: _durasiBatukController,
                decoration: InputDecoration(labelText: 'Durasi Batuk (hari)'),
                keyboardType: TextInputType.number,
              ),
              CheckboxListTile(
                title: Text('Hemoptisis (batuk berdarah)'),
                value: _hemoptisis,
                onChanged: (bool? value) { setState(() { _hemoptisis = value!; }); },
              ),
              CheckboxListTile(
                title: Text('Penurunan Berat Badan'),
                value: _penurunanBeratBadan,
                onChanged: (bool? value) { setState(() { _penurunanBeratBadan = value!; }); },
              ),
              CheckboxListTile(
                title: Text('Demam'),
                value: _demam,
                onChanged: (bool? value) { setState(() { _demam = value!; }); },
              ),
              CheckboxListTile(
                title: Text('Keringat Malam'),
                value: _keringatMalam,
                onChanged: (bool? value) { setState(() { _keringatMalam = value!; }); },
              ),
              SizedBox(height: 32),
              
              // --- Riwayat Gaya Hidup ---
              Text('Riwayat Gaya Hidup', style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 16),
              CheckboxListTile(
                title: Text('Merokok dalam 7 hari terakhir'),
                value: _merokok7HariTerakhir,
                onChanged: (bool? value) { setState(() { _merokok7HariTerakhir = value!; }); },
              ),
              SizedBox(height: 32),

              // --- Bagian Unggah Audio ---
              Text('Unggah & Deteksi Audio', style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 16),
              _audioFile != null
                  ? Text('File terpilih: ${_audioFile!.path.split('/').last}')
                  : Text('Belum ada file audio yang dipilih.'),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _pickAndUploadAudio,
                icon: _isLoading ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Icon(Icons.upload_file),
                label: Text('Unggah & Deteksi Audio'),
              ),
              SizedBox(height: 24),
              
              // --- Diagnosis ---
              TextFormField(
                controller: _diagnosisDokterController,
                decoration: InputDecoration(labelText: 'Diagnosis Dokter (misal: "TB" atau "Non-TB")'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _diagnosisMlFinalController,
                decoration: InputDecoration(labelText: 'Diagnosis ML Final (Otomatis)'),
                readOnly: true,
              ),
              
              SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: Text('Simpan Pemeriksaan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
