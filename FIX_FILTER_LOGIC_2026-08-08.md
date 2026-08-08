# SUMMARY: SINKRONISASI LOGIKA FILTER

**Tanggal:** 8 Agustus 2026
**Halaman:** Temukan Laptop (`/rekomendasi`), Perbandingan (`/compare`), H2H (`/h2h`)

---

## Bug Terkonfirmasi & Diperbaiki

| Halaman | File | Bug | Fix | Commit |
|---------|------|-----|-----|--------|
| Perbandingan | `compare.astro` | **15** laptop tanpa harga lolos filter "Di bawah 10 Juta" | `if (harga && rHarga === 0) show = false;` di `applyFilters()` | `42590b6` |
| H2H | `h2h.astro` | **15** laptop tanpa harga lolos filter budget termurah | Guard `semuaHarga` di `matchesFilters()` — `hargaNum:0` hanya lolos di bucket "Semua" | *(pending, lihat catatan)* |

**Koreksi terhadap dokumen prompt:** jumlah laptop tanpa harga di `h2h.astro` adalah **15**, bukan 14. Angka ini terverifikasi identik di ketiga halaman (`data-harga="0"` = 15, `hargaNum:0` = 15, `hMin:0` = 15), jadi datanya memang konsisten antar-file.

### Detail fix H2H

Bucket "Semua" (`min=0, max=999`) dan "Di bawah 8 Jt" (`min=0, max=8`) sama-sama punya `budgetMin === 0`, jadi `budgetMin > 0` saja tidak cukup untuk membedakannya. Diskriminator yang dipakai:

```js
const semuaHarga = budgetMin === 0 && budgetMax === 999;
if (laptop.hargaNum === 0 && !semuaHarga) return false;
```

Ini memenuhi syarat prompt: laptop tanpa harga tetap muncul di bucket "Semua", tapi dikecualikan dari semua bucket spesifik termasuk "Di bawah 8 Jt".

---

## Bug Baru Ditemukan (Tahap 2)

Dua bug baru ditemukan, keduanya di fungsi sort `compare.astro` — sesuai butir checklist *"cek apakah sort kolom lain (harga, dsb) juga menangani nilai 0/kosong dengan benar"*.

### Bug Baru #1 — Sort kolom "Score CPU" gagal menurunkan No Data

```js
// SEBELUM
return badge ? parseInt(badge.textContent.trim()) : null;
```

Badge **selalu ada** di setiap baris; yang belum punya benchmark berisi karakter `—`. Jadi cabang `: null` tidak pernah tercapai, dan `parseInt("—")` menghasilkan `NaN` — bukan `null`. Akibatnya ketiga guard `if (sA === null)` di bawahnya tidak pernah aktif, comparator mengembalikan `NaN`, dan **10 baris No Data tersebar acak** alih-alih turun ke bawah. Komentar `// No Data always goes to bottom` di kode tidak sesuai perilaku sebenarnya.

```js
// SESUDAH
if (!badge) return null;
const n = parseInt(badge.textContent.trim(), 10);
return Number.isNaN(n) ? null : n;
```

### Bug Baru #2 — Sort kolom "Harga" menempatkan laptop tanpa harga sebagai termurah

```js
// SEBELUM
return (parseFloat(a.dataset.harga) - parseFloat(b.dataset.harga)) * sortDir;
```

15 baris `data-harga="0"` tersortir sebagai **paling murah** saat urut menaik. Ini pola bug yang sama persis dengan bug filter budget, hanya berpindah dari filter ke sort. Diperbaiki dengan pola guard yang sama seperti kolom score.

### Yang diperiksa dan ternyata BERSIH

| Item | Hasil |
|---|---|
| `rekomendasi` — `efficiencyScore()` terhadap `bobot:0` / `pmMulti:0` | Bersih. Keduanya dijaga `> 0`, jadi data kosong tidak dapat bonus. Top-5 mode Ringan tidak berisi laptop tanpa data |
| `rekomendasi` — `sortByPerforma()` Produktivitas | Bersih. 10 laptop `pmMulti:0` selalu di indeks 66–75 (ekor) |
| `rekomendasi` — `scoreClosest()` vs `passesAllFilters()` | Konsisten. Kriteria tanpa hard filter diberi poin, yang punya hard filter dinilai sesuai syaratnya |
| `compare` — `data-cpu=""` (3 baris) | Bukan bug. Ketiganya laptop "Tidak tercantum", dan `rCpu !== cpu` mengecualikannya dari filter Intel maupun AMD — konsisten dengan prinsip "data kosong tidak lolos filter spesifik" |
| `compare` — search bar | Bersih. Kedua sisi `.toLowerCase()`, `.includes()` = partial match, input di-`.trim()` |
| `h2h` — `gpuFilter` exact match | Bersih. 7 tombol GPU cocok 1:1 dengan 7 nama GPU di data. Nol nama tak terjangkau, nol tombol tanpa hasil. "RTX 5070" vs "RTX 5070 Ti" tidak saling salah-exclude karena perbandingannya `===`, bukan `includes` |
| `h2h` — `render()` `winsA`/`winsB` | Bersih. `benchCell()` mengembalikan `num: null` eksplisit untuk No Data, dan guard `numA !== null && numB !== null` mencegahnya dihitung menang |
| `h2h` — reset dropdown A/B | Bersih. Handler tombol budget **dan** GPU sama-sama mengosongkan `selectedA`/`selectedB` beserta nilai input, bukan sekadar menyembunyikan opsi |
| `h2h` — `parseKg()` / `parseTgp()` fallback | Aman. Fallback 999 (bobot, lower-wins) dan 0 (TGP, higher-wins) sama-sama membuat data kosong *kalah*, tidak pernah menang palsu |

---

## Verifikasi

Semua diuji lewat simulasi Node.js atas data asli ketiga file, bukan pembacaan manual.

- [x] `rekomendasi.astro`: `budgetPass()` tidak regresi — guard `if (l.hMin === 0) return false;` masih di tempat
- [x] `compare.astro`: filter harga tidak lagi menampilkan laptop tanpa data harga

  | Bucket | Tampil | Tanpa harga |
  |---|---|---|
  | Semua Harga | 76 | 15 |
  | Di bawah 10 Jt | 13 | **0** |
  | 10–13 Jt | 11 | **0** |
  | 13–17 Jt | 8 | **0** |
  | Di atas 17 Jt | 29 | **0** |

- [x] `h2h.astro`: filter budget tidak lagi menampilkan laptop tanpa data harga di dropdown

  | Bucket | Tampil | Tanpa harga |
  |---|---|---|
  | Semua | 76 | 15 |
  | Di bawah 8 Jt | 9 | **0** |
  | 8–10 / 10–12 / 12–15 | 4 / 8 / 5 | **0** |
  | 15–18 / 18–21 / 21–24 / 24+ | 10 / 5 / 11 / 11 | **0** |

- [x] Ketiga halaman: perilaku terhadap laptop tanpa harga sekarang konsisten — muncul saat tanpa filter, dikecualikan dari setiap bucket spesifik
- [x] Sort "Score CPU": 10 baris No Data di indeks 66–75 pada urutan naik **dan** turun; urutan angkanya sendiri tetap benar
- [x] Sort "Harga": 15 baris tanpa harga di indeks 61–75 pada kedua arah; urutan angkanya tetap benar
- [x] Tidak ada console error baru — `node --check` lolos untuk ketiga blok `<script>`
- [x] CSS balanced: compare 54/54, h2h 78/78, rekomendasi 35/35
- [x] Filter lain (GPU, CPU, RAM, sRGB, kategori, search) masih berfungsi normal — lihat tabel "Yang diperiksa dan ternyata BERSIH"

---

## Commit Log

| Hash | Pesan | Status |
|---|---|---|
| `42590b6` | `fix(compare): exclude laptop tanpa data harga dari filter rentang harga` | Ter-commit |
| — | `fix(compare): No Data turun ke bawah saat sort kolom Score CPU dan Harga` | Belum ter-commit |
| — | `fix(h2h): exclude laptop tanpa data harga dari filter budget` | Belum ter-commit |

**Catatan:** dua commit terakhir tertahan karena file `.git/*.lock` tersisa dari proses git sebelumnya dan tidak bisa dihapus dari lingkungan kerja. Perubahan kodenya **sudah tersimpan di file**, hanya perlu di-commit ulang dari komputer:

```cmd
cd /d "C:\Users\cahya\OneDrive\Documents\Claude\Projects\astro-laptop-latihan"
del /f /q .git\*.lock
git add -A
git commit -m "fix(compare+h2h): No Data tidak lolos filter/sort harga dan score"
git push origin main
```

---

## Status: SELESAI

Semua bug Tahap 1 diperbaiki, Tahap 2 menemukan 2 bug tambahan yang juga sudah diperbaiki, dan seluruh verifikasi lolos. Yang tersisa hanya langkah commit manual di atas karena kendala lock file, bukan kendala kode.
