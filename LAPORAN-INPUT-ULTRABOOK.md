# Laporan Input Data — Ultrabook

**Tanggal:** 22 Juli 2026
**Sumber:** `Spesifikasi Laptop Ultrabook.docx` (sheet "Ultrabook", 15 model)
**Status:** ✅ Sukses — 15 laptop baru, kategori baru "Ultrabook", tanpa duplikat.

---

## Ringkasan

| Item | Nilai |
|---|---|
| Laptop di docx | 15 |
| Laptop baru diinput | **15** |
| Duplikat (sudah ada) | 0 |
| Total laptop database (sebelum → sesudah) | 61 → **76** |
| Kategori (sebelum → sesudah) | 4 → **5** (Ultrabook baru) |
| Brand (sebelum → sesudah) | 9 → **10** (Apple baru) |
| File `.astro` baru | 15 (folder `src/pages/review/ultrabook/`) |

Semua GPU = **Integrated / iGPU** (tidak ada GPU dedicated; kolom GPU tidak ada di sumber, jadi tidak ditebak). Harga dari docx dimasukkan bila ada, sisanya `-`. Benchmark di-skip (`pmMulti=0`).

---

## Daftar Laptop Ultrabook Baru + URL

1. Acer Swift Go 14 SFG14 Ultra 5 125H — `.../review/ultrabook/acer-swift-go-14-sfg14-ultra5-125h`
2. Acer Swift Go 14 AI SFG14-73-73P9 — `.../review/ultrabook/acer-swift-go-14-sfg14-73p9`
3. ADVAN Workplus AI Ryzen 7 255 — `.../review/ultrabook/advan-workplus-ai-ryzen7-255`
4. Apple MacBook Air M2 13" — `.../review/ultrabook/apple-macbook-air-m2-13`
5. Lenovo IdeaPad Slim 5 14 OLED Ryzen 7 8845HS — `.../review/ultrabook/lenovo-ideapad-slim5-14-oled-ryzen7-8845hs`
6. Lenovo IdeaPad Slim 5 14IAH10 Ultra 5 225H — `.../review/ultrabook/lenovo-ideapad-slim5-14iah10-ultra5-225h`
7. Lenovo IdeaPad Slim 5i Ultra 7 255H — `.../review/ultrabook/lenovo-ideapad-slim5i-ultra7-255h`
8. Lenovo Yoga Slim 7i Aura Edition Ultra 5 226V — `.../review/ultrabook/lenovo-yoga-slim7i-aura-ultra5-226v`
9. MSI Prestige 14 AI+ Ultra 7 355 — `.../review/ultrabook/msi-prestige-14-ai-ultra7-355`
10. Apple MacBook Air M4 — `.../review/ultrabook/apple-macbook-air-m4`
11. MSI Prestige 14 Flip AI+ Ultra 9 386H — `.../review/ultrabook/msi-prestige-14-flip-ultra9-386h`
12. Apple MacBook Pro 14 M5 — `.../review/ultrabook/apple-macbook-pro-14-m5`
13. ASUS ExpertBook Ultra P5405CSA Ultra 7 258V — `.../review/ultrabook/asus-expertbook-ultra-p5405csa-ultra7-258v`
14. Acer Swift Go 14 AI SFG14-171 Ultra 7 358H — `.../review/ultrabook/acer-swift-go-14-sfg14-171-ultra7-358h`
15. ASUS ExpertBook B9400CBA Ultra 7 358H — `.../review/ultrabook/asus-expertbook-b9400cba-ultra7-358h`

---

## Audit Duplikat

Tidak ada duplikat. Model mirip yang dicek: Lenovo IdeaPad **Slim 5/5i** (baru) berbeda dari **Slim 3** yang sudah ada; ASUS ExpertBook **P5405CSA/B9400CBA** (baru) berbeda dari **PM1403CDA** yang ada; ADVAN **Workplus AI Ryzen 7 255** berbeda dari Advan Workplus lain. Semua Apple & MSI Prestige belum pernah ada.

---

## Perlu Konfirmasi / Kelengkapan Data (dari sumber)

1. **CPU kosong** — Acer Swift Go 14 AI SFG14-73-73P9 (ditandai "Tidak tercantum" di halaman).
2. **Data sangat minim** — Apple MacBook Air M4 & MacBook Pro 14 M5: sumber hanya berisi CPU + harga; layar, RAM, baterai, dll bertanda "-" → ditampilkan "No Data".
3. **RAM tidak tercantum** — MacBook Air M2 13".
4. **Cakupan warna "P3"** — beberapa unit tertulis "P3" (bukan "100% sRGB"). Diperlakukan sebagai `srgb: true` karena panel P3 mencakup 100% sRGB; di halaman ditulis "100% DCI-P3".
5. **Harga belum ada** (4 unit): Swift Go 73P9, ExpertBook Ultra P5405CSA, Swift Go 358H, ExpertBook B9400CBA → `-`.
6. **GPU** tidak ada di kolom sumber → semua diisi "Integrated" (tanpa menebak model iGPU).

---

## Yang Diupdate (biar tampil & bisa difilter)

- **15 halaman review** individual di folder `ultrabook/`.
- **Data disinkron ke 4 array**: `rekomendasi.astro`, `review/index.astro`, `index.astro` (homepage), `h2h.astro` — semua 76 entri.
- **Perbandingan (compare)**: 15 baris + opsi filter **kategori "Ultrabook"** + opsi CPU **"Apple"**.
- **H2H**: 15 entri (bisa dipilih di dropdown; filter GPU "Integrated").
- **Kategori "Ultrabook" didaftarkan**: warna/badge di `ReviewLayout`, homepage, review, rekomendasi + **kartu kategori baru** di homepage + filter kategori di halaman Review.
- **Statistik homepage**: 76 laptop · 5 kategori · 10 brand · Rp 6–31 Juta. Kartu High Gaming diperbaiki jadi 24 laptop.

---

## Verifikasi

- ✅ 4 array parse valid: 76 entri, 15 Ultrabook, tanpa slug ganda.
- ✅ 15 halaman `.astro`: import ReviewLayout benar, prop lengkap, rating numerik, kategori "Ultrabook", tag seimbang.
- ✅ compare: 76 baris, semua `data-gpu/cpu/kategori` punya opsi filter yang cocok.
- ⚠️ `astro build` penuh perlu dijalankan di komputermu (sandbox memblokir cache vite). Struktur identik dengan template yang sudah bekerja.

---

## Next Step

1. Jalankan `npm run build` lalu `push.bat` (commit `c5361e3` sudah siap, 1 commit ahead).
2. Lengkapi **harga** 4 unit + **CPU** Swift Go 73P9 + detail MacBook Air M4 / Pro M5.
3. Input **benchmark** + `pmMulti` (rating saat ini provisional per tier).
4. Opsional: tambah nama iGPU spesifik bila nanti tersedia di sumber.
