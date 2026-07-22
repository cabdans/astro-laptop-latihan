# PROMPT INPUT DATA LAPTOP KE ASTROLAPTOP

**Tujuan:** Input data laptop dari file Word ke website AstroLaptop dengan standar kualitas tertinggi, setiap laptop mendapat halaman review individual.

## Tahapan Pekerjaan:

### 1. Ekstraksi Data
- Baca file Word yang berisi data laptop baru
- Ekstrak semua field: nama laptop, CPU, GPU, RAM, storage, layar (sRGB), berat, kategori
- Abaikan data harga (skip untuk sementara)
- Validasi: semua data harus lengkap atau tandai field kosong

### 2. Audit Duplikat
- Cross-check setiap laptop dengan 39 laptop yang sudah ada di database AstroLaptop
- Perhatikan variasi nama (contoh: "Lenovo LOQ" vs "Lenovo Legion of Quest")
- Catat mana yang sudah ada, mana yang baru

### 3. Setup Folder Struktur
- Navigasi ke: `src/pages/review`
- Buat folder baru: `high-gaming` (jika belum ada)
- Siapkan path untuk file `.astro` individual per laptop

### 4. Buat Halaman Review Individual untuk Setiap Laptop
- **Satu laptop = satu file `.astro`** di folder `high-gaming/`
- Nama file: `[kebab-case-nama-laptop].astro` (contoh: `asus-tuf-a16-fa608uh.astro`)
- Setiap file `.astro` harus memuat:
  - Slug: path ke halaman (misal: `/review/high-gaming/asus-tuf-a16-fa608uh`)
  - Layout: gunakan `ReviewLayout.astro`
  - Data laptop: nama, CPU, GPU, RAM, storage, sRGB, bobot, kategori, TGP, VRAM
  - Section review: spesifikasi, performa, benchmark (jika ada data)
  - CSS styling: sesuai design token project
- URL halaman akhir: `astrolaptop.com/review/high-gaming/[nama-laptop]`

### 5. Input Data dengan Toleransi Nol
- Buat file `.astro` untuk setiap laptop baru di folder `high-gaming`
- Ikuti struktur template yang ada (gunakan format dari `gaming/` atau `high-gaming/` yang sudah ada sebagai template)
- Pastikan: nama file, slug, CSS styling, metadata sesuai standar project
- Triple-check sebelum finalisasi: nama, CPU, GPU, RAM, sRGB, bobot, kategori, halaman render dengan benar
- Setiap laptop harus accessible dan memiliki URL yang valid

### 6. Update Master Data di rekomendasi.astro
- Tambahkan entry untuk setiap laptop baru ke array laptop di `src/pages/rekomendasi.astro`
- Field: slug, nama, harga (skip), kategori, cpu, gpu, ram, srgb, ramUp, gpuDed, lokal, gpuTgp, gpuVram, bobot, pmMulti
- Pastikan slug cocok dengan nama file `.astro` yang dibuat

### 7. Verifikasi & Summary
- Test: setiap halaman laptop bisa diakses dan render dengan benar
- Buat laporan output berisi:
  - Jumlah laptop berhasil diinput (X laptop baru)
  - Daftar laptop baru + URL halaman mereka
  - Daftar laptop yang sudah ada di database (duplikat)
  - Status: sukses/ada error
- Berikan rekomendasi next step (harga, benchmark, dll)

## Standar Kualitas:
- ✅ Nol toleransi kesalahan dalam data entry
- ✅ Setiap laptop punya halaman `.astro` individual + URL yang valid
- ✅ Konsistensi dengan struktur existing
- ✅ Dokumentasi duplikat yang jelas
- ✅ Siap untuk git commit dan deploy
