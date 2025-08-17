// lib/pages/dokter/form_pasien_baru_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_services.dart';

class FormPasienBaruPage extends StatefulWidget {
  @override
  _FormPasienBaruPageState createState() => _FormPasienBaruPageState();
}

class _FormPasienBaruPageState extends State<FormPasienBaruPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _alamatController = TextEditingController();
  final _tanggalLahirController = TextEditingController();

  String? _jenisKelamin;
  bool _riwayatTb = false;
  bool _riwayatTbParu = false;
  bool _riwayatTbEkstrapulmonal = false;
  bool _riwayatTbTidakDiketahui = false;
  
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _alamatController.dispose();
    _tanggalLahirController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tanggalLahirController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });
      try {
        final apiService = ApiService();
        final pasienData = {
          'nama': _namaController.text,
          'nik': _nikController.text,
          'alamat': _alamatController.text,
          'tanggal_lahir': _tanggalLahirController.text,
          'jenis_kelamin': _jenisKelamin,
          'riwayat_tb': _riwayatTb,
          'riwayat_tb_paru': _riwayatTbParu,
          'riwayat_tb_ekstrapulmonal': _riwayatTbEkstrapulmonal,
          'riwayat_tb_tidak_diketahui': _riwayatTbTidakDiketahui,
        };

        final response = await apiService.createPasien(pasienData);
        
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
        title: Text('Form Pasien Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Pasien'),
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nikController,
                decoration: InputDecoration(labelText: 'NIK Pasien'),
                validator: (value) => value!.isEmpty ? 'NIK tidak boleh kosong' : null,
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: IgnorePointer(
                  child: TextFormField(
                    controller: _tanggalLahirController,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Lahir',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) => value!.isEmpty ? 'Tanggal lahir tidak boleh kosong' : null,
                  ),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                value: _jenisKelamin,
                items: ['Laki-laki', 'Perempuan']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _jenisKelamin = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih jenis kelamin' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                maxLines: 3,
              ),
              SizedBox(height: 32),

              // Bagian riwayat penyakit
              Text(
                'Riwayat Penyakit',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              CheckboxListTile(
                title: Text('Riwayat TB'),
                value: _riwayatTb,
                onChanged: (bool? value) { setState(() { _riwayatTb = value!; }); },
              ),
              CheckboxListTile(
                title: Text('Riwayat TB Paru'),
                value: _riwayatTbParu,
                onChanged: (bool? value) { setState(() { _riwayatTbParu = value!; }); },
              ),
              CheckboxListTile(
                title: Text('Riwayat TB Ekstrapulmonal'),
                value: _riwayatTbEkstrapulmonal,
                onChanged: (bool? value) { setState(() { _riwayatTbEkstrapulmonal = value!; }); },
              ),
              CheckboxListTile(
                title: Text('Riwayat TB Tidak Diketahui'),
                value: _riwayatTbTidakDiketahui,
                onChanged: (bool? value) { setState(() { _riwayatTbTidakDiketahui = value!; }); },
              ),
              
              SizedBox(height: 24),
              
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Simpan'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}