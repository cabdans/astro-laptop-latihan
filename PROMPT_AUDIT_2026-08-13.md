# PROMPT AUDIT ASTROLAPTOP — 13 Agustus 2026

**Tujuan:** Audit menyeluruh AstroLaptop pada kondisi terkini, perbaiki temuan, buat summary. Toleransi kesalahan nol.

**Aturan proyek (tidak bisa ditawar):** JANGAN gunakan web search untuk spesifikasi atau benchmark laptop. Semua data hanya dari file dalam project dan file sumber yang diinput langsung oleh Cahya. Kalau data kurang atau nama tidak persis sama — tanya dulu, jangan menebak.

---

## KONDISI PROYEK SAAT INI

**Total: 88 laptop** (naik dari 76 pada audit 3 Agustus)

| Kategori | Field `kategori` | Prefix slug | File `.astro` | Status |
|----------|------------------|-------------|---------------|--------|
| Budget | 8 | `budget/` = 8 | 8 | ✅ sinkron |
| Produktivitas | 13 | `produktivitas/` = 13 | 13 | ✅ sinkron |
| Gaming | 24 | `gaming/` = 24 | 24 | ✅ sinkron |
| High Gaming | 24 | `high-gaming/` = 24 | 24 | ✅ sinkron |
| Ultrabook | 19 | `ultrabook/` = 19 | 19 | ✅ sinkron |
| **TOTAL** | **88** | **88** | **88** | ✅ |

Jumlah entri sudah seragam di tiga sumber data: `rekomendasi.astro` (88), `compare.astro` (88), `h2h.astro` (88).

### Yang sudah selesai (jadikan regression check, bukan pekerjaan ulang)

| Temuan lama | Status sekarang |
|---|---|
| Axioo Pongo 765 & 765 V2 slug di `gaming/` tapi kategori High Gaming | ✅ **SELESAI** — slug sekarang `high-gaming/axioo-pongo-765` dan `-v2`. Prefix slug = kategori untuk seluruh 88 entri |
| Laptop tanpa harga lolos filter budget di `/compare` | ✅ **SELESAI** — `applyFilters()` sudah punya `if (harga && rHarga === 0) show = false;` |
| Laptop tanpa harga lolos filter budget di `/h2h` | ✅ **SELESAI** — `matchesFilters()` sudah punya guard `semuaHarga` + `hargaNum === 0` |
| Laptop tanpa harga lolos filter budget di `/rekomendasi` | ✅ **SELESAI** — `budgetPass()` sudah punya `if (l.hMin === 0) return false;` |

Ketiga halaman kini konsisten: **21 laptop tanpa data harga** dikecualikan dari semua bucket harga spesifik, dan hanya muncul di pilihan "Semua". Angka 21 sudah cocok di `rekomendasi.astro` (`hMin:0`), `compare.astro` (`data-harga="0"`), dan `h2h.astro` (`hargaNum:0`).

---

## FASE 1: REGRESSION CHECK (WAJIB, JANGAN DILEWAT)

Empat fix di atas sudah ada di kode. Tugas fase ini memastikan tidak ada yang rusak setelah penambahan 12 laptop baru.

- [ ] `rekomendasi.astro` → `budgetPass()`: masih menolak `hMin === 0` di semua bucket kecuali tanpa filter
- [ ] `compare.astro` → `applyFilters()`: masih menolak `rHarga === 0` saat bucket harga dipilih
- [ ] `h2h.astro` → `matchesFilters()`: guard `semuaHarga` masih utuh, laptop tanpa harga tidak muncul di dropdown saat bucket spesifik aktif
- [ ] Hitung ulang laptop tanpa harga di tiga file — harus tetap **sama persis** angkanya di ketiganya
- [ ] Prefix slug = kategori untuk seluruh 88 entri (tidak ada mismatch baru dari 12 laptop tambahan)
- [ ] Jumlah entri tetap 88 di `rekomendasi.astro`, `compare.astro`, `h2h.astro`, dan folder `/review`

---

## FASE 2: KONFLIK ANGKA BENCHMARK — PRIORITAS TERTINGGI

Ini temuan terbuka terpenting, warisan dari input Sheet 2 (`INPUT_CPU_SHEET2_2026-08-10.md`). Angka benchmark **berbeda antara halaman review dan `cpuBench` di `h2h.astro`** untuk CPU yang sama. Akibatnya satu laptop bisa menampilkan skor berbeda tergantung halaman yang dibuka.

### 2.1 Empat CPU dengan angka bentrok

| CPU | Metrik bentrok | Nilai di `h2h.astro` | Nilai di halaman review / Sheet 2 |
|---|---|---|---|
| AMD Ryzen AI 7 250 | efficiency | 81 | 80 |
| Intel Core Ultra 5 125H | nano / efficiency | 53 / 68 | 52 / 67 |
| Intel Core i7-13620H | nano / eff / pmS / pmM | 55 / 60 / 3.500 / 20.000 | 54 / 56 / 3.549 / 23.398 |
| Intel Core Ultra 5 115U | Passmark Multi | 10.800 | 12.771 |

Catatan: angka i7-13620H di `h2h.astro` (3.500 / 20.000) terlihat seperti pembulatan perkiraan, bukan hasil pengukuran. Angka 115U berada di luar cakupan Sheet 2 tapi tetap bentrok.

### 2.2 Tindakan

- [ ] Verifikasi ulang keempat konflik langsung di kode (jangan percaya tabel ini mentah-mentah)
- [ ] Scan **seluruh 30 entri** `cpuBench` di `h2h.astro`, bandingkan dengan angka di halaman review masing-masing — cari konflik lain yang belum terdaftar
- [ ] Tanyakan ke Cahya sumber mana yang jadi acuan tunggal sebelum mengubah apa pun:
  - **Opsi A** — Sheet 2 jadi acuan, timpa `h2h.astro`
  - **Opsi B** — biarkan, perbedaan antar halaman tetap ada
  - **Opsi C** — samakan halaman review mengikuti angka lama `h2h.astro`
- [ ] Jangan menimpa benchmark apa pun tanpa keputusan eksplisit

---

## FASE 3: DATA MENGGANTUNG

### 3.1 Tiga laptop tanpa nama processor
- `high-gaming/asus-rog-strix-g16-g614pr-rtx5070ti`
- `high-gaming/lenovo-legion-5i-15irx10-oled-rtx5050`
- `ultrabook/acer-swift-go-14-sfg14-73p9`

- [ ] Konfirmasi ke Cahya: nama CPU-nya sudah diketahui atau tetap dibiarkan `Tidak tercantum`?
- [ ] Pastikan ketiganya tampil wajar di `/compare` dan `/h2h` (tidak crash, tidak menang di baris benchmark)

### 3.2 Mismatch nama `i7-13620H`
Sheet 2 menulis `i7-13620H`, project menulis `Intel Core i7-13620H`. File terdampak: `high-gaming/axioo-pongo-775-rtx5070`.

- [ ] Tanyakan ke Cahya apakah keduanya CPU yang sama. Kalau ya, data siap diinput: Single 69, Multi 38, Efficiency 56, iGPU 37, Final 54, Passmark 3.549 / 23.398

### 3.3 Kalimat prosa usang
Enam file target Sheet 2 masih memuat kalimat *"...dan skor benchmark akan ditambahkan menyusul"* padahal skornya sudah ada.

- [ ] Konfirmasi ke Cahya apakah 6 kalimat itu boleh dihapus (aturan proyek melarang mengubah prosa tanpa izin)

### 3.4 Data kosong yang wajar (catat saja, bukan bug)
- `pmMulti: 0` → **7 laptop** (turun drastis dari 37 setelah input Sheet 2)
- `bobot: 0` → **34 laptop**
- `harga: " - "` → **21 laptop**
- `cpu: "Tidak tercantum"` → **3 laptop**

- [ ] Pastikan keempat kondisi ini ditampilkan sebagai "No Data" / "—" di UI, bukan sebagai angka 0 yang menyesatkan
- [ ] Pastikan tidak ada yang tersortir seolah nilai terbaik/termurah karena nilainya 0

---

## FASE 4: AUDIT HALAMAN LIVE

URL: https://astro-laptop-latihan-git-main-cabdans-projects.vercel.app

### 4.1 Route
- [ ] `/` · `/review` · `/compare` · `/h2h` · `/rekomendasi` · `/tentang`
- [ ] `/review/budget/*` (8) · `/produktivitas/*` (13) · `/gaming/*` (24) · `/high-gaming/*` (24) · `/ultrabook/*` (19)

### 4.2 Angka yang harus ikut naik ke 88
Penambahan dari 76 ke 88 sering menyisakan angka lama yang hardcoded. Periksa satu per satu:
- [ ] Homepage: stats jumlah laptop, jumlah kategori, jumlah brand, teks CTA
- [ ] `/rekomendasi`: subjudul "dari **88** pilihan" (sebelumnya 76)
- [ ] `/tentang`: stats dan deskripsi kategori
- [ ] `/compare`: jumlah baris tabel dan `result-count` awal
- [ ] `/review`: jumlah total di header/filter
- [ ] Grep seluruh project untuk angka `76`, `61`, dan `39` yang tersisa sebagai teks jumlah laptop

### 4.3 Fungsionalitas
- [ ] `/review`: search (nama/CPU/merk), filter 5 kategori, semua 88 laptop bisa diklik
- [ ] `/compare`: sort tiap kolom, No Data selalu di bawah, filter Harga/GPU/CPU/RAM/sRGB/Kategori/Search, uji 3 kombinasi
- [ ] `/h2h`: dropdown searchable, filter Budget & GPU, highlight menang/kalah, total poin, uji 3 pasangan
- [ ] `/h2h`: baris ber-`numA`/`numB` bernilai `null` (No Data) tidak boleh dihitung sebagai kemenangan
- [ ] `/rekomendasi`: 5 bar wizard, logika Bar 4 (ringan/produktivitas/gaming), fallback "paling mendekati" saat 0 hasil
- [ ] Emoji render sebagai 🏆/🤝, bukan entity mentah
- [ ] Nav mobile tidak melempar ReferenceError

### 4.4 Visual
- [ ] Dark mode: starfield aktif
- [ ] Light mode: starfield hidden, teks terbaca, card hasil filter `/rekomendasi` terbaca (inline style sudah theme-aware — pastikan tidak regresi)
- [ ] Responsive 375 / 768 / 1024 / 1440 px
- [ ] Warna kategori konsisten untuk kelima kategori

### 4.5 Console
- [ ] 0 error/warning critical
- [ ] 0 failed request
- [ ] Load < 3 detik

---

## FASE 5: KONSISTENSI DATA & KONTEN

### 5.1 Cross-check (sample 25 = 5 per kategori)
Bandingkan `rekomendasi.astro` ↔ file `.astro` ↔ `compare.astro` ↔ `h2h.astro` ↔ tampilan Vercel:
- [ ] nama · cpu · gpu · ram · kategori · slug

Prioritaskan **12 laptop terbaru** yang belum pernah masuk audit sebelumnya.

### 5.2 Gaya penulisan & parafrase (sample 12 laptop terbaru)
Acuan: `PROMPT-GAYA-PENULISAN-2026.md` (sumber kebenaran).
- [ ] Bukan copy-paste spec sheet; tidak ada paragraf identik antar file
- [ ] Orang pertama "saya"; pembaca "pengguna"/"pembeli"
- [ ] Pola: klaim → "karena…" → contoh konkret → "namun tradeoffnya…"
- [ ] Frasa khas muncul: "sangat mumpuni", "pada jamannya", "namun tradeoffnya adalah…"
- [ ] Format angka: 16 GB, 165 Hz, 100% sRGB, Rp20 juta
- [ ] Setiap klaim performa disertai angka; setiap rekomendasi menyebut tradeoff
- [ ] Tanpa emoji, tanda seru, huruf kapital penekanan

### 5.3 Dokumentasi
- [ ] `PANDUAN-GAYA-PENULISAN.md`: tabel status per kategori masih menulis angka lama (7/12/20/24/15) dan total "90 halaman" — perbarui ke **8/13/24/24/19, total 88**

---

## FASE 6: PERBAIKAN & COMMIT

Untuk tiap temuan: identifikasi baris → perbaiki → uji ulang (dark+light, mobile+desktop) → commit terpisah.

```bash
cd "C:\Users\cahya\OneDrive\Documents\Claude\Projects\astro-laptop-latihan"
git add -A
git commit -m "fix(scope): deskripsi spesifik"
git push
```

Kalau muncul `index.lock`:
```bash
del ".git\index.lock"
```

**Jangan commit** perubahan pada angka benchmark atau prosa artikel sebelum Cahya memutuskan (Fase 2 dan 3.3).

---

## FASE 7: SUMMARY

Buat `AUDIT_SUMMARY_2026-08-13.md`:

```markdown
# AUDIT SUMMARY ASTROLAPTOP
**Tanggal:** 13 Agustus 2026
**Total Laptop:** 88 (Budget 8 · Produktivitas 13 · Gaming 24 · High Gaming 24 · Ultrabook 19)

## Regression Check
| Fix lama | Masih utuh? |
|---|---|
| Slug = kategori (88 entri) | ✅/❌ |
| Filter harga rekomendasi.astro | ✅/❌ |
| Filter harga compare.astro | ✅/❌ |
| Filter harga h2h.astro | ✅/❌ |

## Konflik Benchmark
| CPU | Metrik | h2h | Review | Keputusan |
|---|---|---|---|---|

## Bug Ditemukan & Diperbaiki
| Halaman | Bug | Fix | Commit |
|---|---|---|---|

## Angka Hardcoded 76 → 88
[daftar file & lokasi yang diperbarui]

## Menunggu Keputusan Cahya
- [ ] Acuan angka benchmark (Opsi A/B/C)
- [ ] Mismatch nama i7-13620H
- [ ] Penghapusan 6 kalimat prosa usang
- [ ] Nama CPU untuk 3 laptop

## Data Kosong (catatan, bukan bug)
- pmMulti 0: 7 · bobot 0: 34 · harga "-": 21 · cpu "Tidak tercantum": 3

## Commit Log
[list]

## Status: ✅ PASS / ⚠️ WARNING / ❌ FAIL
```

---

## STANDAR KUALITAS

- Nol regresi pada empat fix yang sudah ada
- Nol angka jumlah laptop yang masih 76/61/39
- Nol laptop tanpa data lolos filter yang seharusnya mengecualikannya
- Nol konflik angka benchmark yang belum terdokumentasi
- Nol typo nama laptop, nol broken link, nol console error
- Nol perubahan benchmark atau prosa tanpa izin Cahya
- Summary lengkap, jujur, dan menyebut yang masih menggantung
