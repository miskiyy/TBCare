// lib/pages/dokter/form_tab.dart

import 'package:flutter/material.dart';

class FormTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Pilih Jenis Formulir',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/form-pasien-baru');
            },
            child: Text('Pasien Baru'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/form-progress-pasien');
            },
            child: Text('Progress Pasien'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
          ),
        ],
      ),
    );
  }
}
