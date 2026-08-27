# PROMPT AUDIT ASTROLAPTOP — 21 Agustus 2026

**Tujuan:** Audit menyeluruh AstroLaptop pada kondisi terkini, perbaiki temuan, tulis summary ke `AUDIT_SUMMARY_2026-08-21.md`. Toleransi kesalahan nol.

---

## ATURAN PROYEK (TIDAK BISA DITAWAR)

1. **JANGAN gunakan web search atau fetch** untuk spesifikasi maupun benchmark laptop. Sumber tunggal adalah file di dalam folder proyek dan file yang diinput langsung oleh Cahya di chat. Kalau ada spek yang tidak disebutkan — **tanya, jangan tebak, jangan isi dari pengetahuan umum**.
2. **JANGAN menulis ke `LAPTOP_TANPA_LINK_AFFILIATE.xlsx` tanpa persetujuan eksplisit Cahya.** File itu data pribadi Cahya. Boleh dibaca, tidak boleh ditimpa, di-regenerate, atau diubah barisnya. Kalau memang perlu baris baru, **append saja, setelah minta izin**. File ini pernah rusak karena di-regenerate.
3. **JANGAN mengubah warna highlight / fill di Excel.** Warna itu penanda input milik Cahya, bukan dekorasi.
4. **Jangan menimpa angka benchmark** yang sudah ada tanpa keputusan eksplisit dari Cahya.
5. **Selalu backup sebelum mengubah** — simpan ke `backups/<nama-tugas>/`.
6. **Setiap penggantian teks wajib diverifikasi ketemu tepat 1×.** Kalau 0 atau >1, laporkan; jangan menebak target.
7. Format judul: `Brand + Model + Tipe Processor + Tipe GPU`. Kata "Laptop" tidak ditulis di depan. Tipe GPU hanya ditulis kalau ada dedicated GPU; kalau cuma iGPU, judul berhenti di prosesor.
8. Gaya penulisan mengikuti `PROMPT-GAYA-PENULISAN-2026.md` (sumber kebenaran) dan `PANDUAN-GAYA-PENULISAN.md`. Jangan pakai gaya default.
9. **`npx astro build` tidak bisa dijalankan** dari lingkungan kerja Claude (EPERM di `node_modules/.vite`). Semua verifikasi harus struktural — hitung kurung, hitung entri, diff before/after. Build final dijalankan Cahya sendiri.

---

## KONDISI PROYEK SAAT INI (per 21 Agustus 2026)

**Total: 93 laptop** (naik dari 90 pada audit 18 Agustus)

| Kategori | File `.astro` | Excel `Semua` | Status |
|---|---|---|---|
| Budget | 9 | 9 | sinkron |
| Produktivitas | 13 | 13 | sinkron |
| Gaming | 26 | 26 | sinkron |
| High Gaming | 25 | 25 | sinkron |
| Ultrabook | 20 | 20 | sinkron |
| **TOTAL** | **93** | **93** | **sinkron** |

Enam sumber sudah seragam di angka 93: `rekomendasi.astro`, `h2h.astro`, `compare.astro`, `index.astro`, `review/index.astro`, folder `/review`.

**Angka penanda lain:**

| Metrik | Nilai sekarang |
|---|---|
| File dengan `hargaUpdate="Agustus 2026"` | 70 |
| File dengan `linkTokopedia` berisi URL | 78 |
| File dengan `linkShopee` berisi URL | 0 |
| File dengan prop `rare` | 3 |
| Kemunculan `No Data` di seluruh halaman review | 71 |
| Sisa kalimat "datasheet AstroLaptop" | 0 (sudah dihapus) |

### Perubahan sejak audit 18 Agustus

| Perubahan | Keterangan |
|---|---|
| +3 laptop | Axioo Pongo 735 i7-13620H RTX 3050, Acer Nitro V15 Core 5 210H RTX 3050, Acer Predator Helios Neo 16S Ultra 9 275HX RTX 5070 |
| Sinkron link + harga High Gaming | 20 laptop, 103 penggantian teks |
| Sinkron link + harga Ultrabook | 14 laptop, 69 penggantian teks (2 ditahan, lihat bagian PENDING) |
| Prop `rare` | Ditambahkan ke `ReviewLayout`, badge `[ Rare ]` di header, dipakai 3 file |
| Kalimat "datasheet AstroLaptop" | Dihapus dari seluruh halaman review — sumber dianggap tidak kredibel |
| Badge GPU di `/compare` | VRAM dihapus dari badge (hanya di `/compare`, bukan di halaman review), format diseragamkan, lalu diberi 8 warna berbeda per tier GPU |
| Rentang harga `/compare` | Dirombak jadi per 5 juta: `5-10`, `10-15`, `15-20`, `20-25`, `25-30`, `atas30`, dengan batas atas eksklusif `[lo, hi)` |
| ASUS ROG Strix G614PR | Field kosong diisi dari file spek baru; konflik charger belum diputuskan |

### Yang sudah selesai — jadikan regression check, bukan pekerjaan ulang

| Temuan lama | Status |
|---|---|
| Laptop tanpa harga lolos filter budget di `/compare`, `/h2h`, `/rekomendasi` | SELESAI — guard `if (harga && rHarga === 0) show = false;` |
| Slug prefix tidak cocok dengan kategori | SELESAI — 93/93 cocok |
| Harga tidak konsisten antar 6 sumber | SELESAI — 0 tidak konsisten |
| Laptop Hot Deals hilang dari filter harga | SELESAI — 11/11 lolos |
| Ringkasan Cepat hardcoded sama untuk semua halaman | SELESAI — diturunkan dari `kategori`, bisa dioverride `cocokUntuk` / `kurangUntuk` |
| CPU cocok lewat substring (`255H` kena `255HX`) | SELESAI — pencocokan pakai heading `<h2>` persis |

---

## FASE 1 — REGRESSION CHECK (WAJIB, JANGAN DILEWATI)

Periksa satu per satu, laporkan LULUS / GAGAL:

1. Guard harga nol masih ada di `compare.astro`, `h2h.astro`, `rekomendasi.astro`.
2. Bucket harga `/compare` batas atasnya masih eksklusif — tidak ada laptop yang masuk dua bucket, dan tidak ada laptop berharga yang tidak masuk bucket mana pun.
3. Semua class `badge-gpu` yang dipakai di markup punya definisi CSS, dan sebaliknya tidak ada class CSS yatim.
4. Prefix slug `/review/<kategori>/` cocok dengan prop `kategori` di 93 file.
5. Jumlah `{` = `}` di kelima halaman agregat.
6. Tidak ada `filter(fn)` yang mengirim index sebagai argumen kedua secara tidak sengaja.
7. Tidak ada sisa kalimat "datasheet AstroLaptop" di halaman mana pun.
8. Badge `[ Rare ]` hanya muncul di file yang memang bertanda `Rare` di Excel.

---

## FASE 2 — SILANG EXCEL ↔ PROYEK

Baca `LAPTOP_TANPA_LINK_AFFILIATE.xlsx` **read-only**. Pencocokan nama pakai kunci ternormalisasi `re.sub(r'[^a-z0-9]','',s.lower())` terhadap `title="..."` di tiap file.

Nilai di kolom Link yang bukan URL (`Rare`, catatan, dsb.) diabaikan lewat `if lk and not str(lk).startswith('http'): lk=None`.

Laporkan:

1. Laptop yang punya Link Affiliate di Excel tapi `linkTokopedia` di halaman review beda atau kosong.
2. Laptop yang punya `Harga Latest` di kolom D tapi `harga=` di halaman review beda lebih dari Rp0,02 juta.
3. Laptop yang punya `Harga Latest` tapi belum punya `hargaUpdate="Agustus 2026"`.
4. Nama yang ada di Excel tapi tidak ada di proyek, dan sebaliknya.

**Ketidakcocokan nama yang sudah diketahui dan belum diizinkan diperbaiki** (jangan diubah sendiri, cukup laporkan ulang):

| Excel | Proyek |
|---|---|
| `Acer Nitro Lite NL16 3050` | `Acer Nitro Lite NL16 Core 5 210H RTX 3050` |
| `HP Victus 15 FA2717TX i5-13420H 4050` | `HP Victus 15 FA2717TX i5-13420H` |

---

## FASE 3 — HARGA BERUBAH, ARGUMEN IKUT BERUBAH

Ini fase yang paling sering terlewat. Setiap kali harga di-update, kalimat yang **berargumen** tentang harga ikut jadi salah, padahal angkanya sudah benar.

Cari di seluruh halaman review kalimat yang mengandung klaim relatif, lalu uji kebenarannya terhadap data harga terkini:

- "termurah", "paling mahal", "tertinggi di kategori ini", "salah satu tertinggi"
- "lebih murah dari", "selisih Rp… dari varian", "di atas varian"
- "di rentang Rp… - Rp…" yang sudah tidak cocok dengan harga tunggal sekarang
- "langka di harga ini", "jarang ditemui di harga segini"

Untuk tiap klaim, cek angkanya sekarang. Kalau klaimnya sudah tidak benar, **tulis ulang kalimatnya mengikuti gaya penulisan proyek** — jangan cuma menukar angkanya.

---

## FASE 4 — DATA MENGGANTUNG

1. Hitung `No Data` per file dan per field. Kelompokkan: field mana yang paling sering kosong (`cooling`, `tdp`, `Upgrade`, `100% sRGB`, `Baterai / Charger`, `Bobot`).
2. Laptop yang `harga` kosong atau `Rp 0` — akan tak terlihat di semua filter.
3. Halaman review yang tidak punya blok `<h2>Benchmark CPU:` sama sekali.
4. Nama CPU di `cpuBench` (`h2h.astro`) yang tidak dipakai laptop mana pun, dan CPU yang dipakai laptop tapi tidak ada di `cpuBench`.
5. Judul yang belum memuat tipe GPU padahal laptopnya punya dedicated GPU (catatan terakhir: 12 judul).

---

## FASE 5 — FUNGSIONALITAS HALAMAN AGREGAT

1. `/compare` — distribusi laptop per bucket harga, per GPU, per kategori. Pastikan tiap filter menghasilkan hasil yang masuk akal dan tidak ada kombinasi yang mustahil dipenuhi.
2. `/h2h` — baris yang isinya kosong di hampir semua laptop (`cooling` dan `tdp` masing-masing pernah tercatat 48 kosong). Laporkan angkanya sekarang dan usulkan apakah baris itu perlu disembunyikan.
3. `/hotdeals` — tiap entri harus menunjuk ke halaman review yang benar. **Diketahui bermasalah:** entri Lenovo LOQ menyebut "RTX 3050 6 GB" di Rp13,5 juta tapi tautannya mengarah ke halaman varian RTX 4050.
4. `/rekomendasi` — dua kotak konsultasi (privat + TikTok) masih tampil benar.
5. Tombol beli: 0 dari 93 file punya `linkShopee`. Putuskan bersama Cahya apakah tombol Shopee disembunyikan saat kosong.

---

## FASE 6 — INTEGRITAS FILE

1. Tag HTML seimbang di tiap file review (`<p>`, `<div>`, `<table>`, `<ul>`, `<strong>`).
2. Tidak ada file review yang kehilangan prop wajib: `title`, `harga`, `rating`, `kategori`, `tanggal`, `ringkasan`.
3. Tidak ada duplikat slug.
4. Tidak ada sisa placeholder seperti `<li>Harga belum tercantum di sumber data</li>` di file yang harganya sudah terisi.
5. Isi tabel spek tidak berubah dibanding backup terakhir di `backups/` — diff-kan.

---

## FASE 7 — TULIS SUMMARY

Buat `AUDIT_SUMMARY_2026-08-21.md` berisi:

- Tanggal, jumlah laptop per kategori, angka penanda (badge, link, `No Data`).
- Tabel temuan: nomor, fase, deskripsi, tingkat keparahan, status (diperbaiki / butuh keputusan Cahya).
- Daftar file yang diubah beserta lokasi backup-nya.
- Daftar pertanyaan terbuka yang menunggu keputusan Cahya.
- Catatan bahwa build belum dijalankan dan perlu dijalankan Cahya.

---

## PENDING — MENUNGGU KEPUTUSAN CAHYA

Jangan dikerjakan sendiri. Tampilkan ulang di akhir audit sebagai daftar tanya:

1. **Acer Swift Air 14 — harga terbalik.** Excel menyebut varian Ultra 5 125H Rp16,7 juta dan Ultra 7 155H Rp15,4 juta, jadi varian dengan CPU lebih rendah justru lebih mahal. Halaman Ultra 5 punya satu bagian utuh berjudul "Selisih Rp3 Juta dari Varian Ultra 7" yang seluruh argumennya bertumpu pada premis varian ini lebih murah. Sinkronisasi kedua file ini **ditahan** sampai Cahya memastikan apakah harganya memang begitu atau tertukar saat input.
2. **ASUS ROG Strix G614PR — charger.** Proyek menulis 280 W, file spek dari Cahya menulis 240 W. Dibiarkan apa adanya.
3. **Empat konflik angka benchmark CPU** (proyek vs sumber): Ryzen AI 7 250 efisiensi 81 vs 80; Ryzen AI 7 255 single/multi 3.520/22.000 vs 3.717/28.774; i7-13700H 3.650/25.000 vs 3.557/25.960; i7-13700HX 3.800/29.500 vs 3.798/31.788.
4. **Benchmark lima CPU masih kosong:** Ryzen 7 260, Ryzen 7 6800H, Core 3 100U, Core 7 240H, plus nama CPU asli untuk dua laptop yang masih tertulis "Tidak tercantum".
5. **Lenovo LOQ Essential 15ARP10E R7 7735HS RTX 3050** (SKU 83S0001AID) belum dibuatkan halaman review, sekaligus perbaikan entri Hot Deals-nya.
6. **Dua nama Excel** yang berbeda dari judul proyek (lihat tabel Fase 2) — perlu izin untuk diselaraskan.

---

## URUTAN EKSEKUSI

Fase 1 → 2 → 3 → 4 → 5 → 6 → 7. Setiap fase dilaporkan hasilnya sebelum lanjut. Perbaikan hanya dilakukan untuk temuan yang datanya sudah pasti; sisanya masuk daftar PENDING.
