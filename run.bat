@echo off
REM Starts the backend, which also serves the built web UI at http://localhost:8000
setlocal
cd /d "%~dp0"
if not exist backend\.venv\Scripts\python.exe (echo Run setup.bat first. & exit /b 1)
if not exist frontend\dist\index.html (echo Web UI not built - run setup.bat first. & exit /b 1)
echo Starting VisionAI on http://localhost:8000  (Ctrl+C to stop)
echo Models load in the background - the page shows their status.
start "" /b cmd /c "timeout /t 4 >nul & start http://localhost:8000"
pushd backend
"..\backend\.venv\Scripts\python.exe" -m uvicorn app.main:app --host 127.0.0.1 --port 8000
popd
