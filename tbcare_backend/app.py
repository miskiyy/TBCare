from flask import Flask, request, jsonify
import os

from models import db, Dokter, Pasien, Pemeriksaan, Audio

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL', 'sqlite:///tbcare.db') 
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db.init_app(app)

# --- Endpoint API ---
@app.route('/')
def home():
    return "Backend TBCARE Berjalan!"

@app.route('/api/pasien', methods=['POST'])
def create_pasien():
    data = request.json
    try:
        new_pasien = Pasien(
            nik=data['nik'],
            nama=data['nama'],
            tanggal_lahir=data['tanggal_lahir'],
            jenis_kelamin=data['jenis_kelamin'],
            alamat=data['alamat'],
            riwayat_tb=data.get('riwayat_tb', False),
            riwayat_tb_paru=data.get('riwayat_tb_paru', False),
            riwayat_tb_ekstrapulmonal=data.get('riwayat_tb_ekstrapulmonal', False),
            riwayat_tb_tidak_diketahui=data.get('riwayat_tb_tidak_diketahui', False)
        )
        db.session.add(new_pasien)
        db.session.commit()
        return jsonify({'message': 'Pasien berhasil dibuat', 'pasien_id': new_pasien.id_pasien}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@app.route('/api/pemeriksaan', methods=['POST'])
def create_pemeriksaan():
    data = request.json
    try:
        new_pemeriksaan = Pemeriksaan(
            id_pasien=data['id_pasien'],
            id_dokter=data['id_dokter'],
            tanggal_pemeriksaan=data['tanggal_pemeriksaan'],
            tinggi_badan=data.get('tinggi_badan'),
            berat_badan=data.get('berat_badan'),
            detak_jantung=data.get('detak_jantung'),
            suhu_tubuh=data.get('suhu_tubuh'),
            durasi_batuk=data.get('durasi_batuk'),
            hemoptisis=data.get('hemoptisis'),
            penurunan_berat_badan=data.get('penurunan_berat_badan'),
            demam=data.get('demam'),
            keringat_malam=data.get('keringat_malam'),
            merokok_7_hari_terakhir=data.get('merokok_7_hari_terakhir'),
            diagnosis_dokter=data.get('diagnosis_dokter'),
            diagnosis_ml_final=data.get('diagnosis_ml_final')
        )
        db.session.add(new_pemeriksaan)
        db.session.commit()
        return jsonify({'message': 'Pemeriksaan berhasil dibuat', 'pemeriksaan_id': new_pemeriksaan.id_pemeriksaan}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@app.route('/api/audio', methods=['POST'])
def upload_audio():
    # Perhatikan: Endpoint ini hanya menerima URL dari Flutter
    # Unggah file fisik dari Flutter ke Cloud Storage, lalu kirim URL-nya ke endpoint ini
    data = request.json
    try:
        new_audio = Audio(
            id_pemeriksaan=data['id_pemeriksaan'],
            nama_file=data['nama_file'],
            url_file=data['url_file'],
            diagnosis_ml_per_audio=data.get('diagnosis_ml_per_audio', 'Belum didiagnosis'),
            waktu_unggah=data['waktu_unggah']
        )
        db.session.add(new_audio)
        db.session.commit()
        return jsonify({'message': 'Data audio berhasil disimpan'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 400

# Endpoint untuk simulasi deteksi TB oleh model AI
@app.route('/api/ml-diagnosis', methods=['POST'])
def ml_diagnosis():
    data = request.json
    audio_url = data.get('audio_url')
    # TODO: Logika di sini untuk memanggil model AI asli
    # Untuk sekarang, kita simulasikan hasilnya
    diagnosis = 'TB' if 'batuk-tb' in audio_url.lower() else 'Non-TB'
    return jsonify({'diagnosis': diagnosis}), 200
# Endpoint untuk mengambil daftar semua pemeriksaan
@app.route('/api/pemeriksaan_list', methods=['GET'])
def get_pemeriksaan_list():
    try:
        pemeriksaan_data = db.session.query(
            Pemeriksaan, Pasien, Dokter
        ).join(Pasien).join(Dokter).all()
        
        results = []
        for pemeriksaan, pasien, dokter in pemeriksaan_data:
            results.append({
                'id_pemeriksaan': pemeriksaan.id_pemeriksaan,
                'pasien_nama': pasien.nama,
                'tanggal_pemeriksaan': pemeriksaan.tanggal_pemeriksaan.isoformat(),
                'diagnosis_ml_final': pemeriksaan.diagnosis_ml_final,
                'diagnosis_dokter': pemeriksaan.diagnosis_dokter,
                'pasien_nik': pasien.nik,
                'dokter_nama': dokter.nama
            })
        
        return jsonify(results), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Endpoint untuk mengambil detail satu pemeriksaan
@app.route('/api/pemeriksaan/<int:id>', methods=['GET'])
def get_pemeriksaan_detail(id):
    try:
        pemeriksaan = Pemeriksaan.query.get(id)
        if not pemeriksaan:
            return jsonify({'message': 'Pemeriksaan tidak ditemukan'}), 404

        pasien = Pasien.query.get(pemeriksaan.id_pasien)
        dokter = Dokter.query.get(pemeriksaan.id_dokter)
        
        audio_list = Audio.query.filter_by(id_pemeriksaan=id).all()
        audio_data = [{
            'nama_file': audio.nama_file,
            'url_file': audio.url_file,
            'diagnosis_ml_per_audio': audio.diagnosis_ml_per_audio,
        } for audio in audio_list]
        
        detail = {
            'id_pemeriksaan': pemeriksaan.id_pemeriksaan,
            'tanggal_pemeriksaan': pemeriksaan.tanggal_pemeriksaan.isoformat(),
            'tinggi_badan': str(pemeriksaan.tinggi_badan),
            'berat_badan': str(pemeriksaan.berat_badan),
            'detak_jantung': pemeriksaan.detak_jantung,
            'suhu_tubuh': str(pemeriksaan.suhu_tubuh),
            'durasi_batuk': pemeriksaan.durasi_batuk,
            'hemoptisis': pemeriksaan.hemoptisis,
            'penurunan_berat_badan': pemeriksaan.penurunan_berat_badan,
            'demam': pemeriksaan.demam,
            'keringat_malam': pemeriksaan.keringat_malam,
            'merokok_7_hari_terakhir': pemeriksaan.merokok_7_hari_terakhir,
            'diagnosis_dokter': pemeriksaan.diagnosis_dokter,
            'diagnosis_ml_final': pemeriksaan.diagnosis_ml_final,
            'pasien': {
                'nama': pasien.nama,
                'nik': pasien.nik,
                'riwayat_tb': pasien.riwayat_tb,
                # ... riwayat lainnya
            },
            'audio_rekaman': audio_data
        }
        return jsonify(detail), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
if __name__ == '__main__':
    # Pastikan database terbuat
    with app.app_context():
        db.create_all()
    app.run(debug=True)