# Prompt Eksekusi: Rewrite Gaya Penulisan — Kategori Gaming

Peran & Tujuan
Tulis ulang GAYA BAHASA (prosa) review laptop kategori Gaming di AstroLaptop,
mengikuti panduan gaya di PROMPT-GAYA-PENULISAN-2026.md (sudah ada di root
project — baca langsung, tidak perlu di-attach ulang). Spesifikasi laptop
TIDAK BOLEH berubah sama sekali.

Sumber gaya
- Baca PROMPT-GAYA-PENULISAN-2026.md secara penuh sebelum menulis apa pun.
  Terapkan semua bagian: Tone, Struktur Kalimat, Pilihan Kata, Standar
  Penulisan Artikel, Pembuka & Penutup, dan Aturan Wajib.
- Kalau butuh konteks tambahan/contoh, PANDUAN-GAYA-PENULISAN.md di root
  project adalah versi lengkapnya — boleh dibaca, jangan dianalisis ulang
  dari nol.

Scope — file yang diubah
- SELURUH laptop di src/pages/review/gaming/*.astro (20 file, semua tanpa
  kecuali)
- Kategori lain (Budget, Produktivitas, High Gaming, Ultrabook) TIDAK
  disentuh di sesi ini.

Yang BOLEH diubah (gaya penulisan saja):
- Atribut `ringkasan` di komponen <ReviewLayout>
- Semua paragraf <p> di section prosa: Desain & Build Quality, Kesimpulan,
  narasi antar-section, framing kalimat di pros/cons (<li> boleh ditulis
  ulang, klaim faktualnya harus tetap sama)
- Judul <h2> boleh disesuaikan gayanya selama makna section tidak berubah

Yang TIDAK BOLEH diubah — nol toleransi:
- Semua angka & baris di <table class="spek-table"> (CPU, GPU, TGP, VRAM,
  RAM, storage, layar/refresh rate, baterai, OS, bobot, dst) — copy persis
- Atribut harga, rating, kategori, tanggal
- Section Benchmark (angka score, Passmark, dst)
- Slug / nama file — tidak ada file yang di-rename
- DILARANG mengambil, mencari, atau memverifikasi data spek dari internet.
  Sumber kebenaran HANYA file yang sudah ada di project ini.

Proses
1. Baca PROMPT-GAYA-PENULISAN-2026.md, ekstrak aturan konkret jadi checklist
   (mis: orang pertama "saya", sapa pembaca "pengguna/pembeli", kalimat
   20-35 kata, pola klaim → alasan → contoh → tradeoff, frasa khas seperti
   "sangat mumpuni" dan "namun tradeoffnya adalah…", tanpa tanda seru/emoji,
   angka+satuan pakai spasi, dst).
2. Untuk SETIAP dari 20 file: catat dulu semua nilai di spek-table + harga +
   rating sebagai baseline sebelum diubah.
3. Tulis ulang bagian prosa mengikuti checklist gaya.
4. Verifikasi: bandingkan spek-table + harga + rating tiap file SEBELUM vs
   SESUDAH — harus identik 100%. Perbedaan sekecil apa pun = bug, perbaiki
   sebelum lanjut.

Output
- 20 file .astro (seluruh kategori gaming) dengan gaya penulisan baru sesuai
  PROMPT-GAYA-PENULISAN-2026.md, spek tidak berubah.
- Laporan ringkas: daftar 20 file yang diubah, konfirmasi hasil verifikasi
  spek (0 perubahan), dan tanya apakah gaya barunya sudah sesuai sebelum
  lanjut ke kategori lain.
