// lib/pages/dokter/data_tab.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_services.dart';

class DataTab extends StatefulWidget {
  @override
  _DataTabState createState() => _DataTabState();
}

class _DataTabState extends State<DataTab> {
  late Future<List<dynamic>> _pemeriksaanData;

  @override
  void initState() {
    super.initState();
    _pemeriksaanData = _fetchPemeriksaanData();
  }

  Future<List<dynamic>> _fetchPemeriksaanData() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    // TODO: Ganti dengan metode yang sebenarnya dari API Service
    return Future.value([
      {'nama': 'Joko Susilo', 'tanggal': '2025-08-09', 'diagnosis': 'TB'},
      {'nama': 'Maria', 'tanggal': '2025-08-08', 'diagnosis': 'Non-TB'},
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _pemeriksaanData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data pemeriksaan.'));
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Data Pemeriksaan Pasien',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: 20),
                  PaginatedDataTable(
                    columns: const [
                      DataColumn(label: Text('Nama Pasien')),
                      DataColumn(label: Text('Tanggal')),
                      DataColumn(label: Text('Diagnosis Final')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    source: _PemeriksaanDataSource(snapshot.data!, context),
                    header: const Text('Tabel Data Pemeriksaan'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class _PemeriksaanDataSource extends DataTableSource {
  final List<dynamic> _data;
  final BuildContext context;

  _PemeriksaanDataSource(this._data, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final item = _data[index];
    return DataRow(
      cells: [
        DataCell(Text(item['nama'])),
        DataCell(Text(item['tanggal'])),
        DataCell(Text(item['diagnosis'])),
        DataCell(
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/detail-pemeriksaan', arguments: item);
            },
            child: Text('Detail'),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
