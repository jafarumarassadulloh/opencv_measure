# OpenCV Measure

## Deskripsi
### Gambaran Umum
Program ini secara garis besar dimaksudkan untuk mengukur dimensi dari suatu obyek yang difoto kemudian dikirim ke server yang berisikan program pengukuran dimensi.

Repositori ini berisi dua komponen utama:

1. **Program OpenCV**: Aplikasi Python yang menggunakan OpenCV untuk mengukur dimensi objek. Program ini memproses gambar untuk mendeteksi objek dan menghitung lebar, tinggi, serta dimensi lainnya.

2. **Aplikasi Flutter**: Aplikasi mobile yang dibangun menggunakan Flutter yang menyediakan antarmuka kamera untuk mengambil gambar objek yang kemudian diproses oleh program OpenCV.

## Fitur
- **Program OpenCV**:
  - Deteksi objek dan pengukuran dimensi.
  - Teknik pra-pemrosesan gambar seperti deteksi tepi dan kontur.
  - Konversi satuan untuk pengukuran dunia nyata (masih mengalami masalah).

- **Aplikasi Flutter**:
  - Antarmuka kamera untuk mengambil gambar.
  - Integrasi dengan program OpenCV untuk pengukuran objek (belum dilakukan).
