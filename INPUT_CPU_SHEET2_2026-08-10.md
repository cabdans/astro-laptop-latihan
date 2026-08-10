# LAPORAN INPUT BENCHMARK CPU — Cpuv2.xlsx Sheet 2

**Tanggal:** 10 Agustus 2026
**Sumber:** `Cpuv2.xlsx` Sheet **2** (MD5 `a8d47a11bb533d77bed742c0e2ad3709`) — satu-satunya sumber, tanpa web search
**Status:** input SUKSES 0 error, **tapi ada 4 hal menunggu keputusan Anda**

---

## Summary

| Item | Jumlah |
|---|---|
| Processor BARU di Sheet 2 | **5 baris** |
| Processor ter-update di project | **4 dari 5** |
| File review ter-update | **6 dari 76** |
| File SKIP (sudah punya benchmark) | **66** |
| File masih kosong setelah input | **4** |
| `pmMulti` ter-update di `rekomendasi.astro` | 6 |
| Score CPU ter-update di `compare.astro` | 6 |
| Entri baru di `cpuBench` `h2h.astro` | 1 |

Kolom Sheet 2: `CPU, Single, Multi, Efficiency, Igpu, Final, Cinebench Single/Multi, Cinebench rank, Passmark Single/Multi`. Sesuai keputusan Anda sebelumnya, kolom Cinebench dan rank tidak dipakai.

---

## File yang Ter-update

| File | Processor | Final | Passmark Multi |
|---|---|---|---|
| `high-gaming/asus-tuf-a14-fa401uh-rtx5050` | AMD Ryzen AI 7 260 | 61 | 28.167 |
| `high-gaming/asus-tuf-a16-fa608um-rtx5060` | AMD Ryzen AI 7 260 | 61 | 28.167 |
| `high-gaming/asus-tuf-a16-fa608up-rtx5070` | AMD Ryzen AI 7 260 | 61 | 28.167 |
| `high-gaming/lenovo-loq-15ahp11-rtx5060` | AMD Ryzen AI 7 250 | 61 | 25.331 |
| `high-gaming/acer-predator-helios-neo-16s-ultra7-356h-rtx5060` | Intel Core Ultra 7 356H | 67 | 34.072 |
| `ultrabook/acer-swift-go-14-sfg14-ultra5-125h` | Intel Core Ultra 5 125H | 52 | 20.314 |

---

## Verifikasi — 7 Check, Semua Lulus

| # | Check | Hasil |
|---|---|---|
| 1 | 70 file di luar target: spek, benchmark lama, Passmark tidak berubah | **0 perubahan** |
| 2 | 6 file target: spek-table, harga, rating, kategori, tanggal utuh | **0 pelanggaran** |
| 3 | Angka project vs Excel (6 file × 7 metrik) | **42 nilai identik** |
| 4 | CPU sama → angka sama antar file | **konsisten** |
| 5 | `pmMulti` & Score CPU cocok dengan file review | **6/6 identik** |
| 6 | File tanpa benchmark setelah input | 4 (lihat bawah) |
| 7 | CPU Sheet 2 terpakai | 4 dari 5 |

Tambahan: sintaks `node --check` lolos untuk `h2h`, `compare`, `rekomendasi`. Tag HTML seimbang di keenam file (div 24/24, table 2/2, h2 5/5).

### Sample verifikasi

| CPU | Excel → Project | PM Single | PM Multi |
|---|---|---|---|
| AMD Ryzen AI 7 260 | 61 → 61 | 3.743 | 28.167 |
| AMD Ryzen AI 7 250 | 61 → 61 | 3.710 | 25.331 |
| Intel Core Ultra 5 125H | 52 → 52 | 3.336 | 20.314 |
| Intel Core Ultra 7 356H | 67 → 67 | 4.069 | 34.072 |

---

# MENUNGGU KEPUTUSAN ANDA

## 1. Mismatch nama: `i7-13620H`

| | Nama |
|---|---|
| Sheet 2 | `i7-13620H` |
| Project (spek-table) | `Intel Core i7-13620H` |

File terdampak: `high-gaming/axioo-pongo-775-rtx5070`

Sesuai aturan "nama tidak persis sama → tanya dulu, jangan asumsikan", saya **tidak** memasukkannya. Ini juga CPU yang sesi lalu Anda putuskan dibiarkan kosong. Bedanya cuma prefix merek, tapi keputusannya tetap di Anda.

**Data yang tersedia bila mau diinput:** Single 69, Multi 38, Efficiency 56, iGPU 37, **Final 54**, Passmark 3.549 / 23.398

---

## 2. Konflik angka di `h2h.astro` — 3 processor

Ini temuan terpenting. Tiga CPU **sudah punya entri** di `cpuBench` `h2h.astro` dengan angka **berbeda dari Sheet 2**. Sesuai aturan "benchmark yang sudah ada jangan di-overwrite", saya **tidak mengubahnya** — tapi akibatnya sekarang ada ketidakcocokan antar halaman.

### AMD Ryzen AI 7 250

| Metrik | h2h (lama) | Sheet 2 | Beda |
|---|---|---|---|
| nano | 61 | 61 | — |
| **efficiency** | **81** | **80** | ya |
| pmS | 3.710 | 3.710 | — |
| pmM | 25.331 | 25.331 | — |

### Intel Core Ultra 5 125H

| Metrik | h2h (lama) | Sheet 2 | Beda |
|---|---|---|---|
| **nano** | **53** | **52** | ya |
| **efficiency** | **68** | **67** | ya |
| pmS | 3.336 | 3.336 | — |
| pmM | 20.314 | 20.314 | — |

### Intel Core i7-13620H

| Metrik | h2h (lama) | Sheet 2 | Beda |
|---|---|---|---|
| **nano** | **55** | **54** | ya |
| **efficiency** | **60** | **56** | ya |
| **pmS** | **3.500** | **3.549** | ya |
| **pmM** | **20.000** | **23.398** | ya |

Angka h2h untuk i7-13620H (3.500 / 20.000) terlihat seperti angka bulat perkiraan, bukan hasil pengukuran. Tapi saya tidak mengubahnya tanpa izin Anda.

**Dampak saat ini:** halaman review Swift Go 14 Ultra 5 125H menampilkan Final **52**, sementara halaman H2H menampilkan nano **53** untuk CPU yang sama. Begitu juga efficiency Ryzen AI 7 250: review **80**, h2h **81**.

**Pilihan Anda:**
- **A** — Timpa h2h dengan angka Sheet 2 (Sheet 2 jadi acuan tunggal, semua halaman seragam)
- **B** — Biarkan h2h apa adanya (perbedaan antar halaman tetap ada)
- **C** — Sebaliknya: samakan halaman review mengikuti angka h2h yang lama

---

## 3. Tiga laptop tanpa nama processor

Bukan soal benchmark, CPU-nya sendiri belum diketahui (`Tidak tercantum di sumber data`):

- `high-gaming/asus-rog-strix-g16-g614pr-rtx5070ti`
- `high-gaming/lenovo-legion-5i-15irx10-oled-rtx5050`
- `ultrabook/acer-swift-go-14-sfg14-73p9`

Nama processornya perlu dipastikan lebih dulu sebelum benchmark bisa diisi.

---

## 4. Kalimat prosa jadi tidak akurat

Keenam file target memuat kalimat:

> "...dan skor benchmark akan ditambahkan menyusul."

Sekarang skornya sudah ada, jadi kalimat itu tidak berlaku lagi. Aturan Anda melarang mengubah paragraf prosa, jadi saya biarkan. Kalau mau dihapus, tinggal bilang — 6 kalimat, satu per file.

---

## Koreksi Laporan Sebelumnya

`Intel Core Ultra 5 115U` (`budget/advan-workmate-ultra-core-ultra5-115u`) sempat saya laporkan "tanpa benchmark". **Itu keliru** — file itu sudah punya bagian Benchmark CPU dengan Passmark 3.421 / 12.771, hanya tanpa bar NanoReview. Deteksi saya waktu itu terlalu sempit. File ini di-SKIP dengan benar, dan CPU-nya memang tidak ada di Sheet 2.

Catatan lanjutan: angka Passmark Multi untuk 115U berbeda di dua tempat — halaman review **12.771**, `cpuBench` h2h **10.800**. Di luar cakupan Sheet 2, tapi perlu dirapikan kapan-kapan.

---

## Kesimpulan

**Input SUKSES, 0 error** untuk 4 processor / 6 file. Semua verifikasi lulus, tidak ada benchmark lama yang tertimpa, tidak ada spesifikasi yang berubah.

Satu processor (`i7-13620H`) belum diinput karena mismatch nama, dan 3 konflik angka di `h2h.astro` sengaja dibiarkan menunggu keputusan Anda.

---

## Commit

```cmd
cd /d "C:\Users\cahya\OneDrive\Documents\Claude\Projects\astro-laptop-latihan"
del /f /q .git\*.lock
git add -A
git commit -m "feat(benchmark): input 4 CPU dari Cpuv2 Sheet 2 ke 6 file review + sinkron pmMulti, score compare, cpuBench h2h"
git push origin main
```
