# Data Kosong untuk Diisi Manual

Aku tidak mengisi data spesifikasi ini sendiri karena aturan proyek: **pakai data yang kamu input langsung, tanpa web search.**
Isi kolom kosong di bawah, lalu beri tahu aku — nanti aku terapkan ke `src/pages/rekomendasi.astro` (dan file review terkait) sekaligus.

> Setelah harga diisi, laptop-laptop ini akan otomatis muncul dengan benar di filter budget `/rekomendasi` (filter sudah diperbaiki agar laptop tanpa harga tidak lagi bocor ke semua rentang).

---

## A. 15 Laptop TANPA HARGA (`hMin`/`hMax` = 0, tampil "-")

Format harga mengikuti pola yang sudah ada, mis. `Rp 25 Juta` atau `Rp 25–27 Juta`. Sertakan juga `hMin` & `hMax` (angka juta) kalau bisa.

| # | Kategori | Laptop | slug | Harga (isi) | hMin | hMax |
|---|----------|--------|------|-------------|------|------|
| 1 | High Gaming | HP Omen Ryzen 9 8940HX RTX 5060 | high-gaming/hp-omen-8940hx-rtx5060 | | | |
| 2 | High Gaming | Acer Predator Helios Neo 16S Ultra 7 255HX RTX 5060 | high-gaming/acer-predator-helios-neo-16s-255hx-rtx5060 | | | |
| 3 | High Gaming | Lenovo LOQ 15AHP11 Ryzen AI 7 250 RTX 5060 | high-gaming/lenovo-loq-15ahp11-rtx5060 | | | |
| 4 | High Gaming | HP Omen i7-14650HX RTX 5060 | high-gaming/hp-omen-i7-14650hx-rtx5060 | | | |
| 5 | High Gaming | Acer Predator Helios Neo 16S Ultra 7 356H RTX 5060 | high-gaming/acer-predator-helios-neo-16s-ultra7-356h-rtx5060 | | | |
| 6 | High Gaming | ASUS TUF A16 FA608UP Ryzen AI 7 260 RTX 5070 | high-gaming/asus-tuf-a16-fa608up-rtx5070 | | | |
| 7 | High Gaming | Acer Predator Helios Neo 16S Ultra 9 386H RTX 5070 | high-gaming/acer-predator-helios-neo-16s-ultra9-386h-rtx5070 | | | |
| 8 | High Gaming | ASUS ROG Strix G16 2025 G614PR RTX 5070 Ti | high-gaming/asus-rog-strix-g16-g614pr-rtx5070ti | | | |
| 9 | High Gaming | Lenovo Legion Pro 5i 16 OLED Ultra 9 275HX RTX 5070 Ti | high-gaming/lenovo-legion-pro-5i-16-oled-rtx5070ti | | | |
| 10 | High Gaming | HP Omen Max 16 Ryzen AI 7 350 RTX 5070 Ti | high-gaming/hp-omen-max-16-rtx5070ti | | | |
| 11 | High Gaming | MSI Vector 16HX Ultra 9 275HX RTX 5080 | high-gaming/msi-vector-16hx-275hx-rtx5080 | | | |
| 12 | Ultrabook | Acer Swift Go 14 AI SFG14-73-73P9 | ultrabook/acer-swift-go-14-sfg14-73p9 | | | |
| 13 | Ultrabook | ASUS ExpertBook Ultra P5405CSA Ultra 7 258V | ultrabook/asus-expertbook-ultra-p5405csa-ultra7-258v | | | |
| 14 | Ultrabook | Acer Swift Go 14 AI SFG14-171 Ultra 7 358H | ultrabook/acer-swift-go-14-sfg14-171-ultra7-358h | | | |
| 15 | Ultrabook | ASUS ExpertBook B9400CBA Ultra 7 358H | ultrabook/asus-expertbook-b9400cba-ultra7-358h | | | |

---

## B. 3 Laptop CPU "Tidak tercantum"

Isi model CPU lengkap (mis. `AMD Ryzen 9 8940HX` / `Intel Core Ultra 9 275HX`). Jika ada, sertakan juga skor benchmark (pmMulti) agar section Benchmark CPU muncul.

| # | Kategori | Laptop | slug | CPU (isi) | pmMulti (opsional) |
|---|----------|--------|------|-----------|--------------------|
| 1 | High Gaming | Lenovo Legion 5i 15IRX10 OLED RTX 5050 | high-gaming/lenovo-legion-5i-15irx10-oled-rtx5050 | | |
| 2 | High Gaming | ASUS ROG Strix G16 2025 G614PR RTX 5070 Ti | high-gaming/asus-rog-strix-g16-g614pr-rtx5070ti | | |
| 3 | Ultrabook | Acer Swift Go 14 AI SFG14-73-73P9 | ultrabook/acer-swift-go-14-sfg14-73p9 | | |

---

## C. (Opsional) Data coverage rendah — bukan bug
- `bobot = 0` (berat tak tersedia) di **30 / 76** laptop.
- `pmMulti = 0` (benchmark tak ada) di **37 / 76** laptop.

Kalau kamu punya angka berat/benchmark untuk sebagian, kirim saja — aku isikan.
