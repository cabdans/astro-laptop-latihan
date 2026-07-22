# Laporan Input Data — High Gaming (RTX 5050–5080)

**Tanggal:** 22 Juli 2026
**Sumber:** `Spesifikasi Laptop Gaming High.docx` (sheet "Gaming High", 22 model)
**Status:** ✅ Sukses — 22 laptop baru diinput, tanpa duplikat.

---

## Ringkasan

| Item | Jumlah |
|---|---|
| Laptop di file docx | 22 |
| Laptop baru diinput | **22** |
| Duplikat (sudah ada) | 0 |
| Total laptop di database (sebelum → sesudah) | 39 → **61** |
| File `.astro` baru dibuat | 22 (folder `src/pages/review/high-gaming/`) |
| Entry baru di `rekomendasi.astro` | 22 |

Semua harga skip sesuai instruksi: harga dari docx dimasukkan bila ada, sisanya diberi tanda `-`. Section benchmark di-skip (untuk input manual). `pmMulti` diset `0` (konvensi "data tidak tersedia" di project).

---

## Daftar Laptop Baru + URL

**RTX 5050**

1. Lenovo Legion 5i 15IRX10 i7-13650HX — `astrolaptop.com/review/high-gaming/lenovo-legion-5i-15irx10-i7-13650hx`
2. ASUS TUF A14 FA401UH Ryzen AI 7 260 — `.../high-gaming/asus-tuf-a14-fa401uh-rtx5050`
3. Lenovo Legion 5i 15IRX10 OLED — `.../high-gaming/lenovo-legion-5i-15irx10-oled-rtx5050`
4. ASUS ROG Strix G16 G614PH Ryzen 9 8940HX — `.../high-gaming/asus-rog-strix-g16-g614ph-rtx5050`

**RTX 5060**

5. ASUS TUF A16 FA608UM Ryzen AI 7 260 — `.../high-gaming/asus-tuf-a16-fa608um-rtx5060`
6. Lenovo Legion 5i 15IRX10 i7-14700HX — `.../high-gaming/lenovo-legion-5i-15irx10-i7-14700hx-rtx5060`
7. Lenovo Legion 5i 15IAX10 Ultra 7 255HX — `.../high-gaming/lenovo-legion-5i-15iax10-rtx5060`
8. MSI Crosshair A16 HX Ryzen 9 7945HX — `.../high-gaming/msi-crosshair-a16-hx-7945hx-rtx5060`
9. HP Omen Ryzen 9 8940HX — `.../high-gaming/hp-omen-8940hx-rtx5060`
10. Acer Predator Helios Neo 16S Ultra 7 255HX — `.../high-gaming/acer-predator-helios-neo-16s-255hx-rtx5060`
11. Lenovo LOQ 15AHP11 Ryzen AI 7 250 — `.../high-gaming/lenovo-loq-15ahp11-rtx5060`
12. HP Omen i7-14650HX — `.../high-gaming/hp-omen-i7-14650hx-rtx5060`
13. Acer Predator Helios Neo 16S Ultra 7 356H — `.../high-gaming/acer-predator-helios-neo-16s-ultra7-356h-rtx5060`

**RTX 5070**

14. ASUS TUF A16 FA608UP Ryzen AI 7 260 — `.../high-gaming/asus-tuf-a16-fa608up-rtx5070`
15. Axioo Pongo 775 i7-13620H — `.../high-gaming/axioo-pongo-775-rtx5070`
16. MSI Crosshair A16 HX Ryzen 9 7945HX — `.../high-gaming/msi-crosshair-a16-hx-7945hx-rtx5070`
17. Acer Predator Helios Neo 16S Ultra 9 386H — `.../high-gaming/acer-predator-helios-neo-16s-ultra9-386h-rtx5070`

**RTX 5070 Ti**

18. MSI Vector 16HX Ultra 7 255HX — `.../high-gaming/msi-vector-16hx-255hx-rtx5070ti`
19. ASUS ROG Strix G16 2025 G614PR — `.../high-gaming/asus-rog-strix-g16-g614pr-rtx5070ti`
20. Lenovo Legion Pro 5i 16 OLED Ultra 9 275HX — `.../high-gaming/lenovo-legion-pro-5i-16-oled-rtx5070ti`
21. HP Omen Max 16 Ryzen AI 7 350 — `.../high-gaming/hp-omen-max-16-rtx5070ti`

**RTX 5080**

22. MSI Vector 16HX Ultra 9 275HX — `.../high-gaming/msi-vector-16hx-275hx-rtx5080`

---

## Audit Duplikat

Tidak ada duplikat persis. Satu catatan hubungan dekat:

- **Lenovo LOQ 15AHP11 (RTX 5060)** — model & CPU sama dengan entry lama `gaming/lenovo-loq-15ahp11` yang **varian RTX 5050**. Keduanya unit berbeda (GPU beda), jadi diinput sebagai laptop baru, bukan duplikat.

---

## Perlu Konfirmasi / Kelengkapan Data (dari sumber)

Item berikut kosong / ambigu di docx dan ditandai jelas di halaman masing-masing:

1. **CPU tidak tercantum** — `Lenovo Legion 5i 15IRX10 OLED` dan `ASUS ROG Strix G16 2025 G614PR`. Halaman menampilkan "Tidak tercantum di sumber data".
2. **Nama ambigu** — di docx tertulis **"HyperXomen i7 14650HX"**, diinterpretasikan sebagai **HP Omen**. Mohon konfirmasi nama resmi.
3. **Field "—" di docx** (ditampilkan "No Data"): cooling beberapa unit, serta baterai/garansi/berat pada ASUS ROG Strix G16 G614PH.
4. **HP Omen Ryzen 9 8940HX** — field cooling di docx tertulis "83Wh/230W" (kemungkinan salah entri, itu spek baterai), ditandai "No Data" agar tidak menyebar error.

---

## Verifikasi

- ✅ Array `laptops` di `rekomendasi.astro` valid (parse JS): 61 entry, 17 field lengkap semua, tanpa slug ganda, 22 high-gaming.
- ✅ 22 file `.astro`: import `ReviewLayout` benar, semua prop wajib ada, `rating` numerik, tag seimbang, kategori "High Gaming" (didukung `ReviewLayout`).
- ⚠️ `astro build` penuh tidak bisa dijalankan di sandbox ini (folder OneDrive memblokir operasi cache vite). Disarankan jalankan `npm run build` lokal di komputermu sebelum deploy — struktur file sudah identik dengan template `gaming/` yang sudah bekerja.

---

## Rekomendasi Next Step

1. Input **harga** untuk 12 unit yang masih `-` (dan `hMin/hMax` di `rekomendasi.astro`) agar filter budget akurat.
2. Input **benchmark** (NanoReview / Passmark) + isi `pmMulti` per laptop; section benchmark saat ini di-skip.
3. Lengkapi **2 CPU** yang kosong dan konfirmasi nama **"HyperXomen"**.
4. Sesuaikan **rating** (saat ini provisional per tier: 5050≈4.2 → 5080=4.7) sesuai penilaianmu.
5. Jalankan `npm run build` lokal, lalu `git commit` & deploy.
