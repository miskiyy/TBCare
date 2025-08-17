// lib/pages/dokter/home_tab.dart

import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Halo, Dr. X',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          SizedBox(height: 16),
          Text(
            'TB News',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 8),
          // Placeholder untuk TB News
          Container(
            height: 150,
            color: Colors.grey[200],
            child: Center(child: Text('Placeholder untuk Berita TB')),
          ),
          SizedBox(height: 24),
          Text(
            'Cara Penggunaan Alat',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 8),
          // Placeholder untuk cara penggunaan alat
          Container(
            height: 200,
            color: Colors.grey[200],
            child: Center(child: Text('Placeholder untuk Panduan Hardware')),
          ),
        ],
      ),
    );
  }
}