@echo off
REM ============================================================================
REM  VisionAI - one-time setup for Windows 10/11
REM  Usage:  setup.bat            (auto-detect NVIDIA GPU)
REM          setup.bat cpu        (force CPU-only PyTorch)
REM          setup.bat cuda       (force CUDA PyTorch)
REM ============================================================================
setlocal
cd /d "%~dp0"
set MODE=%1
if "%MODE%"=="" set MODE=auto

echo [1/6] Checking Python...
set PY=
for %%V in (3.12 3.11 3.10) do (
  if not defined PY (
    py -%%V --version >nul 2>&1 && set PY=py -%%V
  )
)
if not defined PY (
  echo ERROR: Python 3.10, 3.11 or 3.12 was not found. Install it from https://www.python.org/downloads/
  echo        and tick "Add python.exe to PATH" / keep the "py launcher" option enabled.
  exit /b 1
)
echo       Using: %PY%

echo [2/6] Creating virtual environment backend\.venv ...
if not exist backend\.venv\Scripts\python.exe (
  %PY% -m venv backend\.venv || (echo ERROR: could not create venv & exit /b 1)
)
set VPY=%~dp0backend\.venv\Scripts\python.exe
"%VPY%" -m pip install --upgrade pip || exit /b 1

echo [3/6] Installing PyTorch (mode: %MODE%) ...
if /i "%MODE%"=="auto" (
  nvidia-smi >nul 2>&1 && (set MODE=cuda) || (set MODE=cpu)
  echo       Auto-detected mode: %MODE%
)
if /i "%MODE%"=="cuda" (
  REM If this wheel index is outdated for your driver, copy the command from https://pytorch.org/get-started/locally/
  "%VPY%" -m pip install torch torchvision --index-url https://download.pytorch.org/whl/cu126
) else (
  "%VPY%" -m pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
)
if errorlevel 1 (echo ERROR: PyTorch installation failed. & exit /b 1)

echo [4/6] Installing backend dependencies ...
"%VPY%" -m pip install -r backend\requirements.txt || (echo ERROR: dependency installation failed & exit /b 1)
"%VPY%" -c "import torch;print('       PyTorch',torch.__version__,'| CUDA available:',torch.cuda.is_available())"

echo [5/6] Downloading AI models (first time only; the caption model is ~1.8 GB) ...
pushd backend
"%VPY%" scripts\download_models.py || (echo WARNING: model download reported a problem - see messages above)
popd

echo [6/6] Building the web interface ...
where node >nul 2>&1 || (echo ERROR: Node.js 18+ was not found. Install the LTS version from https://nodejs.org/ and re-run setup.bat & exit /b 1)
pushd frontend
call npm install --no-audit --no-fund || (echo ERROR: npm install failed & popd & exit /b 1)
call npm run build || (echo ERROR: frontend build failed & popd & exit /b 1)
popd

echo.
echo Setup complete.  Start the app with:  run.bat
exit /b 0
