# PROMPT AUDIT ASTROLAPTOP — 18 Agustus 2026

**Tujuan:** Audit menyeluruh AstroLaptop pada kondisi terkini, perbaiki temuan, tulis summary. Toleransi kesalahan nol.

---

## ATURAN PROYEK (TIDAK BISA DITAWAR)

1. **JANGAN gunakan web search** untuk spesifikasi atau benchmark laptop. Semua data hanya dari file dalam project dan file sumber yang diinput langsung oleh Cahya. Kalau data kurang atau nama tidak persis sama — **tanya dulu, jangan menebak**.
2. **JANGAN edit `LAPTOP_TANPA_LINK_AFFILIATE.xlsx` tanpa persetujuan Cahya.** File itu milik pribadi Cahya, boleh dibaca, tidak boleh ditulis tanpa izin eksplisit. Pernah terhapus karena di-regenerate.
3. **Jangan menimpa angka benchmark** tanpa keputusan eksplisit dari Cahya.
4. **Selalu backup sebelum mengubah** — simpan ke `backups/<nama-tugas>/` dengan timestamp.
5. **Setiap penggantian teks wajib diverifikasi ketemu tepat 1×.** Kalau 0 atau >1, laporkan, jangan tebak.
6. Format judul artikel: `Brand + Model + Tipe Processor + Tipe GPU`. GPU hanya ditulis kalau dedicated. Kata "Laptop" tidak ditulis.
7. Gaya penulisan mengikuti `PROMPT-GAYA-PENULISAN-2026.md` (sumber kebenaran) dan `PANDUAN-GAYA-PENULISAN.md`.

---

## KONDISI PROYEK SAAT INI

**Total: 90 laptop** (naik dari 88 pada audit 13 Agustus)

| Kategori | File `.astro` | Excel `Semua` | Sheet kategori | Status |
|---|---|---|---|---|
| Budget | 9 | 9 | 9 | sinkron |
| Produktivitas | 13 | 13 | 13 | sinkron |
| Gaming | 24 | 24 | 24 | sinkron |
| High Gaming | 24 | 24 | 24 | sinkron |
| Ultrabook | 20 | 20 | 20 | sinkron |
| **TOTAL** | **90** | **90** | **90** | sinkron |

Enam sumber data sudah seragam di angka 90: `rekomendasi.astro`, `h2h.astro`, `compare.astro`, `index.astro`, `review/index.astro`, folder `/review`.

### Perubahan sejak audit 13 Agustus

| Perubahan | Keterangan |
|---|---|
| +3 laptop baru | Polytron Luxia Ryzen 5 7430U, HP Victus 15 i5-13420H RTX 3050, HP OmniBook 3 14 Core 3 100U |
| −1 laptop | Axioo Pongo 755 R7 255 RTX 5050 dihapus atas keputusan Cahya (dianggap duplikat X72). Backup di `backups/hapus-duplikat-pongo755/` |
| Harga 18 laptop Budget + Produktivitas | Diubah dari rentang jadi harga tunggal sesuai Excel, plus 89 penggantian teks prosa |
| Harga + link 6 laptop Gaming | Nitro Lite 16 (2 varian), Nitro V15 ANV15-42, TUF A15, TUF A16 FA608UH, TUF Gaming A16 |
| Prop baru `hargaUpdate` | Badge `[ Harga Agustus 2026 ]` di header, dipakai 27 file |
| Ringkasan Cepat | Dulu 2 kalimat hardcoded sama untuk semua halaman, sekarang diturunkan dari `kategori` + bisa dioverride lewat prop `cocokUntuk` / `kurangUntuk` |
| Tabel spek direstyle | `table-layout: fixed`, label monospace, kolom nilai kontras. Isi tabel tidak berubah |
| Kolom WIN di `/h2h` | Kolom keempat berisi chip Laptop A / Laptop B / Seri |
| Kolom Status di Excel | Cahya memakai label `Hot Deals`, `Not Worth`, `Rare`, `Discount` |

### Yang sudah selesai — jadikan regression check, bukan pekerjaan ulang

| Temuan lama | Status |
|---|---|
| Laptop tanpa harga lolos filter budget di `/compare`, `/h2h`, `/rekomendasi` | SELESAI — ketiga guard masih ada |
| Slug prefix tidak cocok dengan kategori | SELESAI — 90/90 cocok |
| Harga tidak konsisten antar halaman | SELESAI 18 Agustus — audit 90 laptop, 0 tidak konsisten |
| Laptop Hot Deals hilang dari filter harga | SELESAI — Acer Swift Go 14 AI SFG14-73 diisi Rp18.500.000, 11/11 lolos |

---

## FASE 1 — REGRESSION CHECK (WAJIB)

- [ ] `rekomendasi.astro` → `budgetPass()`: masih menolak `hMin === 0` di semua bucket kecuali "Semua"
- [ ] `compare.astro` → `applyFilters()`: masih menolak `rHarga === 0` saat bucket harga dipilih
- [ ] `h2h.astro` → `matchesFilters()`: guard `semuaHarga` + `hargaNum === 0` masih utuh
- [ ] `passesAllFilters` di `rekomendasi.astro` dipanggil sebagai `filter(l => passesAllFilters(l))`, **bukan** `filter(passesAllFilters)` (pernah bug: index masuk sebagai argumen kedua)
- [ ] Bucket harga memakai batas atas eksklusif `l.hMin < hi && l.hMax >= lo`
- [ ] Gate nama+email di `/rekomendasi` masih memblokir 5 pertanyaan sebelum diisi; CSS `[hidden] { display:none !important }` masih ada
- [ ] Jumlah tetap 90 di enam sumber, prefix slug = kategori untuk 90/90
- [ ] Harga konsisten antar review / rekomendasi / h2h / compare / index (toleransi 0,35 juta untuk rentang)

---

## FASE 2 — BENCHMARK: 25 CPU TANPA DATA (PRIORITAS TERTINGGI)

`cpuBench` di `h2h.astro` punya **30 entri**, sementara **54 nama CPU** dipakai di seluruh entri laptop. Akibatnya **35 dari 90 laptop (39%)** menampilkan "No Data" di halaman H2H.

### 2.1 CPU yang dipakai laptop tapi tidak ada di `cpuBench`

```
AMD Ryzen 7 255            AMD Ryzen 7 260            AMD Ryzen 7 6800H
AMD Ryzen 7 8845HS         AMD Ryzen 9 7945HX         AMD Ryzen 9 8940HX
AMD Ryzen AI 7 350         Apple M2                   Apple M4
Apple M5                   Intel Core 3 100U          Intel Core 7 240H
Intel Core Ultra 5 225H    Intel Core Ultra 5 226V    Intel Core Ultra 7 255H
Intel Core Ultra 7 255HX   Intel Core Ultra 7 258V    Intel Core Ultra 7 355
Intel Core Ultra 7 358H    Intel Core Ultra 9 275HX   Intel Core Ultra 9 386H
Intel Core i7-13650HX      Intel Core i7-14650HX      Intel Core i7-14700HX
Tidak tercantum
```

### 2.2 Tindakan

- [ ] Verifikasi ulang daftar di atas langsung dari kode, jangan percaya tabel ini mentah-mentah
- [ ] Cek apakah sebagian angka sudah ada di halaman review masing-masing tapi belum disalin ke `cpuBench` — kalau ada, itu pekerjaan menyalin, bukan mencari data baru
- [ ] Untuk CPU yang benar-benar belum punya data, **buat daftar permintaan ke Cahya**, jangan cari sendiri di internet
- [ ] `"Tidak tercantum"` bukan nama CPU. Cari 3 laptop yang memakainya dan tanyakan nama CPU sebenarnya ke Cahya
- [ ] Entri `AMD Ryzen AI 5 220` ada di `cpuBench` tapi tidak dipakai laptop mana pun — konfirmasi apakah sisa laptop yang dihapus, atau persiapan laptop yang belum masuk

### 2.3 Konflik angka (warisan audit sebelumnya — pastikan sudah tuntas)

- [ ] Scan **seluruh 30 entri** `cpuBench`, bandingkan dengan angka di halaman review masing-masing
- [ ] Konflik yang pernah tercatat: Ryzen AI 7 250 (eff 81 vs 80), Ultra 5 125H (53/68 vs 52/67), i7-13620H (55/60/3.500/20.000 vs 54/56/3.549/23.398), Ultra 5 115U (pmM 10.800 vs 12.771)
- [ ] Kalau masih bentrok, **tanya Cahya sumber acuannya dulu** sebelum menimpa apa pun

---

## FASE 3 — DATA MENGGANTUNG

### 3.1 Harga kosong: 16 laptop

Semua laptop ini hilang dari `/compare`, `/h2h`, dan `/rekomendasi` begitu pengguna memilih rentang budget — perilaku ini memang disengaja, tapi 16 laptop tidak akan pernah muncul di hasil filter.

| Kategori | Jumlah |
|---|---|
| High Gaming | 11 |
| Ultrabook | 5 |

- [ ] Kumpulkan daftar 16 slug tersebut
- [ ] Cek apakah harganya tersedia di tempat lain dalam projek (entri `/hotdeals`, Excel kolom `Harga Latest`) sebelum bertanya
- [ ] Sisanya buat daftar permintaan harga ke Cahya

### 3.2 Prosa menggantung

| Pola | Jumlah file |
|---|---|
| "akan ditambahkan menyusul" | 40 |
| "skor benchmark akan ditambahkan" | 37 |
| "belum tersedia" | 34 |
| "Tidak tercantum" | 6 |

- [ ] Untuk file yang benchmark-nya **sudah ada**, kalimat janji tersebut harus dihapus — sekarang menyesatkan
- [ ] Untuk file yang benchmark-nya memang belum ada, kalimat boleh tetap
- [ ] Periksa satu per satu, jangan hapus massal

### 3.3 Field "No Data" di `h2h.astro`

| Field | Jumlah entri |
|---|---|
| `cooling` | 48 |
| `tdp` | 48 |
| `tgp` | 41 |
| `berat` | 16 |
| `harga` | 16 |
| `charger` | 15 |
| `garansi` | 14 |
| `baterai` | 7 |
| `cpuMerk` | 3 |
| `ram` | 3 |
| `layar` | 2 |

- [ ] `cpuMerk`, `ram`, dan `layar` kosong adalah yang paling merusak tampilan H2H karena dipakai untuk badge dan perbandingan — prioritaskan
- [ ] `tdp` dan `cooling` kosong di lebih dari separuh entri; tanyakan ke Cahya apakah dua baris ini sebaiknya disembunyikan saja daripada menampilkan "No Data" berjejer

### 3.4 Halaman review tanpa blok benchmark: 4 file

```
high-gaming/asus-rog-strix-g16-g614pr-rtx5070ti.astro
high-gaming/lenovo-legion-5i-15irx10-oled-rtx5050.astro
ultrabook/acer-swift-go-14-sfg14-73p9.astro
ultrabook/hp-omnibook-3-14-core3-100u.astro
```

- [ ] Konfirmasi apakah keempatnya memang belum punya data, atau blok benchmarknya hilang saat penyuntingan

---

## FASE 4 — FUNGSIONALITAS & ANGKA HARDCODED

- [ ] Angka total laptop (90) muncul di `index.astro` (2 tempat + kartu statistik), `compare.astro`, `rekomendasi.astro` (2 tempat), `tentang.astro` (2 tempat). Pastikan **semuanya 90**, tidak ada sisa 88/89/91
- [ ] Hitungan per kategori di kartu `index.astro` cocok dengan jumlah file: 9 / 13 / 24 / 24 / 20
- [ ] `/hotdeals`: 11 entri, semua slug menunjuk file yang ada, semua punya harga > 0 di compare & h2h
- [ ] Tombol Beli: 34 file punya `linkTokopedia`, **0 file punya `linkShopee`**. Cek apakah tombol Shopee tetap tampil dengan `href="#"` — kalau ya, tanyakan ke Cahya apakah tombol itu sebaiknya disembunyikan saat link kosong
- [ ] Prop `cocokUntuk` / `kurangUntuk` belum dipakai satu file pun. Cek apakah default per kategori sudah tepat untuk semua 90 laptop, terutama laptop yang karakternya menyimpang dari kategorinya
- [ ] Kolom WIN di `/h2h`: baris `row-equal` harus selalu "Seri"; baris dengan `numA === numB` juga "Seri"; jumlah chip A + chip B harus sama dengan angka di kartu "N unggul"
- [ ] `diagnosaKosong()` di `/rekomendasi` menyebut angka total laptop — pastikan ikut 90

---

## FASE 5 — KONSISTENSI DATA & GAYA PENULISAN

- [ ] **Format judul**: 90 judul mengikuti `Brand + Model + Processor + GPU dedicated`. Catat yang menyimpang, jangan langsung diubah — perubahan judul memutus pencocokan dengan Excel
- [ ] **Nama CPU dan GPU** ditulis konsisten antara `spek-table`, `h2h`, `compare`, dan prosa
- [ ] **Harga di prosa** cocok dengan field `harga`. Hati-hati: banyak penyebutan harga merujuk laptop **lain** sebagai pembanding — jangan diganti
- [ ] **Klaim relatif yang basi**: kalimat seperti "paling murah di kelasnya" atau "biasanya baru ada di Rp10 juta" bisa jadi salah setelah harga diperbarui. Periksa 24 laptop yang harganya berubah pada 14–18 Agustus
- [ ] **Rujukan ke laptop yang sudah dihapus**: pastikan tidak ada lagi yang menyebut "Axioo Pongo 755" non-X72
- [ ] Gaya: orang pertama "saya", pembaca "pengguna"/"pembeli", ada tradeoff di tiap rekomendasi, tanpa tanda seru, angka spesifik

---

## FASE 6 — INTEGRITAS FILE & BUILD

- [ ] Setiap `.astro` review: tepat 1 `<ReviewLayout>` dan 1 `</ReviewLayout>`, atribut berpola `nama="..."` atau `nama={...}`, kutip seimbang
- [ ] Tanda kutip di dalam nilai atribut sudah di-escape (`layar:"15.6\" FHD"`) — pernah membuat build gagal
- [ ] Kurung kurawal seimbang di `rekomendasi.astro`, `h2h.astro`, `compare.astro`, `index.astro`, `review/index.astro`, `hotdeals.astro`, `ReviewLayout.astro`
- [ ] Blok `<script>` di `h2h.astro` dan `compare.astro` lolos parse
- [ ] Jalankan `npx astro build`. **Catatan:** build tidak bisa dijalankan dari sandbox Linux karena `node_modules` tidak boleh ditulis — mintakan Cahya menjalankannya, atau verifikasi secara struktural dan katakan apa adanya bahwa build belum diuji

---

## FASE 7 — SILANG DENGAN EXCEL (BACA SAJA)

`LAPTOP_TANPA_LINK_AFFILIATE.xlsx` — kolom: Laptop, Kategori, Link Affiliate, Harga Latest, Status.

- [ ] Jumlah baris per kategori cocok dengan jumlah file `.astro`
- [ ] Setiap nama di Excel punya padanan judul di projek, dan sebaliknya
- [ ] Link affiliate di Excel sudah terpasang di halaman review yang bersangkutan
- [ ] `Harga Latest` di Excel cocok dengan field `harga` di halaman review
- [ ] Baris berlabel `Hot Deals` cocok dengan isi `/hotdeals`
- [ ] **Semua temuan dilaporkan sebagai daftar, jangan sekali-kali menulis ke file Excel**

---

## FASE 8 — SUMMARY

Tulis `AUDIT_SUMMARY_2026-08-18.md` berisi:

1. Ringkasan eksekutif: berapa temuan, berapa yang diperbaiki, berapa yang butuh keputusan Cahya
2. Tabel temuan: kategori masalah, jumlah, tingkat keparahan, status
3. Daftar perbaikan beserta bukti verifikasi (jumlah penggantian, hasil sebelum/sesudah)
4. **Daftar pertanyaan untuk Cahya** — data yang kurang, konflik yang butuh keputusan, hal yang sengaja tidak disentuh
5. Regression check untuk audit berikutnya

**Aturan pelaporan:** kalau sebuah pemeriksaan tidak bisa dijalankan (misalnya build), tulis apa adanya bahwa pemeriksaan itu tidak dilakukan. Jangan mengarang hasil, jangan menyatakan "sudah diverifikasi" untuk hal yang cuma diasumsikan.

---

## PEKERJAAN TERTUNDA (di luar audit, konfirmasi dulu ke Cahya)

1. **Lenovo LOQ Essential 15ARP10E varian RTX 3050** (SKU 83S0001AID) belum dibuat. Spesifikasi sudah dikirim Cahya. Varian RTX 4050 sudah ada di projek. Harga Agustus 2026: Shopee Rp15.254.000, Tokopedia Rp15.999.000
2. **Entri `/hotdeals` untuk LOQ Essential** menulis "RTX 3050 6 GB" dengan harga Rp13,5 juta, tapi menaut ke halaman varian RTX 4050 — perlu diarahkan ke halaman varian 3050 setelah dibuat, dan harganya diperbarui
