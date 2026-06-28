@echo off
cd /d "C:\Users\cahya\OneDrive\Documents\Claude\Projects\astro-laptop-latihan"
echo.
echo [ROLLBACK] Mengembalikan ke versi sebelum mobile redesign...
echo.

copy /y "backups\BaseLayout.backup.astro"  "src\layouts\BaseLayout.astro"
copy /y "backups\index.backup.astro"       "src\pages\index.astro"
copy /y "backups\review-index.backup.astro" "src\pages\review\index.astro"

echo.
echo [ROLLBACK] Selesai! Jalankan push.bat untuk deploy rollback ke Vercel.
echo.
pause
