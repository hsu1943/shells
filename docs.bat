@echo off
echo auto commit start.

set dateStr=%date:~3,4%%date:~8,2%%date:~11,2%

D:
cd D:\documents\docs
 
git add .
git commit -m "auto commit %dateStr%"
git push

echo auto commit done.