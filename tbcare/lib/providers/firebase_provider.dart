// lib/providers/firebase_provider.dart

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProvider {
  // Instance untuk Firebase Firestore dan Firebase Storage
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Getter untuk mengakses instance Firestore dari kelas lain
  FirebaseFirestore get firestore => _firestore;
  
  // Getter untuk mengakses instance Storage dari kelas lain
  FirebaseStorage get storage => _storage;

  // Metode untuk mengunggah file audio ke Firebase Storage
  // Menerima File audio dan ID unik untuk menamai file di cloud
  Future<String> uploadAudio(File audioFile, String pemeriksaanId) async {
    try {
      // Buat referensi ke lokasi file di Firebase Storage
      // Path: 'audio_rekaman/id_pemeriksaan/nama_file.wav'
      final fileName = audioFile.path.split('/').last;
      final storageRef = _storage.ref().child('audio_rekaman/$pemeriksaanId/$fileName');

      // Unggah file ke lokasi yang sudah ditentukan
      final uploadTask = storageRef.putFile(audioFile);

      // Tunggu hingga proses unggah selesai dan dapatkan URL unduhannya
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl; // Mengembalikan URL file yang sudah diunggah
    } on FirebaseException catch (e) {
      throw Exception('Gagal mengunggah audio: ${e.message}');
    }
  }
}