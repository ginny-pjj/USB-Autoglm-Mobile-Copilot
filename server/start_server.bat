@echo off
chcp 65001 > nul
cd /d D:\autoglm-mobile-work\server
set PYTHONIOENCODING=utf-8
set PYTHONUTF8=1
D:\autoglm-mobile-work\.venv\Scripts\python.exe -m uvicorn main:app --host 0.0.0.0 --port 8000
