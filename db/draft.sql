-- Membuat tabel Dokter
CREATE TABLE Dokter (
    id_dokter INT PRIMARY KEY AUTO_INCREMENT,
    nama VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    rumah_sakit VARCHAR(255)
);

-- Membuat tabel User (Pasien)
CREATE TABLE User (
    id_user INT PRIMARY KEY AUTO_INCREMENT,
    nik VARCHAR(20) UNIQUE NOT NULL,
    nama VARCHAR(255) NOT NULL,
    tanggal_lahir DATE,
    jenis_kelamin ENUM('Laki-laki', 'Perempuan'),
    alamat TEXT
);

-- Membuat tabel Pemeriksaan
CREATE TABLE Pemeriksaan (
    id_pemeriksaan INT PRIMARY KEY AUTO_INCREMENT,
    id_user INT,
    id_dokter INT,
    tanggal_pemeriksaan DATETIME NOT NULL,
    tinggi_badan DECIMAL(5, 2),
    berat_badan DECIMAL(5, 2),
    riwayat_penyakit TEXT,
    diagnosis_dokter VARCHAR(50),
    diagnosis_ml_final VARCHAR(50),
    FOREIGN KEY (id_user) REFERENCES User(id_user),
    FOREIGN KEY (id_dokter) REFERENCES Dokter(id_dokter)
);

-- Membuat tabel Audio
CREATE TABLE Audio (
    id_audio INT PRIMARY KEY AUTO_INCREMENT,
    id_pemeriksaan INT NOT NULL,
    nama_file VARCHAR(255) NOT NULL,
    path_file VARCHAR(255) NOT NULL,
    diagnosis_ml_per_audio VARCHAR(50),
    waktu_unggah DATETIME NOT NULL,
    FOREIGN KEY (id_pemeriksaan) REFERENCES Pemeriksaan(id_pemeriksaan)
);

-- Memasukkan data dokter dan user
INSERT INTO Dokter (nama, email, password, rumah_sakit) VALUES
('Dr. Budi Santoso', 'budi.santoso@gmail.com', 'hashed_password_1', 'RSUD Dr. Soetomo');

INSERT INTO User (nik, nama, tanggal_lahir, jenis_kelamin, alamat) VALUES
('3578121234567890', 'Joko Susilo', '1990-05-15', 'Laki-laki', 'Jl. Merdeka No. 10, Surabaya');

-- Membuat satu pemeriksaan untuk Joko Susilo
INSERT INTO Pemeriksaan (id_user, id_dokter, tanggal_pemeriksaan, tinggi_badan, berat_badan, riwayat_penyakit, diagnosis_dokter, diagnosis_ml_final) VALUES
(1, 1, '2025-08-09 10:00:00', 170.5, 68.2, 'Batuk kronis dan sesak napas selama 3 minggu', 'TB', 'TB');

-- Mengunggah dua audio untuk pemeriksaan yang sama
INSERT INTO Audio (id_pemeriksaan, nama_file, path_file, diagnosis_ml_per_audio, waktu_unggah) VALUES
(1, 'audio_joko_1.wav', '/storage/audio/pemeriksaan_1/audio_joko_1.wav', 'TB', '2025-08-09 09:55:00'),
(1, 'audio_joko_2.wav', '/storage/audio/pemeriksaan_1/audio_joko_2.wav', 'Non-TB', '2025-08-09 09:58:00');