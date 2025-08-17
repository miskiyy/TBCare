# models.py
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Dokter(db.Model):
    __tablename__ = 'Dokter'
    id_dokter = db.Column(db.Integer, primary_key=True, autoincrement=True)
    nama = db.Column(db.String(255), nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)
    rumah_sakit = db.Column(db.String(255))

class Pasien(db.Model):
    __tablename__ = 'Pasien'
    id_pasien = db.Column(db.Integer, primary_key=True, autoincrement=True)
    nik = db.Column(db.String(20), unique=True, nullable=False)
    nama = db.Column(db.String(255), nullable=False)
    tanggal_lahir = db.Column(db.Date)
    jenis_kelamin = db.Column(db.Enum('Laki-laki', 'Perempuan'))
    alamat = db.Column(db.Text)
    riwayat_tb = db.Column(db.Boolean)
    riwayat_tb_paru = db.Column(db.Boolean)
    riwayat_tb_ekstrapulmonal = db.Column(db.Boolean)
    riwayat_tb_tidak_diketahui = db.Column(db.Boolean)

class Pemeriksaan(db.Model):
    __tablename__ = 'Pemeriksaan'
    id_pemeriksaan = db.Column(db.Integer, primary_key=True, autoincrement=True)
    id_pasien = db.Column(db.Integer, db.ForeignKey('Pasien.id_pasien'))
    id_dokter = db.Column(db.Integer, db.ForeignKey('Dokter.id_dokter'))
    tanggal_pemeriksaan = db.Column(db.DateTime, nullable=False)
    tinggi_badan = db.Column(db.Numeric(5, 2))
    berat_badan = db.Column(db.Numeric(5, 2))
    detak_jantung = db.Column(db.Integer)
    suhu_tubuh = db.Column(db.Numeric(5, 2))
    durasi_batuk = db.Column(db.Integer)
    hemoptisis = db.Column(db.Boolean)
    penurunan_berat_badan = db.Column(db.Boolean)
    demam = db.Column(db.Boolean)
    keringat_malam = db.Column(db.Boolean)
    merokok_7_hari_terakhir = db.Column(db.Boolean)
    diagnosis_dokter = db.Column(db.String(50))
    diagnosis_ml_final = db.Column(db.String(50))

class Audio(db.Model):
    __tablename__ = 'Audio'
    id_audio = db.Column(db.Integer, primary_key=True, autoincrement=True)
    id_pemeriksaan = db.Column(db.Integer, db.ForeignKey('Pemeriksaan.id_pemeriksaan'), nullable=False)
    nama_file = db.Column(db.String(255), nullable=False)
    url_file = db.Column(db.String(255), nullable=False)
    diagnosis_ml_per_audio = db.Column(db.String(50))
    waktu_unggah = db.Column(db.DateTime, nullable=False)