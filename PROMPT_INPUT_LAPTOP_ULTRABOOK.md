# PROMPT INPUT DATA LAPTOP ULTRABOOK KE ASTROLAPTOP

**Tujuan:** Input data laptop Ultrabook dari file Word ke website AstroLaptop dengan standar kualitas tertinggi, setiap laptop mendapat halaman review individual.

## Tahapan Pekerjaan:

### 1. Ekstraksi Data
- Baca file Word yang berisi data laptop Ultrabook baru
- Ekstrak semua field: nama laptop, CPU, GPU, RAM, storage, layar (sRGB), berat, kategori
- Abaikan data harga (skip untuk sementara)
- Validasi: semua data harus lengkap atau tandai field kosong

### 2. Audit Duplikat
- Cross-check setiap laptop dengan 39 laptop yang sudah ada di database AstroLaptop
- Perhatikan variasi nama (contoh: "Dell XPS 13" vs "Dell XPS 13 Plus")
- Catat mana yang sudah ada, mana yang baru

### 3. Setup Folder Struktur
- Navigasi ke: `src/pages/review`
- Buat folder baru: `ultrabook` (jika belum ada)
- Siapkan path untuk file `.astro` individual per laptop

### 4. Buat Halaman Review Individual untuk Setiap Laptop Ultrabook
- **Satu laptop = satu file `.astro`** di folder `ultrabook/`
- Nama file: `[kebab-case-nama-laptop].astro` (contoh: `dell-xps-13-plus.astro`)
- Setiap file `.astro` harus memuat:
  - Slug: path ke halaman (misal: `/review/ultrabook/dell-xps-13-plus`)
  - Layout: gunakan `ReviewLayout.astro`
  - Data laptop: nama, CPU, GPU, RAM, storage, sRGB, bobot, kategori, TGP, VRAM
  - Section review: spesifikasi, performa, benchmark (jika ada data)
  - CSS styling: sesuai design token project
- URL halaman akhir: `astrolaptop.com/review/ultrabook/[nama-laptop]`

### 5. Input Data dengan Toleransi Nol
- Buat file `.astro` untuk setiap laptop Ultrabook baru di folder `ultrabook`
- Ikuti struktur template yang ada (gunakan format dari `gaming/` atau kategori lain yang sudah ada sebagai template)
- Pastikan: nama file, slug, CSS styling, metadata sesuai standar project
- Triple-check sebelum finalisasi: nama, CPU, GPU, RAM, sRGB, bobot, kategori, halaman render dengan benar
- Setiap laptop harus accessible dan memiliki URL yang valid

### 6. Update Master Data di rekomendasi.astro
- Tambahkan entry untuk setiap laptop Ultrabook baru ke array laptop di `src/pages/rekomendasi.astro`
- Field: slug, nama, harga (skip), kategori (set ke "Ultrabook"), cpu, gpu, ram, srgb, ramUp, gpuDed, lokal, gpuTgp, gpuVram, bobot, pmMulti
- Pastikan slug cocok dengan nama file `.astro` yang dibuat

### 7. Verifikasi & Summary
- Test: setiap halaman laptop Ultrabook bisa diakses dan render dengan benar
- Buat laporan output berisi:
  - Jumlah laptop Ultrabook berhasil diinput (X laptop baru)
  - Daftar laptop Ultrabook baru + URL halaman mereka
  - Daftar laptop yang sudah ada di database (duplikat)
  - Status: sukses/ada error
- Berikan rekomendasi next step (harga, benchmark, dll)

## Standar Kualitas:
- ✅ Nol toleransi kesalahan dalam data entry
- ✅ Setiap laptop Ultrabook punya halaman `.astro` individual + URL yang valid
- ✅ Konsistensi dengan struktur existing
- ✅ Dokumentasi duplikat yang jelas
- ✅ Siap untuk git commit dan deploy
