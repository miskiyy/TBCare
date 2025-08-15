class User {
  final int id;
  final String nama;
  final String email;

  User({required this.id, required this.nama, required this.email});
  
  // Factory method untuk membuat objek dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nama: json['nama'],
      email: json['email'],
    );
  }
}