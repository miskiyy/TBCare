import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/firebase_provider.dart';
import 'pages/index_page.dart';
import 'pages/login_dokter_page.dart';
import 'pages/login_user_page.dart';
import 'pages/dokter/dokter_dashboard_page.dart';
import 'pages/pasien/pasien_dashboard_page.dart';

void main() async {
  // Pastikan Flutter sudah terinisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Firebase (jika sudah dikonfigurasi)
  // await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        Provider(create: (context) => FirebaseProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedSense',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color(0xFFF0F2F5),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          fillColor: Colors.white,
          filled: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => IndexPage(),
        '/login-dokter': (context) => LoginDokterPage(),
        '/login-user': (context) => LoginUserPage(),
        '/dashboard-dokter': (context) => DokterDashboardPage(),
        '/dashboard-pasien': (context) => PasienDashboardPage(),
      },
    );
  }
}
