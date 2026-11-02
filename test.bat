@echo off
REM Runs backend tests (fast + real-model integration) and frontend tests
setlocal
cd /d "%~dp0"
set VPY=%~dp0backend\.venv\Scripts\python.exe
"%VPY%" -m pip install -r backend\requirements-dev.txt -q
pushd backend
"%VPY%" scripts\fetch_test_data.py
"%VPY%" -m pytest -v
popd
pushd frontend
call npm test
popd
