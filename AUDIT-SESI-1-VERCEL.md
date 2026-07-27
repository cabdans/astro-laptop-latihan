# Audit AstroLaptop — Sesi 1 (Audit Vercel Live)

**Tanggal:** 24 Juli 2026
**URL:** https://astro-laptop-latihan-git-main-cabdans-projects.vercel.app
**Total laptop:** 76 · **Sesi:** 1/3 · **Fokus:** Testing halaman live di Vercel

> Catatan jumlah kategori (dari struktur folder & data): Budget **7**, Produktivitas **12**, Gaming **20 file / 18 data**, High Gaming **22 file / 24 data**, Ultrabook **15**. Total = **76** (angka per-kategori di prompt asli — 8/8/21/19/15 — tidak akurat, tapi totalnya benar).

---

## Ringkasan

Situs **fungsional secara keseluruhan**: semua halaman load, navigasi jalan, fitur inti (search, filter compare, wizard rekomendasi, perbandingan h2h, halaman review individual + benchmark) semuanya bekerja. Masalah utama terpusat pada **(a) keterbacaan Light Mode**, **(b) angka statistik hardcoded yang usang**, dan **(c) beberapa error JavaScript di konsol**.

**Total Issue Sesi 1: 12** — 🔴 High: 2 · 🟠 Medium: 6 · 🟡 Low: 4 · (Critical: 0)

---

## Tabel Bug

| No | Bug | Halaman | Severity | Status |
|----|-----|---------|----------|--------|
| 1 | Judul kartu laptop di grid "Semua Review" **tak terbaca di Light Mode** (teks near-white `#e2e8f0` di atas background near-white, kontras ~1.05:1). Terbaca normal di Dark Mode. | `/` (Homepage) | 🔴 High | ⏳ Pending |
| 2 | Filter budget **bocor**: 15 laptop tanpa harga (`hMin:0`, tampil "-") lolos SEMUA rentang budget → mis. laptop RTX 5080 muncul di filter "Rp 10–15 juta". Kartu hasil juga menampilkan harga "-". | `/rekomendasi` | 🔴 High | ⏳ Pending |
| 3 | Error konsol global **`ReferenceError: closeNav is not defined`** — `onclick="closeNav()"` di link nav mobile, tapi `closeNav` ada di `<script>` bundel (module scope) sehingga tak terjangkau inline handler. Menu mobile tak menutup via JS. | Semua halaman (header) | 🟠 Medium | ⏳ Pending |
| 4 | Error konsol **`TypeError: Cannot read properties of null (reading 'addEventListener')`** — script memanggil `getElementById('sel-a'/'sel-b')` pada elemen yang sudah tidak ada (sisa desain lama). Fitur inti tetap jalan. | `/h2h` | 🟠 Medium | ⏳ Pending |
| 5 | Entity trophy **`&#x1F3C6;` tampil sebagai teks mentah** (bukan 🏆) di badge "X unggul" (2×) dan banner kesimpulan — karena di-set via `.textContent` (tak men-decode HTML entity). Di dalam baris tabel 🏆 tampil benar. | `/h2h` | 🟠 Medium | ⏳ Pending |
| 6 | **Dropdown autocomplete gelap-di-atas-gelap di Light Mode** — panel pakai warna dark theme, teks opsi nyaris tak terbaca saat Light Mode. | `/h2h` | 🟠 Medium | ⏳ Pending |
| 7 | **Angka "61" hardcoded & usang (seharusnya 76)** tersebar di banyak tempat: subtitle rekomendasi ("dari 61 pilihan"), CTA compare di homepage ("Bandingkan semua 61 laptop"), hitungan awal compare ("Menampilkan 61 laptop" padahal 76 baris ter-render), dan tentang ("61 Laptop Diulas" + "Lihat semua 61 laptop"). | `/rekomendasi`, `/`, `/compare`, `/tentang` | 🟠 Medium | ⏳ Pending |
| 8 | **Statistik & kategori usang di Tentang**: "4 Kategori" + hanya 4 kartu kategori → **Ultrabook hilang** dari daftar; "8 Brand" bertentangan dengan homepage yang menampilkan "10 Brand". | `/tentang` | 🟠 Medium | ⏳ Pending |
| 9 | **`<title>` ganda**: halaman mengirim `title="Temukan Laptop — AstroLaptop"` sementara layout menambah "— AstroLaptop" lagi → "Temukan Laptop — AstroLaptop — AstroLaptop". | `/rekomendasi` | 🟡 Low | ⏳ Pending |
| 10 | **Inkonsistensi hitungan kategori**: count di data (Gaming 18 / High Gaming 24) ≠ jumlah file folder (Gaming 20 / High Gaming 22). 2 laptop di folder `gaming/` berlabel "High Gaming". Tak terlihat user, tapi bikin angka tak sinkron. | `/`, data | 🟡 Low | ⏳ Pending |
| 11 | **Data spec sangat minim** untuk sebagian entri ultrabook/Apple (mis. MacBook Air M4: Layar/RAM/Bobot/Baterai/Cooling = "No Data"). Template menanganinya rapi (tak rusak), tapi info kurang. | `/review/ultrabook/*` | 🟡 Low | ⏳ Pending |
| 12 | **`compare.astro` tidak punya `@media` breakpoint** — tabel 9 kolom kemungkinan tidak ramah mobile (overflow horizontal). *Belum bisa diverifikasi di lebar layar nyata karena resize viewport otomatis tak ter-reflow.* | `/compare` | 🟡 Low–Med | ⏳ Perlu cek device |

---

## Halaman yang Bermasalah

- **`/` (Homepage)** — bug #1 (judul kartu invisible di Light Mode), #7, #10.
- **`/rekomendasi`** — bug #2 (filter budget bocor), #7, #9.
- **`/h2h`** — bug #4, #5, #6.
- **`/tentang`** — bug #7, #8 (Ultrabook hilang, brand tak konsisten).
- **`/compare`** — bug #7 (hitungan awal 61), #12 (responsif).
- **Global (header semua halaman)** — bug #3 (`closeNav`).

---

## Yang Sudah Diverifikasi BERFUNGSI (bukan bug)

- **Homepage:** hero, stats (angka final 76/5/10 benar — angka rendah di awal hanya animasi count-up), kartu kategori, grid review render benar (di Dark Mode).
- **Toggle Light/Dark:** **berfungsi** — ada delay animasi ~380 ms sebelum tema diterapkan (bukan bug).
- **Dark Mode:** starfield aktif (canvas `display:block`), judul kartu terbaca, warna sesuai. Light Mode menyembunyikan starfield dengan benar (`display:none`).
- **`/review`:** "76 review tersedia" benar; **search** jalan (mis. "macbook" → 3 hasil); filter kategori jalan (Gaming → 18); judul kartu terbaca di Light Mode (template berbeda dari homepage).
- **Review individual:** load sempurna, spec lengkap (CPU/GPU/TGP/VRAM/RAM/layar/berat/kategori), badge kategori, harga + tombol afiliasi, **section Benchmark CPU** (NanoReview + Passmark ST/MT) tampil untuk CPU yang ada datanya.
- **`/compare`:** 76 baris ter-render, **sorting kolom jalan**, **filter jalan** (Kategori→Budget = 7, hitungan ter-update saat filter diubah), badge Score CPU tampil.
- **`/rekomendasi`:** wizard 5 langkah jalan, kombinasi filter menghasilkan hasil relevan, kartu hasil kontras baik di Light Mode.
- **`/h2h`:** dropdown searchable jalan, filter Budget/GPU ada, tabel perbandingan lengkap, highlight menang/kalah (🏆 di baris), total poin & kesimpulan otomatis muncul (mis. "8 vs 3").
- **Konsol:** tidak ada error kritis baru per-halaman selain #3 & #4 di atas; tidak ada request 404/500 yang terdeteksi; halaman load cepat.

---

## Catatan Metodologi

- Audit dilakukan langsung pada deployment live Vercel (branch `git-main`), dibantu pemeriksaan kode sumber untuk mengonfirmasi akar penyebab tiap bug.
- **Belum tercakup di Sesi 1 (disarankan untuk sesi berikut):**
  - Uji responsif nyata di lebar 375/768/1024 px (resize viewport otomatis tidak ter-reflow di sesi ini) — terutama tabel `/compare` dan menu hamburger mobile (yang terdampak bug #3).
  - Cek individual 25 halaman penuh (sesi ini sampling representatif: 1 Gaming lengkap + 1 Ultrabook; template dipakai bersama jadi rendering konsisten).
  - Verifikasi 3 kombinasi filter penuh di compare & h2h (sesi ini masing-masing diuji 1–2 kombinasi + logika filter dikonfirmasi via kode).
