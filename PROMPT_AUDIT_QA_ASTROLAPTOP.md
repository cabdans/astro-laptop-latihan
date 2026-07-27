# PROMPT AUDIT & QA KOMPREHENSIF ASTROLAPTOP

**Tujuan:** Audit menyeluruh website AstroLaptop untuk menemukan ketidaksinkronan, bug, dan error, kemudian langsung revisi dengan toleransi kesalahan NOL.

**Total Laptop: 76** (Budget: 8 | Produktivitas: 8 | Gaming: 21 | High Gaming: 19 | Ultrabook: 15)

---

## FASE 1: AUDIT LAMAN VERCEL

### 1.1 Cek Semua Halaman Live
- Kunjungi: https://astro-laptop-latihan-git-main-cabdans-projects.vercel.app
- Test setiap halaman:
  - `/` (Homepage)
  - `/review` (Daftar Review)
  - `/review/budget/*` (Halaman Budget Individual)
  - `/review/produktivitas/*` (Halaman Produktivitas Individual)
  - `/review/gaming/*` (Halaman Gaming Individual)
  - `/review/high-gaming/*` (Halaman High Gaming Individual)
  - `/compare` (Tabel Perbandingan)
  - `/h2h` (Head-to-Head)
  - `/rekomendasi` (Filter Rekomendasi)
  - `/tentang` (Halaman Tentang)

### 1.2 Cek Fungsionalitas Setiap Halaman
**Homepage:**
- Stats section muncul dengan benar
- Kategori cards terlihat (Budget, Produktivitas, Gaming, High Gaming)
- Recent reviews grid render dengan benar
- Light/Dark mode toggle berfungsi
- Responsive design di mobile/tablet/desktop

**Review Index (/review):**
- Search bar berfungsi (filter by nama, CPU, merk)
- Filter buttons category berfungsi (Budget, Produktivitas, Gaming, High Gaming, Ultrabook)
- List item muncul dengan warna border yang benar per kategori
- Rating badge dan harga muncul
- Semua 76 laptop tersedia dan dapat diklik

**Halaman Individual Review:**
- Setiap halaman laptop load dengan benar
- Spec section lengkap (CPU, GPU, RAM, storage, layar, berat, kategori)
- Benchmark section tampil jika ada data CPU
- CSS styling konsisten
- Navigasi kembali ke review index berfungsi

**Compare (/compare):**
- Tabel load semua 76 laptop
- Kolom sortable berfungsi
- Score CPU badge muncul dengan benar (biru/italic)
- Filter berfungsi (Harga, GPU, CPU, RAM, sRGB, Kategori, Search)

**H2H (/h2h):**
- Dropdown searchable berfungsi
- Filter Budget & GPU berfungsi
- Perbandingan 2 laptop menampilkan dengan benar
- Highlight menang/kalah per baris berfungsi
- Total poin dan kesimpulan otomatis muncul

**Filter Rekomendasi (/rekomendasi):**
- 5 langkah wizard berfungsi
- Filter Bar 1 (Budget) berfungsi
- Filter Bar 2 (Upgrade) berfungsi
- Filter Bar 3 (Kebutuhan) berfungsi
- Filter Bar 4 (Performa) berfungsi dengan logika yang benar
- Filter Bar 5 (Preferensi) berfungsi
- Cards result render dengan inline styles yang benar
- Light mode: cards harus terlihat jelas (check color contrast)

### 1.3 Cek Visual & Styling
- Dark mode: starfield canvas aktif, warna sesuai
- Light mode: warna terang, text readable, starfield tersembunyi
- Gradient colors per kategori konsisten di semua halaman
- Responsive: test di width 375px, 768px, 1024px, 1440px
- Font sizing readable di semua ukuran layar
- Spacing/padding konsisten

### 1.4 Cek Console Errors di Browser
- Network tab: tidak ada failed requests (404, 500, etc)
- Console: tidak ada error/warning yang critical
- Performance: page load time < 3 detik

---

## FASE 2: AUDIT SOURCE CODE

### 2.1 Struktur Folder src/pages/review/
```
src/pages/review/
  ├── index.astro
  ├── budget/
  │   ├── [8 file .astro untuk 8 laptop budget]
  ├── produktivitas/
  │   ├── [8 file .astro untuk 8 laptop produktivitas]
  ├── gaming/
  │   ├── [21 file .astro untuk 21 laptop gaming]
  ├── high-gaming/
  │   ├── [19 file .astro untuk 19 laptop high gaming]
  └── ultrabook/
      └── [15 file .astro untuk 15 laptop ultrabook]
```
- Cek: apakah struktur folder sesuai dengan yang ada?
- Cek: jumlah file .astro di masing-masing kategori:
  - Budget: 8 file
  - Produktivitas: 8 file
  - Gaming: 21 file
  - High Gaming: 19 file
  - Ultrabook: 15 file
  - **Total: 76 file**
- Cek: apakah nama file mengikuti kebab-case?

### 2.2 Audit Data di rekomendasi.astro
- Buka: `src/pages/rekomendasi.astro`
- Cek array laptop:
  - Jumlah total laptop harus 76
  - Setiap entry punya field lengkap: slug, nama, harga, kategori, cpu, gpu, ram, srgb, ramUp, gpuDed, lokal, gpuTgp, gpuVram, bobot, pmMulti
  - Slug harus cocok dengan nama file .astro masing-masing laptop
  - hMin/hMax konsisten dengan kategori budget
  - Kategori hanya: "Budget" | "Produktivitas" | "Gaming" | "High Gaming" | "Ultrabook" (case-sensitive)

### 2.3 Cek Konsistensi Nama Laptop
- Cross-check antara:
  - Nama di rekomendasi.astro
  - Nama di file individual .astro
  - Nama yang ditampilkan di website vercel
- Cari kesalahan: typo, capitalization, spasi, apostrophe
- Contoh error yang sering terjadi:
  - "Lenovo IdeaPad Slim 3" vs "Lenovo ideapad slim 3"
  - "ASUS" vs "Asus"
  - Tanda dash vs hyphen

### 2.4 Cek Data CPU
- Setiap laptop punya field `cpu` yang terisi
- CPU yang valid harus ada di file benchmark (atau marked as "No Data")
- Contoh: jika `cpu: "Intel Core i5-13420H"`, pastikan ada di section benchmark atau ditandai "No Data"

### 2.5 Cek Data GPU untuk Gaming Laptop
- Gaming & High Gaming laptop harus punya `gpu` terisi
- Budget & Produktivitas laptop boleh punya `gpu: ""` atau tidak ada GPU dedicated
- `gpuTgp` dan `gpuVram` harus terisi untuk yang ada dedicated GPU
- `gpuDed: true` untuk yang punya GPU dedicated, `false` untuk yang tidak

### 2.6 Cek Kategori Laptop
- Budget: harga Rp 6-8 juta, tidak ada GPU dedicated (8 laptop)
- Produktivitas: harga Rp 7-12 juta, tidak ada GPU dedicated (8 laptop)
- Gaming: harga Rp 12-26 juta, ada GPU dedicated RTX 3050-5050 (21 laptop)
- High Gaming: harga Rp 19-31 juta, GPU RTX 5050 ke atas (5060, 5070, 5070 Ti, 5080) (19 laptop)
- Ultrabook: harga Rp 10-27 juta, thin & light, integrated GPU, fokus portabilitas (15 laptop)
- Verifikasi: apakah semua 76 laptop sudah termasuk kategori yang tepat?

### 2.7 Cek Field Opsional
- `bobot`: jika 0, tandai bahwa data tidak tersedia
- `pmMulti`: jika 0, tandai bahwa benchmark tidak ada
- `ramUp`: true/false sesuai spesifikasi
- `srgb`: true/false sesuai spesifikasi
- `lokal`: true/false sesuai merek (lokal Indonesia atau tidak)

---

## FASE 3: AUDIT FOLDER LOKAL

### 3.1 Cek File Review Individual
- Buka folder: `C:\Users\cahya\OneDrive\Documents\Claude\Projects\astro-laptop-latihan\src\pages\review`
- Setiap file .astro harus punya struktur:
  ```astro
  ---
  import ReviewLayout from '../../layouts/ReviewLayout.astro';
  
  const laptop = {
    nama: "...",
    slug: "/review/[kategori]/[nama]",
    kategori: "...",
    cpu: "...",
    gpu: "...",
    ram: "...",
    storage: "...",
    layar: "...",
    srgb: true/false,
    bobot: 0,
    ...
  };
  ---
  
  <ReviewLayout>
    <!-- Content -->
  </ReviewLayout>
  ```

### 3.2 Verifikasi Slug Path
- Budget laptop: slug harus `/review/budget/[kebab-case]`
- Produktivitas laptop: slug harus `/review/produktivitas/[kebab-case]`
- Gaming laptop: slug harus `/review/gaming/[kebab-case]`
- High Gaming laptop: slug harus `/review/high-gaming/[kebab-case]`
- Ultrabook laptop: slug harus `/review/ultrabook/[kebab-case]`
- Pastikan slug cocok dengan file path-nya (76 total)

### 3.3 Cek Data di Setiap File .astro
- Pastikan tidak ada field yang kosong atau undefined
- Jika data tidak ada, gunakan 0 atau string kosong `""`
- CPU dan GPU harus valid dan konsisten dengan rekomendasi.astro

### 3.4 Cek Git Status
- Apakah ada file yang staged as deleted tapi masih ada?
- Apakah ada .git/index.lock? (bersihkan jika ada)
- Apakah ada uncommitted changes yang seharusnya di-commit?

---

## FASE 4: TEMUKAN KETIDAKSINKRONAN

### 4.1 Cross-Check Nama Laptop
| Source | Jumlah | Nama yang Berbeda |
|--------|--------|-------------------|
| rekomendasi.astro | 76 | ? |
| Folder /review | 76 | ? |
| Website Vercel | 76 | ? |

- Breakdown: Budget (8) + Produktivitas (8) + Gaming (21) + High Gaming (19) + Ultrabook (15) = 76
- Cari laptop yang ada di satu tempat tapi tidak di tempat lain
- Cari typo atau naming inconsistency

### 4.2 Cross-Check Data Laptop
- Ambil 5 laptop random dari setiap kategori (minimal):
  - Budget: 5 dari 8
  - Produktivitas: 5 dari 8
  - Gaming: 5 dari 21
  - High Gaming: 5 dari 19
  - Ultrabook: 5 dari 15
- Cek: apakah data di rekomendasi.astro sama dengan data di file .astro individual?
- Contoh check per laptop:
  - Nama: sama?
  - CPU: sama?
  - GPU: sama?
  - RAM: sama?
  - Kategori: sama?
  - Slug: cocok dengan path file?

### 4.3 Cross-Check Slug
- Setiap laptop di rekomendasi.astro punya slug
- Cek: apakah slug itu benar-benar ada di folder /review?
- Cek: apakah file .astro di folder /review terdaftar di rekomendasi.astro?

### 4.4 Cek Badge & Filter
- Gaming laptop: apakah punya TGP badge di website?
- Produktivitas laptop: apakah tidak punya GPU badge?
- Budget laptop: apakah budget range benar di filter?
- High Gaming laptop: apakah muncul di kategori High Gaming?

---

## FASE 5: CARI BUG DI VERCEL

### 5.1 Broken Links
- Setiap link di halaman harus berfungsi
- Test: klik setiap navigation link, pastikan tidak 404
- Test: setiap laptop di review index bisa di-klik ke halaman individual
- Test: breadcrumb/back button berfungsi

### 5.2 Filter Bugs
- Coba kombinasi filter di /review, /compare, /h2h, /rekomendasi
- Pastikan hasil filter yang ditampilkan benar
- Pastikan tidak ada laptop yang hilang atau duplikat
- Coba filter edge cases: "semua", "kosong", "satu item"

### 5.3 Search Bugs
- Coba search dengan keyword yang ada (nama, CPU, merk)
- Coba search yang tidak ada (should show "No results")
- Case sensitivity: "ASUS" vs "asus" harus sama hasilnya
- Partial search: mencari "Lenovo" harus muncul semua Lenovo

### 5.4 Data Display Bugs
- Cek: apakah semua field ditampilkan dengan benar?
- Cek: apakah tidak ada HTML entities yang tidak ter-decode (misal &amp; instead of &)?
- Cek: apakah angka (harga, score) terformat dengan benar?

### 5.5 Responsive Bugs
- Mobile (375px): semua elemen terlihat, tidak ada overflow
- Tablet (768px): layout rapi, tidak ada shift unexpected
- Desktop (1440px): spacing konsisten, tidak ada blank space berlebihan

### 5.6 Dark/Light Mode Bugs
- Dark mode: starfield aktif, text readable
- Light mode: cards terlihat jelas, tidak ada text yang hilang
- Toggle: pergantian mode smooth, data tidak berubah
- Persistence: saat refresh, mode yang dipilih tetap aktif

---

## FASE 6: REVISI KESALAHAN (LANGSUNG LAKUKAN)

### 6.1 Jika Ada Typo Nama Laptop
- Buka file .astro yang salah
- Update nama di:
  1. File .astro individual (field `nama`)
  2. rekomendasi.astro (di array laptop)
  3. Commit & push

### 6.2 Jika Ada Ketidaksinkronan Data
- Tentukan sumber data yang benar (biasanya rekomendasi.astro adalah master)
- Update file .astro individual untuk sinkron dengan master
- Commit & push

### 6.3 Jika Ada Bug Filter/Search
- Cek: logic di halaman yang mana (rekomendasi.astro, compare.astro, h2h.astro)?
- Debug: cek filter logic di JavaScript section
- Perbaiki logic jika ada error
- Test ulang filter
- Commit & push

### 6.4 Jika Ada Styling Bug
- Cek: apakah CSS class diterapkan dengan benar?
- Cek: apakah inline style sudah di-update untuk light mode?
- Perbaiki CSS di Astro <style> block atau inline style
- Test ulang di light & dark mode
- Commit & push

### 6.5 Jika Ada Broken Link
- Tentukan link yang mana
- Cek: slug di rekomendasi.astro benar?
- Cek: file .astro untuk laptop itu ada?
- Cek: slug di file .astro sama dengan slug di rekomendasi.astro?
- Perbaiki jika ada mismatch
- Commit & push

---

## FASE 7: BUAT FILE SUMMARY

### 7.1 Buat File: AUDIT_SUMMARY_[DATE].md
Isi file:

```markdown
# AUDIT & QA SUMMARY ASTROLAPTOP
**Tanggal Audit:** [Date]
**Auditor:** [AI/Claude]
**Status Keseluruhan:** ✅ PASS / ⚠️ WARNING / ❌ FAIL

## 1. TEMUAN VERCEL LIVE

### Halaman yang Ditest:
- [ ] Homepage
- [ ] /review (Index)
- [ ] /review/budget/* (Individual)
- [ ] /review/produktivitas/* (Individual)
- [ ] /review/gaming/* (Individual)
- [ ] /review/high-gaming/* (Individual)
- [ ] /compare
- [ ] /h2h
- [ ] /rekomendasi
- [ ] /tentang

### Bugs Ditemukan:
1. [Bug 1]: Deskripsi
   - Lokasi: [halaman/elemen]
   - Status: ✅ Fixed / ⏳ Pending
   
2. [Bug 2]: Deskripsi
   - Lokasi: [halaman/elemen]
   - Status: ✅ Fixed / ⏳ Pending

### Total Bugs: X | Fixed: Y | Pending: Z

---

## 2. TEMUAN SOURCE CODE

### Data Integrity:
- Total laptop di rekomendasi.astro: 76
- Total file .astro di folder: 76
- Breakdown: Budget (8) | Produktivitas (8) | Gaming (21) | High Gaming (19) | Ultrabook (15)
- ✅ Jumlah cocok / ⚠️ Ada mismatch

### Ketidaksinkronan:
1. Laptop yang ada di rekomendasi.astro tapi tidak ada file .astro:
   - [Daftar laptop]
   
2. Laptop yang ada file .astro tapi tidak di rekomendasi.astro:
   - [Daftar laptop]
   
3. Nama yang berbeda antara rekomendasi.astro vs file .astro:
   - [Laptop X]: "Nama A" vs "Nama B" → ✅ Fixed to "Nama Benar"

### Slug Issues:
- Total slug yang tidak match dengan file path: X
- Daftar:
  - [Slug A] → File: [File A] → ✅ Fixed

### Data Consistency:
- Sample check (5 laptop per kategori): ✅ All Pass / ⚠️ [X] error
- Errors:
  - [Laptop X]: CPU mismatch → ✅ Fixed
  - [Laptop Y]: GPU mismatch → ✅ Fixed

---

## 3. TEMUAN FOLDER LOKAL

### Structure:
- Budget folder: 5 files ✅
- Produktivitas folder: 11 files ✅
- Gaming folder: 21 files ✅
- High Gaming folder: 2 files ✅

### File Issues:
- Files dengan struktur invalid: [X]
- Files dengan missing field: [Y]
- Status: ✅ All Fixed

### Git Status:
- Uncommitted changes: [X] files
- Staged deletions: [Y] files
- index.lock exists: ✅ Yes / ❌ No
- Status: ✅ Clean / ⚠️ Needs cleanup

---

## 4. PERBAIKAN YANG DILAKUKAN

### Perbaikan Vercel:
1. [Bug]: [Deskripsi Perbaikan] ✅
2. [Bug]: [Deskripsi Perbaikan] ✅

Total: X bugs fixed

### Perbaikan Source Code:
1. Renamed: [Laptop A] (typo) → [Nama Benar] ✅
2. Updated: [Laptop B] data sync ✅
3. Fixed: Slug path mismatch ✅
4. Updated: [Field] consistency ✅

Total: X files updated

### Perbaikan Folder Lokal:
1. [Perbaikan A] ✅
2. [Perbaikan B] ✅

Total: X fixes applied

---

## 5. GIT COMMITS

Commits yang dibuat:
```
git commit -m "audit: fix typo in laptop names"
git commit -m "audit: sync data between files and master"
git commit -m "audit: fix slug path mismatch"
git commit -m "audit: fix filter logic bug"
...
```

Total commits: X

---

## 6. CHECKLIST AKHIR

- [ ] Semua 76 laptop ter-sinkronisasi (8+8+21+19+15)
- [ ] Kategori Ultrabook lengkap & konsisten
- [ ] Tidak ada typo di nama laptop
- [ ] Semua slug valid dan accessible
- [ ] Filter dan search berfungsi dengan benar (include Ultrabook)
- [ ] Dark/Light mode konsisten di semua kategori
- [ ] Responsive design ✅
- [ ] Console error: 0
- [ ] Broken links: 0
- [ ] Pending bugs: 0
- [ ] Git clean & ready to deploy

---

## 7. REKOMENDASI NEXT STEP

1. [Jika ada yang pending]: [Action needed]
2. [Feature yang bisa ditambah]: [Rekomendasi]
3. [Performance optimization]: [Saran]

---

## KESIMPULAN

**Status Audit:** ✅ PASS / ⚠️ WARNING / ❌ FAIL

Semua temuan telah di-fix dan diverifikasi. Website siap untuk production.

---
```

### 7.2 Informasi yang Harus Masuk Summary:
- Jumlah bugs ditemukan vs diterima
- Jumlah file yang di-update
- Perubahan apa saja yang dilakukan
- Commit history
- Final status: siap production atau tidak

---

## STANDAR KUALITAS: TOLERANSI KESALAHAN NOLO BESAR

✅ **Nol Typo** — setiap nama laptop harus tepat
✅ **Nol Duplikat** — tidak ada laptop yang di-input 2x
✅ **Nol Inconsistency** — data harus sinkron di semua tempat
✅ **Nol Broken Link** — setiap link harus accessible
✅ **Nol Filter Bug** — filter harus return hasil yang benar
✅ **Nol Console Error** — tidak ada error/warning di console
✅ **Nol Data Corruption** — tidak ada data yang hilang saat di-fix
✅ **Nol Styling Issue** — responsive & dark/light mode sempurna

---

## TIMELINE KERJA

| Fase | Durasi | Output |
|------|--------|--------|
| 1. Audit Vercel | 45-60 min | Bug list (76 laptop pages) |
| 2. Audit Source Code | 45 min | Data inconsistency list (76 entries + Ultrabook) |
| 3. Audit Folder Lokal | 30 min | File issues list (76 files) |
| 4. Temukan Ketidaksinkronan | 30 min | Cross-check report |
| 5. Cari Bug | 45 min | Bug priority list |
| 6. Revisi Kesalahan | 90 min | Fixed bugs + commits |
| 7. Buat Summary | 20 min | Summary file |

**Total:** ~4-5 jam untuk audit & fix lengkap (upgraded dari 39 menjadi 76 laptop)

---
