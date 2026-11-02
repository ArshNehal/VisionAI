@echo off
REM Development mode: backend with auto-reload (port 8000) + Vite dev server with hot reload (port 5173)
setlocal
cd /d "%~dp0"
if not exist backend\.venv\Scripts\python.exe (echo Run setup.bat first. & exit /b 1)
start "VisionAI backend" cmd /k "cd /d %~dp0backend && ..\backend\.venv\Scripts\python.exe -m uvicorn app.main:app --reload --port 8000"
start "VisionAI frontend" cmd /k "cd /d %~dp0frontend && npm run dev -- --open"
