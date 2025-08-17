// lib/pages/dokter/dokter_dashboard.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

// Halaman-halaman turunan (tabs)
import 'home_tab.dart'; // Nanti kita buat file baru ini
import 'form_tab.dart'; // Nanti kita buat file baru ini
import 'data_tab.dart'; // Nanti kita buat file baru ini

class DokterDashboardPage extends StatefulWidget {
  @override
  _DokterDashboardPageState createState() => _DokterDashboardPageState();
}

class _DokterDashboardPageState extends State<DokterDashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeTab(),
    FormTab(),
    DataTab(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('TBCARE'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar Navigasi untuk Desktop/Web
          _buildSidebar(context),
          
          // Konten Utama
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _children,
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar untuk Mobile
      bottomNavigationBar: MediaQuery.of(context).size.width < 600
          ? BottomNavigationBar(
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.description),
                  label: 'Form',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics),
                  label: 'Data',
                ),
              ],
            )
          : null,
    );
  }

  // Widget untuk sidebar navigasi
  Widget _buildSidebar(BuildContext context) {
    // Sembunyikan sidebar di layar mobile
    if (MediaQuery.of(context).size.width < 600) {
      return SizedBox.shrink();
    }
    
    return Container(
      width: 250,
      color: Colors.blue[800],
      child: Column(
        children: [
          _buildSidebarItem(0, 'Home', Icons.home),
          _buildSidebarItem(1, 'Form', Icons.description),
          _buildSidebarItem(2, 'Data', Icons.analytics),
          SizedBox(height: 20),
          // Tambahkan item lain jika diperlukan
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      selected: _currentIndex == index,
      selectedTileColor: Colors.blue[600],
      onTap: () {
        onTabTapped(index);
      },
    );
  }
}
