// import 'package:flutter/material.dart';

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MedSense'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selamat Datang di MedSense',
              style: Theme.of(context).textTheme.headline4?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/login-dokter');
              },
              icon: Icon(Icons.medical_services, size: 24),
              label: Text('Login sebagai Dokter'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/login-user');
              },
              icon: Icon(Icons.person, size: 24),
              label: Text('Login sebagai Pasien'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
