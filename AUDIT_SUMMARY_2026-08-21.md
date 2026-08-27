# AUDIT SUMMARY ASTROLAPTOP — 21 Agustus 2026

Dijalankan mengikuti `PROMPT_AUDIT_2026-08-21.md`. Tujuh fase selesai. Backup seluruh file yang diubah ada di `backups/audit-2026-08-21/`.

---

## RINGKASAN ANGKA

| Metrik | Sebelum audit | Sesudah audit |
|---|---|---|
| Total laptop | 93 | 93 |
| File dengan badge `[ Harga Agustus 2026 ]` | 70 | **71** |
| File dengan `linkTokopedia` | 78 | **79** |
| File dengan prop `rare` | 3 | **4** |
| Kemunculan `No Data` | 68 | **67** |
| Placeholder "Harga belum tercantum" | 3 | **2** (sisanya memang belum ada harganya) |
| Baris tabel `Harga` bertulis `No Data` padahal harga terisi | 4 | **0** |

Sebaran per kategori tetap: Budget 9, Produktivitas 13, Gaming 26, High Gaming 25, Ultrabook 20. Enam sumber data seragam di angka 93.

---

## FASE 1 — REGRESSION CHECK

| # | Titik periksa | Hasil |
|---|---|---|
| 1 | Guard harga nol di `compare`, `h2h`, `rekomendasi` | LULUS |
| 2 | Bucket harga eksklusif — 91 laptop berharga, ganda 0, yatim 0 | LULUS |
| 3 | Class `badge-gpu` — 8 dipakai, 8 didefinisikan, tidak ada yatim | LULUS |
| 4 | Prefix slug cocok kategori (93/93) | LULUS |
| 5 | Kurung seimbang di 5 halaman agregat | LULUS |
| 6 | `filter(fn)` tanpa arrow | LULUS — satu-satunya temuan `filter(Boolean)` di `rekomendasi.astro:1164` adalah idiom sah, bukan bug |
| 7 | Sisa kalimat "datasheet AstroLaptop" | LULUS — 0 |
| 8 | Badge `Rare` punya dasar di Excel | LULUS, tapi ada yang **kurang** — lihat T-2 |

---

## TABEL TEMUAN

| # | Fase | Temuan | Keparahan | Status |
|---|---|---|---|---|
| T-1 | 2 | **HP Victus 15 FA2717TX i5-13420H** punya link affiliate dan Harga Latest Rp17,2 juta di Excel yang **tidak pernah tersinkron** selama ini, karena nama di Excel diberi akhiran "4050" sehingga tidak pernah cocok saat pencocokan nama | Tinggi | **Diperbaiki** — link, harga, badge, 2 kalimat prosa, plus sinkron ke 5 halaman agregat |
| T-2 | 1 | **Advan Workmate Ultra Core Ultra 5 115U** ditandai `Rare` di Excel tapi halaman review-nya belum punya prop `rare` | Sedang | **Diperbaiki** — prop ditambahkan |
| T-3 | 3 | **ASUS TUF A16 FA608UH** mengklaim "harga paling tinggi di kelas RTX 5050" di 3 tempat. Kenyataannya ada 5 unit RTX 5050 yang lebih mahal (Rp24,5 / 25,0 / 25,8 / 26,8 / 30,8 juta) | Tinggi | **Diperbaiki** — ditulis ulang jadi perbandingan yang benar terhadap MSI Crosshair A16 HX |
| T-4 | 3 | **Axioo Pongo 775** mengklaim "harga paling rendah untuk tier RTX 5070" di 4 tempat termasuk satu judul H2. Kenyataannya MSI Crosshair A16 HX RTX 5070 lebih murah (Rp24,5 vs Rp24,8 juta), dan klaim "titik masuk termurah di kategori ini" juga salah karena Pongo 765 ada di Rp21,3 juta | Tinggi | **Diperbaiki** — judul dan 3 kalimat ditulis ulang |
| T-5 | 4 | Empat halaman menulis `Harga: No Data` di tabel spek padahal prop `harga` sudah terisi: ASUS ExpertBook P1, Acer Nitro Lite 16 (2 varian), Axioo Hype 7 X8 | Sedang | **Diperbaiki** — baris tabel diisi sesuai prop |
| T-6 | 6 | **Acer Swift Go 14 AI SFG14-73-73P9** harganya Rp18.500.000 tapi tabel spek masih ` - ` dan daftar Kekurangan masih menulis "Harga belum tercantum di sumber data" | Sedang | **Diperbaiki** |
| T-7 | 5 | Entri **Lenovo LOQ Essential 15ARP10E** di `/hotdeals` menyebut "RTX 3050 6 GB" tapi menaut ke halaman review varian **RTX 4050** | Tinggi | **Belum** — butuh halaman review varian RTX 3050 dibuat dulu (lihat P-5) |
| T-8 | 5 | Tombol **"Beli di Shopee"** dirender di seluruh 93 halaman dengan `href="#"`, karena 0 file punya `linkShopee`. Tombol Tokopedia juga mati di 14 halaman | Sedang | **Belum** — butuh keputusan (lihat P-7) |
| T-9 | 4 | Baris `cooling` dan `tdp` di `/h2h` kosong di **50 dari 93** laptop | Rendah | **Belum** — butuh keputusan (lihat P-8) |
| T-10 | 4 | Entri `AMD Ryzen AI 5 220` di `cpuBench` tidak dipakai laptop mana pun | Sangat rendah | Dibiarkan — tidak mengganggu, sekadar catatan |

**Total: 6 temuan diperbaiki, 4 masuk daftar tunggu.**

---

## FASE 3 — HASIL UJI KLAIM HARGA

51 file mengandung klaim relatif. Setelah dipilah, mayoritas ternyata **bukan** klaim harga (kebanyakan soal kapasitas baterai, bobot, skor benchmark, atau TGP) sehingga tidak terpengaruh perubahan harga.

Klaim harga yang diuji satu per satu dan **terbukti masih benar**:

- ASUS ExpertBook PM1403CDA — "Aspire Lite 15 R5-8640HS di harga lebih murah" → Rp11,3 vs Rp10,2 juta. Benar.
- IdeaPad Slim 3 14ARP10 — "Polytron Luxia Pro di kelas lebih murah" → Rp11,0 vs Rp10,0 juta. Benar.
- Acer Aspire Lite 15 R5-8640HS — "daya tahannya kalah dari varian yang lebih murah" → varian R5-7430U Rp9,7 juta memang berbaterai 58 Wh lawan 53 Wh. Benar.
- Trio IdeaPad Slim 5 — "termurah" (Rp17,7) dan "paling mahal" (Rp20,0) di dalam trio. Benar.
- Lenovo LOQ 15IRX10 i7-13700HX — "tertinggi di kategori Gaming" → Rp24,5 juta memang tertinggi. Benar.
- MSI Vector 16HX Ultra 9 275HX — "tier GPU tertinggi di kategori" → RTX 5080, satu-satunya. Benar.
- Seluruh klaim "di rentang Rp X - Rp Y juta" (11 file) → harga terkini masih jatuh di dalam rentangnya. Benar.

Yang **terbukti salah** dan sudah ditulis ulang: T-3 dan T-4.

---

## FASE 6 — INTEGRITAS FILE

| Pemeriksaan | Hasil |
|---|---|
| Keseimbangan tag `<p> <div> <table> <ul> <li> <strong> <h2> <h3> <tr> <td>` di 93 file | 0 bermasalah |
| Prop wajib (`title`, `harga`, `rating`, `kategori`, `tanggal`, `ringkasan`) | 0 kekurangan |
| Duplikat slug / duplikat judul | 0 |
| Diff tabel spek terhadap backup (9 file yang disentuh) | **0 perubahan di luar baris `Harga`** yang memang disengaja |
| Kurung `{}` di 5 halaman agregat | seimbang semua |

---

## FILE YANG DIUBAH

Semua backup ada di `backups/audit-2026-08-21/`.

| File | Perubahan |
|---|---|
| `review/gaming/hp-victus-15-fa2717tx.astro` | link, harga Rp17,2 jt, badge, 2 prosa (6 perubahan) |
| `review/budget/advan-workmate-ultra-core-ultra5-115u.astro` | prop `rare` |
| `review/gaming/asus-tuf-a16-fa608uh-rtx5050.astro` | 3 klaim harga ditulis ulang |
| `review/high-gaming/axioo-pongo-775-rtx5070.astro` | 4 klaim harga ditulis ulang termasuk judul H2 |
| `review/budget/asus-expertbook-p1-i3-1315u.astro` | baris tabel Harga |
| `review/gaming/acer-nitro-lite-16-core5-210h-rtx4050.astro` | baris tabel Harga |
| `review/gaming/acer-nitro-lite-16-core7-240h-rtx4050.astro` | baris tabel Harga |
| `review/produktivitas/axioo-hype-7-x8-r7-6800h.astro` | baris tabel Harga |
| `review/ultrabook/acer-swift-go-14-sfg14-73p9.astro` | baris tabel Harga + hapus placeholder |
| `rekomendasi.astro`, `h2h.astro`, `compare.astro`, `index.astro`, `review/index.astro` | sinkron harga HP Victus FA2717TX |

**`LAPTOP_TANPA_LINK_AFFILIATE.xlsx` tidak disentuh sama sekali** — hanya dibaca.

---

## MENUNGGU KEPUTUSAN CAHYA

| # | Perkara |
|---|---|
| P-1 | **Acer Swift Air 14 — harga terbalik.** Excel menyebut Ultra 5 125H Rp16,7 juta dan Ultra 7 155H Rp15,4 juta, jadi varian CPU lebih rendah justru lebih mahal. Halaman Ultra 5 punya satu bagian utuh "Selisih Rp3 Juta dari Varian Ultra 7" yang argumennya bertumpu pada premis varian ini lebih murah. Sinkronisasi kedua file **ditahan**. Perlu dipastikan: harganya memang begitu, atau tertukar saat input? |
| P-2 | **ASUS ROG Strix G614PR charger** — proyek 280 W, file spek 240 W. Dibiarkan apa adanya. |
| P-3 | **Empat konflik angka benchmark:** Ryzen AI 7 250 efisiensi 81 vs 80; Ryzen AI 7 255 3.520/22.000 vs 3.717/28.774; i7-13700H 3.650/25.000 vs 3.557/25.960; i7-13700HX 3.800/29.500 vs 3.798/31.788. |
| P-4 | **Benchmark belum ada** untuk Ryzen 7 260, Ryzen 7 6800H, Core 3 100U, Core 7 240H — masing-masing 1 laptop, tampil `No Data` di `/h2h`. Plus 2 laptop yang CPU-nya masih tertulis "Tidak tercantum". |
| P-5 | **Lenovo LOQ Essential 15ARP10E R7 7735HS RTX 3050** (SKU 83S0001AID) belum dibuatkan halaman review. Ini sekaligus penyebab T-7 di `/hotdeals`. |
| P-6 | **Dua nama Excel berbeda dari judul proyek:** `Acer Nitro Lite NL16 3050` vs `Acer Nitro Lite NL16 Core 5 210H RTX 3050`, dan `HP Victus 15 FA2717TX i5-13420H 4050` vs `HP Victus 15 FA2717TX i5-13420H`. Perlu izin untuk menyelaraskan salah satu sisi. |
| P-7 | **Tombol Shopee mati di 93 halaman** (`href="#"`). Pilihannya: sembunyikan tombol saat `linkShopee` kosong, atau biarkan. Berlaku juga untuk tombol Tokopedia yang mati di 14 halaman. |
| P-8 | **Baris `cooling` dan `tdp` di `/h2h` kosong di 50 dari 93 laptop.** Sembunyikan barisnya kalau kedua laptop yang dibandingkan sama-sama kosong, atau biarkan? |
| P-9 | **11 judul belum memuat tipe GPU** padahal laptopnya punya dedicated GPU, bertentangan dengan aturan format judul: Acer Aspire 7 Pro A715, Acer Nitro V15 ANV15-42, ASUS Gaming V16 V3607VH, ASUS TUF A15 FA506NCG, ASUS TUF Gaming A16 FA607NUG, Colorful Evol P15 HE55D, HP Victus 15 FA2717TX, LOQ 15IRX10 (i7-13700HX dan i5-13450HX), LOQ 15IRX9, LOQ Essential 15ARP10E. |
| P-10 | **Dua laptop tanpa harga** sehingga tak terlihat di semua filter: Acer Predator Helios Neo 16S Ultra 9 386H RTX 5070 dan HP Omen i7-14650HX RTX 5060. |

---

## CATATAN PENUTUP

`npx astro build` tidak bisa dijalankan dari lingkungan kerja Claude (EPERM di `node_modules/.vite`), jadi seluruh verifikasi di audit ini bersifat struktural: hitung entri, hitung kurung, cocokkan nama, dan diff terhadap backup. **Build final perlu dijalankan Cahya sendiri sebelum push ke Vercel.**
