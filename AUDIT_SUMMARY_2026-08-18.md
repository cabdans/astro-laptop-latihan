# AUDIT SUMMARY ASTROLAPTOP — 18 Agustus 2026

Dijalankan berdasarkan `PROMPT_AUDIT_2026-08-18.md`, 8 fase, seluruh 90 laptop.

---

## RINGKASAN EKSEKUTIF

| | Jumlah |
|---|---|
| Fase dijalankan | 8 dari 8 |
| Pemeriksaan lolos tanpa temuan | 5 fase (1, 4, 5, 6, 7 sebagian) |
| Temuan diperbaiki | **3 masalah besar**, menyentuh 35 file |
| Temuan dilaporkan tanpa diubah | 5 (butuh keputusan atau data dari Cahya) |
| Data yang hilang atau rusak | **nol** |

**Dampak terbesar:** laptop yang menampilkan "No Data" di halaman H2H turun dari **35 laptop (39%) menjadi 7 laptop (8%)**.

---

## FASE 1 — REGRESSION CHECK: LOLOS 8/8

| Pemeriksaan | Hasil |
|---|---|
| `rekomendasi.astro` menolak `hMin === 0` | PASS — `if (l.hMin === 0) return false;` |
| `compare.astro` menolak `rHarga === 0` | PASS — `if (harga && rHarga === 0) show = false;` |
| `h2h.astro` guard `semuaHarga` + `hargaNum === 0` | PASS |
| `passesAllFilters` dipanggil aman | PASS — 3 pemanggilan aman, 0 berbahaya |
| Bucket harga batas atas eksklusif | PASS — `hMin < hi && l.hMax >= lo` |
| Gate nama+email + CSS `[hidden] !important` | PASS |
| Jumlah 90 di 6 sumber data | PASS — file 90, rekomendasi 90, h2h 90, compare 90, index 90, review/index 90 |
| Prefix slug = kategori | PASS — 90/90 |

Tidak ada regresi dari penambahan laptop dan perubahan harga sepanjang 14–18 Agustus.

---

## FASE 2 — BENCHMARK: DIPERBAIKI

### Temuan

`cpuBench` di `h2h.astro` hanya punya **30 entri** sementara **54 nama CPU** dipakai laptop. Akibatnya 35 dari 90 laptop menampilkan "No Data" di seluruh baris benchmark H2H.

### Yang ternyata bukan data hilang

Pemeriksaan menemukan **20 dari 25 CPU** yang hilang itu **angkanya sudah ada di halaman review masing-masing**, hanya belum disalin ke `cpuBench`. Tiga di antaranya bahkan bukan data hilang sama sekali, melainkan **beda penulisan nama**:

| Nama di `h2h.astro` | Nama heading di halaman review |
|---|---|
| `Apple M4` | `Apple M4 (10-Core)` |
| `Apple M5` | `Apple M5 (10-Core)` |
| `Intel Core i7-14700HX` | `Intel Core i7 14700HX` (tanpa tanda hubung) |

Catatan metodologi: pencocokan pertama memakai substring dan salah mengira `Intel Core Ultra 7 255H` punya data, padahal yang cocok adalah `255HX`. Deteksi diperketat memakai heading persis `<h2>Benchmark CPU: ... </h2>`, dan angka 255H yang benar akhirnya ditemukan di file lain.

### Perbaikan

**20 entri ditambahkan ke `cpuBench`**, seluruhnya disalin verbatim dari halaman review dalam projek. Tidak ada angka yang dicari dari internet, tidak ada angka lama yang ditimpa.

```
AMD Ryzen 7 255        AMD Ryzen 7 8845HS      AMD Ryzen 9 7945HX     AMD Ryzen 9 8940HX
AMD Ryzen AI 7 350     Apple M2                Apple M4               Apple M5
Intel Core Ultra 5 225H   Intel Core Ultra 5 226V   Intel Core Ultra 7 255H
Intel Core Ultra 7 255HX  Intel Core Ultra 7 258V   Intel Core Ultra 7 355
Intel Core Ultra 7 358H   Intel Core Ultra 9 275HX  Intel Core Ultra 9 386H
Intel Core i7-13650HX     Intel Core i7-14650HX     Intel Core i7-14700HX
```

Verifikasi: `cpuBench` 30 → **50 entri**, 0 duplikat kunci, kurung kurawal seimbang 295/295.

### Konflik angka — DILAPORKAN, TIDAK DIUBAH

Empat CPU punya angka berbeda antara `cpuBench` dan halaman review. Sesuai aturan proyek, angka benchmark tidak ditimpa tanpa keputusan Cahya.

| CPU | Selisih | Nilai `h2h.astro` | Nilai halaman review |
|---|---|---|---|
| AMD Ryzen AI 7 250 | eff | 81 | 80 |
| AMD Ryzen AI 7 255 | pmS, pmM | 3.520 / 22.000 | 3.717 / 28.774 |
| Intel Core i7-13700H | pmS, pmM | 3.650 / 25.000 | 3.557 / 25.960 |
| Intel Core i7-13700HX | pmS, pmM | 3.800 / 29.500 | 3.798 / 31.788 |

Pola angka di `h2h.astro` (22.000, 25.000, 29.500) terlihat seperti pembulatan perkiraan, sementara angka halaman review lebih presisi. **Butuh keputusan Cahya sumber mana yang jadi acuan.**

---

## FASE 3 — DATA MENGGANTUNG

### 3.1 Prosa janji palsu — DIPERBAIKI

**34 halaman** memuat kalimat boilerplate "…dan skor benchmark akan ditambahkan menyusul", padahal benchmark di halaman itu **sudah ada**. Kalimat tersebut menyesatkan pembaca.

Perbaikan: klausa janji dihapus, atribusi sumber datanya dipertahankan.

> Sebelum: "Seluruh data bersumber dari datasheet AstroLaptop sheet Gaming High, dan skor benchmark akan ditambahkan menyusul."
> Sesudah: "Seluruh data bersumber dari datasheet AstroLaptop sheet Gaming High."

**3 file sengaja tidak diubah** karena benchmark-nya memang belum ada, sehingga kalimatnya masih benar: `asus-rog-strix-g16-g614pr-rtx5070ti`, `lenovo-legion-5i-15irx10-oled-rtx5050`, `acer-swift-go-14-sfg14-73p9`.

Verifikasi: file yang punya benchmark tapi masih menjanjikan **34 → 0**.

### 3.2 Harga kosong — DILAPORKAN

**16 laptop** masih berharga `" - "` atau `"—"`. Semuanya hilang dari `/compare`, `/h2h`, dan `/rekomendasi` begitu pengguna memilih rentang budget. Pemeriksaan silang menemukan **tidak satu pun** punya harga di `/hotdeals` maupun kolom `Harga Latest` di Excel, jadi datanya benar-benar belum ada.

| Kategori | Jumlah | Laptop |
|---|---|---|
| High Gaming | 11 | Predator Helios Neo 16S (3 varian), ROG Strix G16 G614PR, TUF A16 FA608UP, HP Omen (3 varian), Legion Pro 5i 16 OLED, LOQ 15AHP11, MSI Vector 16HX 275HX |
| Ultrabook | 5 | Swift 14 OLED 226V, Swift Go 14 AI SFG14-171, ExpertBook B9400CBA, ExpertBook Ultra P5405CSA, Vivobook S14 R7 260 |

### 3.3 Halaman tanpa blok benchmark — DILAPORKAN

**7 halaman** tidak punya bagian Benchmark CPU sama sekali:

| Halaman | CPU |
|---|---|
| `gaming/acer-nitro-lite-16-core7-240h-rtx4050` | Intel Core 7 240H |
| `produktivitas/axioo-hype-7-x8-r7-6800h` | AMD Ryzen 7 6800H |
| `ultrabook/asus-vivobook-s14-r7-260` | AMD Ryzen 7 260 |
| `ultrabook/hp-omnibook-3-14-core3-100u` | Intel Core 3 100U |
| `high-gaming/asus-rog-strix-g16-g614pr-rtx5070ti` | Tidak tercantum di sumber data |
| `high-gaming/lenovo-legion-5i-15irx10-oled-rtx5050` | Tidak tercantum di sumber data |
| `ultrabook/acer-swift-go-14-sfg14-73p9` | Tidak tercantum di sumber data |

### 3.4 Field "No Data" di `h2h.astro` — DILAPORKAN

| Field | Entri kosong | Catatan |
|---|---|---|
| `cooling` | 48 | lebih dari separuh |
| `tdp` | 48 | lebih dari separuh |
| `tgp` | 41 | |
| `berat` | 16 | |
| `harga` | 16 | sama dengan daftar 3.2 |
| `charger` | 15 | |
| `garansi` | 14 | |
| `baterai` | 7 | |
| `cpuMerk` | 3 | merusak badge CPU |
| `ram` | 3 | merusak perbandingan |
| `layar` | 2 | |

---

## FASE 4 — FUNGSIONALITAS: LOLOS

| Pemeriksaan | Hasil |
|---|---|
| Angka total laptop di 7 tempat | Semua **90** — index (2), compare, rekomendasi (2), tentang (2) |
| Hitungan kartu kategori di index | `[9, 13, 24, 24, 20]` cocok dengan jumlah file |
| `/hotdeals` 11 entri | Semua slug menunjuk file yang ada, 0 berharga nol |
| Kolom WIN `/h2h` | `colspan="4"`, 4 sel per baris, `row-equal` selalu "Seri" |

**Catatan:** `linkShopee` terpasang di **0 dari 90 file**, tapi tombol "Beli di Shopee" tetap tampil dengan `href="#"` karena layout memakai `shopHref = linkShopee || '#'`. Perlu keputusan Cahya.

---

## FASE 5 — KONSISTENSI DATA & GAYA

| Pemeriksaan | Hasil |
|---|---|
| Rujukan ke Axioo Pongo 755 yang dihapus | **0 temuan** — bersih |
| Harga di ringkasan vs field harga | 3 kandidat, ketiganya **positif palsu** (selisih antar varian dan rentang yang sama) |
| Klaim relatif basi | 2 kandidat, keduanya masih benar (harga naik, klaim "paling tinggi" tetap valid) |
| Gaya penulisan | `kamu` 0, `Anda` 0, `gue` 0, `aku` 0, tanda seru 0 |

### Format judul — DILAPORKAN, TIDAK DIUBAH

**12 judul** tidak menyebut dGPU-nya, menyimpang dari format `Brand + Model + Processor + GPU dedicated`. Tidak diubah karena judul dipakai sebagai kunci pencocokan dengan Excel dan antar halaman.

```
Acer Aspire 7 Pro A715 (RTX 3050)          Acer Nitro Lite NL16 (RTX 3050)
Acer Nitro V15 ANV15-42 R7 7445HS (4050)   ASUS Gaming V16 V3607VH Core 5 210H (5050)
ASUS TUF A15 FA506NCG (RTX 3050)           ASUS TUF Gaming A16 FA607NUG (RTX 4050)
Colorful Evol P15 HE55D i5-12450H (4050)   HP Victus 15 FA2717TX i5-13420H (RTX 4050)
Lenovo LOQ 15IRX10 i7-13700HX (RTX 5050)   Lenovo LOQ 15IRX10 i5-13450HX (RTX 5050)
Lenovo LOQ 15IRX9 i5-13450HX (RTX 3050)    Lenovo LOQ Essential 15ARP10E R7 7735HS (4050)
```

---

## FASE 6 — INTEGRITAS FILE: LOLOS

- 90 file review: tag `<ReviewLayout>` sepadan, atribut valid, tabel sepadan — **0 masalah**
- Kurung kurawal seimbang di 8 file kunci: rekomendasi 369/369, h2h 295/295, compare 72/72, index 232/232, review/index 161/161, hotdeals 72/72, ReviewLayout 157/157, tentang 59/59

**Build belum diuji.** `npx astro build` tidak bisa dijalankan dari sandbox Linux karena `node_modules` tidak boleh ditulis (`EPERM`). Verifikasi di atas bersifat struktural. **Cahya perlu menjalankan build sendiri sebelum push.**

---

## FASE 7 — SILANG EXCEL (DIBACA SAJA, TIDAK DIUBAH)

| Pemeriksaan | Hasil |
|---|---|
| Jumlah per kategori | Cocok 5/5 — projek = Excel = sheet kategori |
| Link affiliate Excel vs halaman review | **0 tidak cocok** |
| Harga Latest Excel vs halaman review | **0 tidak cocok** |
| Label Hot Deals vs isi `/hotdeals` | 11 = 11 |

### Satu ketidakcocokan nama

| Di Excel | Di projek |
|---|---|
| `Acer Nitro Lite NL16 3050` | `Acer Nitro Lite NL16` |

Cahya tampaknya sudah menambahkan penanda GPU di Excel. Judul di projek belum menyesuaikan. Tidak diubah karena menyentuh judul sekaligus Excel.

---

## YANG BUTUH KEPUTUSAN ATAU DATA DARI CAHYA

1. **Konflik angka benchmark 4 CPU** (Fase 2). Mana acuannya — `h2h.astro` atau halaman review?
2. **Harga 16 laptop** (Fase 3.2). Tanpa ini mereka tidak akan pernah muncul di hasil filter harga.
3. **Benchmark 5 CPU**: AMD Ryzen 7 260, AMD Ryzen 7 6800H, Intel Core 3 100U, Intel Core 7 240H, dan CPU asli untuk 3 laptop yang tertulis "Tidak tercantum".
4. **Tombol Shopee** yang tampil dengan `href="#"` di 90 halaman — disembunyikan saat link kosong, atau dibiarkan?
5. **12 judul tanpa dGPU** dan **1 ketidakcocokan nama** dengan Excel — diseragamkan atau dibiarkan?
6. **Field `cooling` dan `tdp`** kosong di 48 entri H2H — sembunyikan barisnya, atau tetap tampilkan "No Data"?

---

## PEKERJAAN TERTUNDA (di luar audit)

1. **Lenovo LOQ Essential 15ARP10E varian RTX 3050** (SKU 83S0001AID) belum dibuat. Spesifikasi sudah dikirim. Harga Agustus 2026: Shopee Rp15.254.000, Tokopedia Rp15.999.000.
2. **Entri `/hotdeals` untuk LOQ Essential** menulis "RTX 3050 6 GB" seharga Rp13,5 juta tapi menaut ke halaman varian RTX 4050 — perlu diarahkan ulang setelah halaman 3050 dibuat.

---

## REGRESSION CHECK UNTUK AUDIT BERIKUTNYA

- [ ] `cpuBench` tetap ≥ 50 entri, tidak ada duplikat kunci
- [ ] Laptop "No Data" di H2H tetap ≤ 7
- [ ] Tidak ada file yang punya benchmark tapi masih menulis "skor benchmark akan ditambahkan menyusul"
- [ ] Empat guard filter harga masih utuh di 3 halaman
- [ ] `passesAllFilters` tidak dipanggil sebagai `filter(passesAllFilters)`
- [ ] Nama CPU di entri laptop selalu persis sama dengan kunci `cpuBench` — perhatikan `255H` vs `255HX` dan tanda hubung pada seri i7
- [ ] Excel tidak pernah ditulis tanpa izin Cahya

---

## FILE YANG DIUBAH DALAM AUDIT INI

**35 file:**

- `src/pages/h2h.astro` — 20 entri `cpuBench` ditambahkan
- 34 halaman review — klausa janji benchmark dihapus (21 High Gaming, 13 Ultrabook)

Backup: `backups/audit-2026-08-18/`

Tidak ada file yang dihapus. Tidak ada angka benchmark lama yang ditimpa. Excel tidak disentuh.
