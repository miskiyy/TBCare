// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'providers/auth_provider.dart';
import 'providers/firebase_provider.dart';
import 'services/api_services.dart';

import 'pages/index_page.dart';
import 'pages/pasien/pasien_dashboard.dart';
import 'pages/login_user_page.dart';

// Import halaman-halaman yang sudah dikelompokkan
import 'pages/dokter/data_tab.dart';
import 'pages/dokter/detail_pemeriksaan_page.dart';
import 'pages/dokter/dokter_dashboard.dart';
import 'pages/dokter/form_pasien_baru_page.dart';
import 'pages/dokter/form_progress_pasien_page.dart';
import 'pages/dokter/form_tab.dart';
import 'pages/dokter/home_tab.dart';
import 'pages/dokter/login_dokter_page.dart'; // Pindahkan ke folder dokter
import 'pages/dokter/pemeriksaan_baru_page.dart'; // Pindahkan ke folder dokter

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        Provider(create: (context) => FirebaseProvider()),
        Provider(create: (context) => ApiService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TBCARE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color(0xFFF0F2F5),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          fillColor: Colors.white,
          filled: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
        ),
        // Perbaikan untuk TextTheme yang usang
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 96, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => IndexPage(),
        '/login-dokter': (context) => LoginDokterPage(),
        '/login-user': (context) => LoginUserPage(),
        '/dashboard-dokter': (context) => DokterDashboardPage(),
        '/dashboard-pasien': (context) => PasienDashboardPage(),
        '/form-pasien-baru': (context) => FormPasienBaruPage(),
        '/form-progress-pasien': (context) => FormProgressPasienPage(),
        '/detail-pemeriksaan': (context) => DetailPemeriksaanPage(),
        // Catatan: rute ini mungkin tidak diperlukan
        // '/pemeriksaan-baru': (context) => PemeriksaanBaruPage(),
      },
    );
  }
}
