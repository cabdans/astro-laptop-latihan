# PROMPT — SINKRONISASI LOGIKA FILTER: TEMUKAN LAPTOP, PERBANDINGAN, H2H

**Tujuan:** Audit dan perbaiki logika filter di 3 halaman (`/rekomendasi`, `/compare`, `/h2h`), hapus bug yang sudah terdeteksi, lalu buat summary pekerjaan. Toleransi kesalahan nol.

---

## KONTEKS: BUG YANG SUDAH DIKONFIRMASI

**Pola bug:** laptop tanpa data harga (`hargaNum`/`hMin`/`data-harga` = 0) ikut lolos filter budget di rentang termurah, padahal harganya memang belum diketahui — bukan benar-benar murah.

**Status per halaman:**

| Halaman | File | Status | Detail |
|---------|------|--------|--------|
| Temukan Laptop | `src/pages/rekomendasi.astro` | ✅ Sudah fix | `budgetPass()` baris ~377: `if (l.hMin === 0) return false;` — sudah menolak laptop tanpa harga |
| Perbandingan | `src/pages/compare.astro` | ❌ BELUM fix | `applyFilters()` baris ~1204: filter `bawah10` hanya cek `rHarga >= 10`, tidak exclude `rHarga === 0`. **15 baris** punya `data-harga="0"` dan akan salah muncul di filter "Di bawah 10 Juta" |
| H2H | `src/pages/h2h.astro` | ❌ BELUM fix | `matchesFilters()` baris ~402: `inBudget = laptop.hargaNum >= budgetMin && laptop.hargaNum <= budgetMax` — untuk bucket manapun yang `budgetMin=0` (termasuk "Di bawah 8 Jt"), **14 laptop** dengan `hargaNum:0` akan lolos filter |

Ini bug nyata yang sudah teridentifikasi lewat pembacaan source code langsung — bukan dugaan.

---

## TAHAP 1: FIX BUG YANG SUDAH TERDETEKSI

### 1.1 Fix `compare.astro`
- Buka fungsi `applyFilters()` di `<script>` bagian bawah file
- Tambahkan pengecualian: laptop dengan `data-harga="0"` (tidak ada data harga) **tidak boleh lolos** filter harga manapun kecuali "Semua Harga"
- Pola fix mengikuti `rekomendasi.astro`: kalau `rHarga === 0` dan user memilih bucket harga tertentu → `show = false`
- Verifikasi: filter "Di bawah 10 Juta" tidak lagi menampilkan 15 laptop tanpa harga

### 1.2 Fix `h2h.astro`
- Buka fungsi `matchesFilters()`
- Tambahkan pengecualian serupa: kalau `laptop.hargaNum === 0` dan `budgetMin > 0` **atau** user memilih bucket selain "Semua" → laptop itu tidak boleh muncul di dropdown pemilihan
- Perhatikan: bucket "Semua" (`min=0, max=999`) tetap harus menampilkan laptop tanpa harga (karena user memang belum filter apa-apa)
- Verifikasi: filter "Di bawah 8 Jt" tidak lagi menampilkan 14 laptop tanpa harga di dropdown

### 1.3 Verifikasi `rekomendasi.astro` Tidak Regresi
- Cek ulang `budgetPass()` masih menolak `hMin === 0` untuk semua bucket kecuali default (tanpa filter)
- Pastikan fix di 1.1 dan 1.2 tidak mengubah pola ini secara tidak sengaja

---

## TAHAP 2: SCAN LOGIKA FILTER LAIN (CARI BUG SERUPA/BARU)

Untuk masing-masing dari 3 halaman, telusuri seluruh fungsi filter dan cek:

### Temukan Laptop (`rekomendasi.astro`)
- [ ] `passesAllFilters()`: Bar 2 (RAM), Bar 3 (Editing), Bar 4 (Performa), Bar 5 (Brand) — apakah ada field lain (selain harga) yang bisa punya nilai "kosong/0/tidak ada data" tapi lolos filter secara salah?
- [ ] `scoreClosest()` (fallback scoring): logika skor tetap konsisten dengan `passesAllFilters()`?
- [ ] `sortByPerforma()`: laptop dengan `pmMulti:0` atau `bobot:0` — apakah selalu jatuh ke posisi bawah yang wajar, bukan malah diprioritaskan karena nilai kosong dianggap 0 (rendah = bagus di beberapa logika)?

### Perbandingan (`compare.astro`)
- [ ] Filter GPU, CPU, RAM, sRGB, Kategori: apakah value `""`/kosong pada `data-*` attribute bisa false-positive lolos filter?
- [ ] Sort kolom "score": No Data sudah diletakkan di bawah — cek apakah sort kolom lain (harga, dsb) juga menangani nilai 0/kosong dengan benar, bukan ikut tersortir seolah termurah/tertinggi
- [ ] Search bar: case-insensitive dan partial match sudah benar (cek ulang, jangan asumsi)

### H2H (`h2h.astro`)
- [ ] Filter GPU (`gpuFilter`): opsi "Dedicated" vs nama GPU spesifik (RTX 5070 Ti dll) — cek exact match tidak salah exclude varian nama yang mirip
- [ ] `render()`: baris dengan `numA`/`numB` bernilai `null` (No Data) — pastikan tidak dihitung sebagai "menang" di `winsA`/`winsB`
- [ ] Dropdown A/B: setelah filter budget/GPU berubah, laptop yang sudah terpilih tapi jadi tidak match — apakah benar-benar ter-reset (bukan cuma disembunyikan tapi statenya nyangkut)

---

## TAHAP 3: HAPUS BUG YANG TERDETEKSI

Untuk setiap bug (dari Tahap 1 dan temuan baru Tahap 2):
1. Identifikasi baris & fungsi persis
2. Perbaiki logika — pola fix harus konsisten antar 3 halaman untuk kasus yang sama (mis. laptop tanpa harga diperlakukan sama di ketiganya)
3. Test manual: pilih filter yang tadinya bug, pastikan hasil sekarang benar
4. Commit per fix dengan pesan spesifik:

```bash
cd "C:\Users\cahya\OneDrive\Documents\Claude\Projects\astro-laptop-latihan"
git add -A
git commit -m "fix(compare): exclude laptop tanpa data harga dari filter rentang harga"
git commit -m "fix(h2h): exclude laptop tanpa data harga dari filter budget"
git push
```

**Aturan wajib:** JANGAN gunakan web search untuk data spesifikasi. Semua data laptop hanya dari project ini.

---

## TAHAP 4: BUAT SUMMARY

Buat file `FIX_FILTER_LOGIC_2026-08-08.md` berisi:

```markdown
# SUMMARY: SINKRONISASI LOGIKA FILTER
**Tanggal:** 8 Agustus 2026
**Halaman:** Temukan Laptop, Perbandingan, H2H

## Bug Terkonfirmasi & Diperbaiki
| Halaman | File | Bug | Fix | Commit |
|---------|------|-----|-----|--------|
| Perbandingan | compare.astro | 15 laptop tanpa harga lolos filter "Di bawah 10 Juta" | Exclude data-harga="0" | [hash] |
| H2H | h2h.astro | 14 laptop tanpa harga lolos filter budget termurah | Exclude hargaNum:0 | [hash] |

## Bug Baru Ditemukan (Tahap 2)
[daftar temuan tambahan, atau "Tidak ada temuan tambahan" kalau bersih]

## Verifikasi
- [ ] rekomendasi.astro: budgetPass() tidak regresi
- [ ] compare.astro: filter harga tidak lagi menampilkan laptop tanpa data harga
- [ ] h2h.astro: filter budget tidak lagi menampilkan laptop tanpa data harga di dropdown
- [ ] Ketiga halaman: perilaku terhadap laptop tanpa harga sekarang konsisten
- [ ] Tidak ada console error baru
- [ ] Filter lain (GPU, CPU, RAM, sRGB, kategori, search) masih berfungsi normal

## Commit Log
[list semua commit]

## Status: SELESAI / SEBAGIAN
```

---

## STANDAR KUALITAS

- Logika filter konsisten untuk kasus yang sama di 3 halaman
- Nol laptop tanpa data lolos filter yang seharusnya mengecualikannya
- Nol regresi pada fix yang sudah ada sebelumnya
- Nol console error baru
- Commit history jelas per fix
- Summary lengkap dan akurat
