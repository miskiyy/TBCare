-- Menyimpan informasi dasar dokter.
CREATE TABLE Dokter (
    id_dokter INT PRIMARY KEY AUTO_INCREMENT,
    nama VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    rumah_sakit VARCHAR(255)
);

-- Membuat tabel User (Pasien)
-- Menyimpan data identitas pasien dan riwayat medis statis.
CREATE TABLE Pasien (
    id_pasien INT PRIMARY KEY AUTO_INCREMENT,
    nik VARCHAR(20) UNIQUE NOT NULL,
    nama VARCHAR(255) NOT NULL,
    tanggal_lahir DATE,
    jenis_kelamin ENUM('Laki-laki', 'Perempuan'),
    alamat TEXT,
    -- Variabel data sekunder yang dipindahkan ke sini
    riwayat_tb BOOLEAN, -- Mencakup 'tb_prior'
    riwayat_tb_paru BOOLEAN, -- Mencakup 'tbpriorPul'
    riwayat_tb_ekstrapulmonal BOOLEAN, -- Mencakup 'tbpriorExtrapul'
    riwayat_tb_tidak_diketahui BOOLEAN -- Mencakup 'tbpriorUnknown'
);

-- Menyimpan data setiap kali pemeriksaan dilakukan.
-- Ini adalah tabel relasi utama antara Pasien dan Dokter.
CREATE TABLE Pemeriksaan (
    id_pemeriksaan INT PRIMARY KEY AUTO_INCREMENT,
    id_pasien INT,
    id_dokter INT,
    tanggal_pemeriksaan DATETIME NOT NULL,
    -- Data fisik
    tinggi_badan DECIMAL(5, 2), -- Mencakup 'height'
    berat_badan DECIMAL(5, 2), -- Mencakup 'weight'
    detak_jantung INT, -- Mencakup 'heart_rate'
    suhu_tubuh DECIMAL(5, 2), -- Mencakup 'temperature'
    
    -- Gejala yang dilaporkan
    durasi_batuk INT, -- Mencakup 'reportedcoughdur'
    hemoptisis BOOLEAN, -- Mencakup 'hemoptysis'
    penurunan_berat_badan BOOLEAN, -- Mencakup 'weight_loss'
    demam BOOLEAN, -- Mencakup 'fever'
    keringat_malam BOOLEAN, -- Mencakup 'night_sweats'
    
    -- Riwayat gaya hidup
    merokok_7_hari_terakhir BOOLEAN, -- Mencakup 'smoke_lweek'
    
    -- Diagnosis
    diagnosis_dokter VARCHAR(50),
    diagnosis_ml_final VARCHAR(50),
    
    FOREIGN KEY (id_pasien) REFERENCES Pasien(id_pasien),
    FOREIGN KEY (id_dokter) REFERENCES Dokter(id_dokter)
);

-- Membuat tabel Audio
-- Menyimpan metadata audio, bukan file audionya.
-- 'url_file' menyimpan link ke file audio di Cloud Storage.
CREATE TABLE Audio (
    id_audio INT PRIMARY KEY AUTO_INCREMENT,
    id_pemeriksaan INT NOT NULL,
    nama_file VARCHAR(255) NOT NULL,
    url_file VARCHAR(255) NOT NULL,
    diagnosis_ml_per_audio VARCHAR(50),
    waktu_unggah DATETIME NOT NULL,
    FOREIGN KEY (id_pemeriksaan) REFERENCES Pemeriksaan(id_pemeriksaan)
);

--
-- Memasukkan data sampel untuk pengujian
--

-- Memasukkan data dokter
INSERT INTO Dokter (nama, email, password, rumah_sakit) VALUES
('Dr. Budi Santoso', 'budi.santoso@gmail.com', 'hashed_password_1', 'RSUD Dr. Soetomo');

-- Memasukkan data pasien
INSERT INTO Pasien (nik, nama, tanggal_lahir, jenis_kelamin, alamat, riwayat_tb, riwayat_tb_paru, riwayat_tb_ekstrapulmonal, riwayat_tb_tidak_diketahui) VALUES
('3578121234567890', 'Joko Susilo', '1990-05-15', 'Laki-laki', 'Jl. Merdeka No. 10, Surabaya', TRUE, TRUE, FALSE, FALSE);

-- Membuat satu pemeriksaan untuk Joko Susilo
INSERT INTO Pemeriksaan (id_pasien, id_dokter, tanggal_pemeriksaan, tinggi_badan, berat_badan, detak_jantung, suhu_tubuh, durasi_batuk, hemoptisis, penurunan_berat_badan, demam, keringat_malam, merokok_7_hari_terakhir, diagnosis_dokter, diagnosis_ml_final) VALUES
(1, 1, '2025-08-09 10:00:00', 170.5, 68.2, 85, 37.1, 21, TRUE, TRUE, TRUE, FALSE, FALSE, 'TB', 'TB');

-- Mengunggah dua audio untuk pemeriksaan yang sama
INSERT INTO Audio (id_pemeriksaan, nama_file, url_file, diagnosis_ml_per_audio, waktu_unggah) VALUES
(1, 'audio_joko_1.wav', 'https://storage.googleapis.com/namabucket-anda/audio/pemeriksaan_1/audio_joko_1.wav', 'TB', '2025-08-09 09:55:00'),
(1, 'audio_joko_2.wav', 'https://storage.googleapis.com/namabucket-anda/audio/pemeriksaan_1/audio_joko_2.wav', 'Non-TB', '2025-08-09 09:58:00');
