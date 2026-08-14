# AUDIT SUMMARY ASTROLAPTOP

**Tanggal:** 13 Agustus 2026
**Total Laptop:** 88 (Budget 8 · Produktivitas 13 · Gaming 24 · High Gaming 24 · Ultrabook 19)
**Metode:** pemeriksaan langsung atas source code + simulasi browser (jsdom) atas hasil build, bukan pembacaan manual
**Build:** lolos, 96 halaman

---

## Regression Check

| Fix lama | Masih utuh? | Bukti |
|---|---|---|
| Slug = kategori (88 entri) | ✅ | 0 mismatch dari 88 entri |
| Filter harga `rekomendasi.astro` | ✅ | `if (l.hMin === 0) return false;` di `budgetPass()` |
| Filter harga `compare.astro` | ✅ | `if (harga && rHarga === 0) show = false;` di `applyFilters()` |
| Filter harga `h2h.astro` | ✅ | guard `semuaHarga` + `hargaNum === 0` di `matchesFilters()` |
| Laptop tanpa harga konsisten | ✅ | **21** di ketiga file (rekomendasi `hMin:0`, compare `data-harga="0"`, h2h `hargaNum:0`) |
| Jumlah entri | ✅ | 88 di kelima sumber: rekomendasi, compare, h2h, index, review/index, dan folder `/review` |

Diuji lewat simulasi: keempat bucket harga di `/compare` menampilkan **0 laptop tanpa harga**, dan bucket "<8 Jt" di `/h2h` menyaring dari 88 ke 9.

---

## Bug Ditemukan & Diperbaiki

| Halaman | Bug | Fix |
|---|---|---|
| `index.astro` | Kartu kategori masih memakai jumlah lama: Budget **7**, Produktivitas **12**, Gaming **18**, Ultrabook **15** | Diperbarui ke 8 / 13 / 24 / 19 — totalnya kini 88 |
| `ultrabook/acer-swift-air-14-ultra5-125h` | 3 paragraf **identik** dengan varian Ultra 7 155H, melanggar aturan "tidak ada paragraf identik antar file" | Ketiganya ditulis ulang; fakta tetap sama, kalimat berbeda |
| `PANDUAN-GAYA-PENULISAN.md` | Tabel status masih 7/12/20/24/15 dan "76 halaman" | Diperbarui ke 8/13/24/24/19, total 88 |

Verifikasi ulang: **0 paragraf identik** di seluruh 88 file review.

---

## Konflik Benchmark

### A. `cpuBench` (h2h) versus halaman review — 5 konflik

| CPU | Metrik | Nilai di `h2h` | Nilai di halaman review | Catatan |
|---|---|---|---|---|
| AMD Ryzen AI 7 250 | eff | 81 | 80 | Sheet 2 menyebut 80 |
| AMD Ryzen AI 7 255 | pmS · pmM | 3.520 · 22.000 | 3.717 · 28.774 | angka h2h terlihat bulat/perkiraan |
| Intel Core i7-13700H | pmS · pmM | 3.650 · 25.000 | 3.557 · 25.960 | angka h2h terlihat bulat/perkiraan |
| Intel Core i7-13700HX | pmS · pmM | 3.800 · 29.500 | 3.798 · 31.788 | angka h2h terlihat bulat/perkiraan |

**Keputusan: BELUM DIAMBIL** — menunggu Cahya, sesuai aturan "jangan menimpa benchmark tanpa keputusan eksplisit".

Pola yang terlihat: nilai di `h2h.astro` untuk keempatnya berakhiran angka bulat (22.000, 25.000, 29.500, 3.500, 3.650, 3.800), sementara halaman review memakai angka presisi. Ini menguatkan dugaan bahwa `cpuBench` diisi dengan perkiraan sebelum data asli tersedia.

### B. Konflik antar halaman review — 1 temuan

| CPU | Halaman | eff |
|---|---|---|
| AMD Ryzen AI 7 250 | `gaming/lenovo-loq-15ahp10` | **81** |
| AMD Ryzen AI 7 250 | `high-gaming/lenovo-loq-15ahp11-rtx5060` | **80** |

Satu CPU, dua angka berbeda di situs yang sama. **Belum diperbaiki**, menunggu keputusan yang sama dengan bagian A.

### C. Yang sudah diselesaikan sesi ini (regression check — tetap bersih)

| CPU | Status |
|---|---|
| Intel Core Ultra 5 125H | ✅ seragam 62/31/67/79/52 di 4 halaman + cpuBench |
| Intel Core i7-13620H | ✅ seragam 69/38/56/37/54 di 3 halaman + cpuBench |
| Intel Core Ultra 5 115U | ✅ Passmark 3.421/12.771 di 4 tempat |
| Intel Core i5-13420H | ✅ seragam 62/26/57/30/46 di 5 halaman |

---

## Temuan Baru Terbesar: 34 Laptop Tampil "No Data" di H2H

`cpuBench` hanya memuat **30 entri**, sementara array laptop `h2h.astro` memakai **53 CPU berbeda**. Akibatnya **34 dari 88 laptop (39%)** menampilkan No Data di keempat baris benchmark saat dibandingkan di H2H — padahal halaman review-nya menampilkan angka lengkap.

### Bisa langsung diisi — data sudah ada di project (20 CPU · 28 laptop)

| CPU | nano | pmS | pmM | eff | Laptop |
|---|---|---|---|---|---|
| Intel Core Ultra 7 255HX | 75 | 4.575 | 48.756 | 74 | 3 |
| Intel Core Ultra 9 275HX | 78 | 4.720 | 55.892 | 74 | 2 |
| Intel Core Ultra 9 386H | 69 | 4.177 | 35.236 | 82 | 2 |
| Intel Core Ultra 7 358H | 71 | 4.122 | 33.967 | 82 | 2 |
| Intel Core Ultra 5 226V | 55 | 3.799 | 18.028 | 74 | 2 |
| AMD Ryzen 9 7945HX | 74 | 4.024 | 54.109 | 69 | 2 |
| AMD Ryzen 9 8940HX | 70 | 3.883 | 50.289 | 76 | 2 |
| Intel Core Ultra 7 255H | 68 | 4.315 | 30.718 | 77 | 1 |
| Intel Core Ultra 5 225H | 64 | 4.263 | 28.339 | 77 | 1 |
| Intel Core Ultra 7 258V | 59 | 4.030 | 18.930 | 74 | 1 |
| Intel Core Ultra 7 355 | 60 | 4.077 | 20.547 | 82 | 1 |
| Intel Core i7-13650HX | 57 | 3.747 | 30.232 | 55 | 1 |
| Intel Core i7-14650HX | 61 | 3.848 | 33.666 | 60 | 1 |
| AMD Ryzen 7 255 | 62 | 3.717 | 28.774 | 80 | 1 |
| AMD Ryzen 7 8845HS | 61 | 3.727 | 28.378 | 73 | 1 |
| AMD Ryzen AI 7 350 | 63 | 3.839 | 24.937 | 78 | 1 |
| Apple M2 | 57 | 3.884 | 15.652 | 77 | 1 |
| Apple M4 † | 76 | 4.508 | 23.655 | 90 | 1 |
| Apple M5 † | 81 | 5.756 | 26.822 | 96 | 1 |
| Intel Core i7-14700HX † | 64 | 3.959 | 36.789 | 60 | 1 |

† **Mismatch penulisan nama**, bukan data hilang:

| Ditulis di array | Ditulis di halaman review |
|---|---|
| `Apple M4` | `Apple M4 (10-Core)` |
| `Apple M5` | `Apple M5 (10-Core)` |
| `Intel Core i7-14700HX` | `Intel Core i7 14700HX` (tanpa tanda hubung) |

### Memang belum ada datanya (4 kasus · 6 laptop)

- `Intel Core 7 240H` — 1 laptop
- `AMD Ryzen 7 6800H` — 1 laptop
- `AMD Ryzen 7 260` — 1 laptop
- `Tidak tercantum` — 3 laptop

---

## Angka Hardcoded 76 → 88

| File | Lokasi | Sebelum | Sesudah |
|---|---|---|---|
| `index.astro` | stats "Laptop Diulas" | 88 | 88 ✅ sudah benar |
| `index.astro` | CTA "Bandingkan semua … laptop" | 88 | 88 ✅ sudah benar |
| `index.astro` | kartu kategori Budget | **7** | **8** ← diperbaiki |
| `index.astro` | kartu kategori Produktivitas | **12** | **13** ← diperbaiki |
| `index.astro` | kartu kategori Gaming | **18** | **24** ← diperbaiki |
| `index.astro` | kartu kategori Ultrabook | **15** | **19** ← diperbaiki |
| `tentang.astro` | stat-num & deskripsi | 88 | 88 ✅ sudah benar |
| `compare.astro` | `result-count` | 88 | 88 ✅ sudah benar |
| `rekomendasi.astro` | "dari … pilihan" & diagnosa | 88 | 88 ✅ sudah benar |

Grep menyeluruh untuk angka `76`, `61`, `39`, `77`, `79`, `81`, `82` sebagai teks jumlah laptop: **0 sisa**.
Jumlah brand di stats (10) terverifikasi cocok dengan 10 merk berbeda di data.

---

## Uji Fungsionalitas

Dijalankan lewat simulasi browser atas hasil build.

### `/compare` — 25 pengujian, semua lolos

| Aspek | Hasil |
|---|---|
| 88 baris termuat, `result-count` awal 88 | ✅ |
| 4 bucket harga | ✅ semuanya 0 laptop tanpa harga |
| Filter kategori | ✅ Budget 8 · Produktivitas 13 · Gaming 24 · High Gaming 24 · Ultrabook 19 |
| Filter GPU / CPU / sRGB | ✅ menyaring dengan benar |
| Filter RAM | ✅ Ya 68 + Tidak 20 = 88 |
| Search nama / CPU / merk | ✅ case-insensitive, partial match |
| Kombinasi Gaming + RTX 3050 | ✅ 6 hasil |
| Reset | ✅ kembali ke 88 |
| Sort harga | ✅ 21 tanpa harga di ekor, urutan menaik benar |
| Sort Score CPU | ✅ 7 No Data di ekor, urutan menaik benar |

### `/h2h` — semua lolos

| Aspek | Hasil |
|---|---|
| Dropdown berisi 88 laptop | ✅ |
| 3 pasangan diuji (termasuk dua laptop tanpa benchmark) | ✅ 27 baris · 5 header bagian |
| Baris No Data mendapat trofi | ✅ **0 pelanggaran** di ketiga pasangan |
| Banner pemenang terisi | ✅ |
| Emoji 🏆 ter-render (bukan entity mentah) | ✅ diperiksa per text node di luar `<script>` |
| Filter budget "<8 Jt" | ✅ 88 → 9, tanpa harga dikecualikan |
| Filter GPU Dedicated / Integrated | ✅ 48 / 40 |
| Error runtime | ✅ 0 |

### `/rekomendasi` — semua lolos

| Aspek | Hasil |
|---|---|
| Gate nama + email mengunci filter | ✅ |
| 5 bar wizard | ✅ |
| Filter budget & performa | ✅ |
| Diagnosa saat 0 hasil | ✅ muncul dan menyebut kontradiksi |

### Route & aset

Ketujuh route utama ada (`/`, `/review`, `/compare`, `/h2h`, `/rekomendasi`, `/tentang`, `/hotdeals`), kelima folder kategori berisi jumlah file yang benar, **0 link internal rusak**, starfield aktif di dark mode dan tersembunyi di light mode, tema tersimpan di localStorage.

---

## Konsistensi Data (Fase 5.1)

Membandingkan `rekomendasi.astro` ↔ `compare.astro` ↔ `h2h.astro` ↔ file `.astro`:

| Aspek | Hasil |
|---|---|
| Slug termuat di keempat sumber | ✅ 88 identik, tidak ada yang kurang di mana pun |
| Kategori | ✅ 0 beda |
| CPU | ✅ 0 beda |
| Nama laptop | ⚠️ 20 variasi penulisan (kosmetik) |

Variasi nama bersifat kosmetik dan tidak memengaruhi fungsi — misalnya `Ryzen 5 7535HS` versus `R5 7535HS`, atau `Core i5-13420H` versus `i5`. Yang perlu diperhatikan hanya `ultrabook/apple-macbook-air-m2-13`, karena tanda kutip inci ditulis berbeda-beda antar sumber (`13\`, `13"`, `13&quot;`).

---

## Gaya Penulisan — 12 Laptop Terbaru

Diuji terhadap `PANDUAN-GAYA-PENULISAN.md`.

| Kriteria | Hasil |
|---|---|
| Tanpa emoji di prosa | ✅ 12/12 |
| Tanpa tanda seru | ✅ 12/12 |
| Tanpa "gue/aku/kita" | ✅ 12/12 |
| Tanpa sapaan "kamu/Anda" | ✅ 12/12 |
| Ada pola sebab "karena" | ✅ 12/12 |
| Ada tradeoff | ✅ 12/12 |
| Format angka (16 GB, 165 Hz, Rp20 juta) | ✅ 12/12 |
| Paragraf identik antar file | ✅ 0 (setelah 3 paragraf diperbaiki) |

Frasa khas: "namun tradeoffnya adalah" muncul di 11/12 · "sangat mumpuni" 4/12 · "langka untuk SKU" 4/12 · "misal pengguna" 6/12 · "pada jamannya" 0/12.

---

## Menunggu Keputusan Cahya

- [ ] **Acuan angka benchmark** untuk 5 konflik `cpuBench` vs review (Opsi A: Sheet 2/review jadi acuan · B: biarkan berbeda · C: ikuti `h2h` lama)
- [ ] **Isi 20 CPU yang hilang dari `cpuBench`** — datanya sudah ada di halaman review, akan menghilangkan No Data di 28 laptop saat dibandingkan di H2H
- [ ] **Samakan 3 penulisan nama** (`Apple M4` ↔ `Apple M4 (10-Core)`, `Apple M5`, `Intel Core i7-14700HX` ↔ `i7 14700HX`)
- [ ] **Hapus 34 kalimat prosa usang** "…dan skor benchmark akan ditambahkan menyusul" di file yang benchmark-nya sudah terisi (aturan proyek melarang mengubah prosa tanpa izin)
- [ ] **Nama CPU untuk 3 laptop** yang masih `Tidak tercantum`
- [ ] **Benchmark 3 CPU** yang belum ada datanya: Core 7 240H, Ryzen 7 6800H, Ryzen 7 260

Catatan: prompt audit menyebut 6 kalimat prosa usang. Angka sebenarnya **34** — jauh lebih banyak, karena input Sheet 2 mengisi benchmark ke lebih banyak file daripada yang tercatat.

---

## Data Kosong (catatan, bukan bug)

| Kondisi | Jumlah | Tampil di UI |
|---|---|---|
| `pmMulti: 0` | **0** | — (turun dari 7 di prompt; semua sudah terisi) |
| `bobot: 0` | 34 | tidak dipakai di sorting kecuali dijaga `> 0` |
| `harga: "—"` | 21 | "—", dikecualikan dari semua bucket harga |
| `cpu: "Tidak tercantum"` | 3 | "No Data" di H2H, tidak pernah menang |

Kedelapan guard UI diperiksa dan semuanya utuh: harga 0 dan skor kosong tampil `—`, `benchCell` mengembalikan `null` eksplisit, baris null tidak dihitung menang, sort harga dan skor menempatkan No Data di ekor, serta `efficiencyScore` menjaga `bobot > 0` dan `pmMulti > 0`.

---

## Commit Log

Perubahan yang siap di-commit (tidak menyentuh angka benchmark maupun prosa yang butuh izin):

```
fix(index): perbarui jumlah kartu kategori 7/12/18/15 -> 8/13/24/19
style(swift-air): tulis ulang 3 paragraf yang identik dengan varian Ultra 7
docs(panduan): perbarui tabel status kategori ke 88 halaman
```

---

## Status: ⚠️ WARNING

Tidak ada kerusakan fungsional — seluruh regression check lolos, semua filter dan sort bekerja benar, 0 link rusak, 0 error runtime, 0 laptop tanpa data lolos filter yang seharusnya mengecualikannya.

Status WARNING diberikan karena masih ada **6 keputusan tertunda**, dan yang paling berdampak adalah 34 laptop yang menampilkan No Data di H2H padahal datanya sudah tersedia di project. Ini tidak merusak apa pun, tapi membuat fitur perbandingan terasa jauh lebih kosong daripada seharusnya.
