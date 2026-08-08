# AUDIT MENDALAM: LOGIKA FILTER "TEMUKAN LAPTOP"

**Tanggal:** 8 Agustus 2026
**File:** `src/pages/rekomendasi.astro`
**Metode:** simulasi exhaustive **1.152 kombinasi filter** (5 bar × semua nilai chip) atas 76 data laptop asli, bukan pembacaan manual

---

## Ringkasan Temuan

| # | Temuan | Tingkat | Status |
|---|--------|---------|--------|
| 1 | Chip "Di bawah Rp 5 juta" tidak pernah menghasilkan apa pun | **Bug aktif** | Diperbaiki |
| 2 | Laptop berharga rentang bisa hilang dari semua bucket | **Bug laten** | Diperbaiki |
| 3 | Fallback 3-hasil mengabaikan prioritas performa user | Inkonsistensi | Diperbaiki |
| 4 | Laptop tepat Rp 20 juta muncul di dua bucket sekaligus | Minor | Ikut selesai lewat fix #2 |

---

## Bug #1 — Chip "Di bawah Rp 5 juta" mustahil menghasilkan hasil

**Gejala:** user memilih chip pertama di Bar 1, hasilnya selalu kosong dan langsung dilempar ke fallback "tidak ada yang 100% cocok".

**Penyebab:** laptop termurah di project adalah **Rp 6 juta**, sementara bucket `under5` mensyaratkan `hMax <= 5`. Tidak ada satu pun dari 76 laptop yang memenuhi.

Verifikasi sebaran harga aktual:

| Rentang | Jumlah |
|---|---|
| 5–10 Jt | 13 |
| 10–15 Jt | 13 |
| 15–20 Jt | 13 |
| 20–25 Jt | 13 |
| 25–30 Jt | 8 |
| 30–35 Jt | 1 |

Termurah 6 Jt, termahal 31 Jt. Bucket lama (`<5`, `5–10`, `10–15`, `15–20`, `>20`) menyisakan satu chip mati di bawah dan menumpuk 22 laptop di satu chip teratas.

**Fix:** batas bucket disesuaikan sebaran nyata.

| Sebelum | Sesudah |
|---|---|
| Di bawah Rp 5 juta *(0 hasil)* | Di bawah Rp 10 juta |
| Rp 5–10 juta | Rp 10–15 juta |
| Rp 10–15 juta | Rp 15–20 juta |
| Rp 15–20 juta | Rp 20–25 juta |
| Di atas Rp 20 juta *(22 laptop)* | Di atas Rp 25 juta |

Distribusi setelah fix jauh lebih seimbang: **13 / 15 / 14 / 14 / 10**.

---

## Bug #2 — Laptop berharga rentang bisa hilang dari SEMUA bucket

Ini temuan paling serius karena diam-diam menyembunyikan produk dari hasil.

**Penyebab:** logika lama mensyaratkan rentang harga laptop **muat seluruhnya** di dalam bucket:

```js
if (val === '5to10')  return l.hMin >= 5  && l.hMax <= 10;
if (val === '10to15') return l.hMin >= 10 && l.hMax <= 15;
```

Laptop seharga **Rp 9–11 juta** gagal di keduanya: `hMax 11 > 10` menggugurkan bucket 5–10, `hMin 9 < 10` menggugurkan bucket 10–15. Laptop itu **tidak muncul di bucket mana pun** — hilang total dari fitur, tanpa pesan error apa pun.

Pemetaan lengkap rentang harga yang jadi korban di logika lama:

> **3–6, 4–6, 4–7, 8–11, 9–11, 9–12, 13–16, 14–16, 14–17, 18–21, 19–21, 19–22**

Sebanyak **12 pola rentang** — dan format `"Rp X–Y Juta"` justru format harga paling umum di project ini, jadi ini bug yang tinggal menunggu waktu. Data saat ini kebetulan belum menyentuh satu pun rentang tersebut (0 orphan), tapi satu laptop baru seharga Rp 9–11 juta sudah cukup untuk memicunya.

**Fix:** ganti dari "muat seluruhnya" ke **irisan rentang**, dengan batas atas eksklusif:

```js
const BUDGET_BUCKETS = {
  under10:  [0,  10],
  '10to15': [10, 15],
  '15to20': [15, 20],
  '20to25': [20, 25],
  over25:   [25, Infinity],
};
// bucket = [lo, hi) ; laptop = [hMin, hMax]
return l.hMin < hi && l.hMax >= lo;
```

Batas atas sengaja **eksklusif** supaya laptop berharga tunggal jatuh di tepat satu bucket. Kalau memakai irisan biasa (`hMin <= hi`), laptop "Rp 10–11 juta" akan ikut muncul di chip "Di bawah 10 juta" — jelas salah.

Uji kasus batas:

| Harga | Masuk bucket |
|---|---|
| Rp 6–7 Jt | under10 |
| Rp 9–10 Jt | under10, 10to15 |
| Rp 10–11 Jt | 10to15 *(benar — tidak bocor ke under10)* |
| Rp 14–15 Jt | 10to15, 15to20 |
| Rp 15–16 Jt | 15to20 *(tidak bocor ke 10to15)* |
| Rp 20 juta (titik) | 20to25 *(tepat satu bucket)* |
| Rp 25 juta (titik) | over25 |
| Rp 8–11 Jt | under10, 10to15 *(dulu ORPHAN)* |
| Rp 19–22 Jt | 15to20, 20to25 *(dulu ORPHAN)* |
| Rp 31 Jt | over25 |

Uji ketahanan menyeluruh: **175 rentang harga hipotetis** (Rp 1–35 juta, lebar 0–4 juta) → **0 orphan**.

---

## Bug #3 — Fallback mengabaikan prioritas performa

**Gejala:** saat tidak ada laptop yang cocok 100%, halaman menampilkan 3 laptop "paling mendekati". Ketiganya diurutkan **hanya** berdasarkan skor kedekatan. Karena banyak laptop berskor sama, urutan akhirnya jatuh ke urutan array sumber — bukan ke apa yang user prioritaskan.

**Bukti** — state "Ringan & Awet Baterai" + "Editing berat" (kombinasi yang memang mustahil karena satu menolak dGPU dan satunya mewajibkan):

| | Hasil | Skor | Efficiency |
|---|---|---|---|
| **Sebelum** | Lenovo IdeaPad Slim 3 14IRH10 | 5 | 68 |
| | Lenovo IdeaPad Slim 3 14ARP10 | 5 | 69 |
| | Advan Pixwar Touchscreen | 5 | 74 |
| **Sesudah** | MSI Prestige 14 Flip AI+ | 5 | **100** |
| | Lenovo IdeaPad Slim 5i Ultra 7 255H | 5 | **97** |
| | Lenovo IdeaPad Slim 5 14 OLED | 5 | **96** |

Skornya sama-sama 5, tapi versi sesudah menampilkan laptop yang benar-benar paling efisien — sesuai yang diminta user.

**Fix:** jalankan `sortByPerforma()` lebih dulu sebagai tiebreak. `Array.prototype.sort` bersifat stabil, jadi laptop berskor sama tetap mempertahankan urutan prioritas performa:

```js
const scored = sortByPerforma(laptops.map(l => ({ ...l, _score: scoreClosest(l) })))
  .sort((a, b) => b._score - a._score)
  .slice(0, 3);
```

Urutan skor tetap menurun dengan benar (terverifikasi).

---

## Yang Diperiksa dan Ternyata BERSIH

| Item | Hasil |
|---|---|
| Konsistensi `passesAllFilters()` vs `scoreClosest()` | **0 inkonsistensi** dari 1.152 kombinasi. Setiap laptop yang lolos hard filter selalu punya skor maksimum |
| Kebocoran laptop tanpa harga | **0 kebocoran** ke bucket mana pun. Guard `if (l.hMin === 0) return false` bekerja di seluruh kombinasi |
| `efficiencyScore()` terhadap data kosong | Bersih. `bobot > 0` dan `pmMulti > 0` dijaga, jadi 30 laptop tanpa data bobot dan 10 tanpa pmMulti tidak dapat bonus palsu |
| `sortByPerforma()` mode Produktivitas | Bersih. 10 laptop `pmMulti:0` konsisten di indeks 66–75 (ekor) |
| `sortByPerforma()` mode Gaming | Bersih. Dari 42 laptop lolos, tidak ada yang `gpuTgp:0` |
| Integritas data | `hMin > hMax` terbalik: **0**. `gpuDed` tapi TGP/VRAM nol: **0**. Kategori Gaming tanpa dGPU: **0**. Ultrabook dengan dGPU: **0** |
| Chip toggle & tombol Reset | Bersih. Klik ulang chip aktif membatalkan pilihan, Reset mengosongkan `state`, kelas `active`, dan `has-selection` |
| Kartu hasil (`buildCard`) | Bersih. Badge TGP/Passmark hanya muncul di mode yang relevan, dan `l.pmMulti` bernilai 0 sudah otomatis tersaring karena falsy |

---

## Verifikasi Akhir

Semua angka di bawah dari simulasi kode final atas 76 data asli.

- [x] **1.152 kombinasi filter** diuji tuntas
- [x] Laptop tanpa harga bocor ke bucket: **0**
- [x] Inkonsistensi filter vs skor: **0**
- [x] Chip yang mati saat dipilih sendirian: **0** *(sebelumnya 1)*
- [x] Coverage budget: **61 / 61 laptop berharga, 0 orphan**
- [x] Kombinasi tanpa hasil: **265 dari 1.152 (23,0%)** — turun dari **391 (33,9%)**
- [x] Sintaks: `node --check` lolos
- [x] CSS balanced: 35 / 35
- [x] Nilai bucket lama (`under5`, `5to10`, `over20`) tersisa di file: **0**
- [x] `data-val` chip cocok 1:1 dengan kunci `BUDGET_BUCKETS`

Isi tiap chip setelah perbaikan:

| Chip | Hasil |
|---|---|
| Di bawah Rp 10 juta | 13 |
| Rp 10–15 juta | 15 |
| Rp 15–20 juta | 14 |
| Rp 20–25 juta | 14 |
| Di atas Rp 25 juta | 10 |
| RAM upgradeable = Ya | 58 |
| Editing ringan | 46 |
| Editing berat | 31 |
| Performa Ringan | 34 |
| Performa Gaming | 42 |
| Brand lokal | 14 |
| Brand luar | 62 |

---

## Catatan: 265 Kombinasi Tanpa Hasil Itu Wajar

Sisa 23% kombinasi kosong bukan bug, melainkan kontradiksi yang memang tidak bisa dipenuhi produk apa pun — misalnya "Ringan & Awet Baterai" (menolak GPU dedicated) digabung "Editing berat" (mewajibkan GPU dedicated), atau "Gaming" digabung budget di bawah Rp 10 juta padahal laptop ber-dGPU termurah ada di Rp 12,5 juta. Sistem fallback sudah menangani ini dengan benar, dan setelah fix #3 hasilnya kini relevan.

---

## Commit

```cmd
cd /d "C:\Users\cahya\OneDrive\Documents\Claude\Projects\astro-laptop-latihan"
del /f /q .git\*.lock
git add -A
git commit -m "fix(rekomendasi): bucket harga ikut sebaran data + cocokkan via irisan rentang + fallback hormati prioritas performa"
git push origin main
```

## Status: SELESAI

3 bug ditemukan dan diperbaiki, 8 area lain diperiksa dan terbukti bersih, seluruh verifikasi lolos tanpa regresi.
