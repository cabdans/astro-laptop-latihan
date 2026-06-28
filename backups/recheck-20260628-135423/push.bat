@echo off
cd /d "C:\Users\cahya\OneDrive\Documents\Claude\Projects\astro-laptop-latihan"

del /f .git\HEAD.lock 2>nul
del /f .git\index.lock 2>nul

git add -A
git commit --allow-empty -m "update"
git push origin main
echo Done!
