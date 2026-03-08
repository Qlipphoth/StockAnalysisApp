@echo off
REM run_doc2img.bat — runs Doc2Img.py using the specified Python and writes logs
setlocal
set PYTHON=D:\conda\envs\stock\python.exe
set SCRIPT=%~dp0Scripts\Doc2Img.py
set LOGDIR=%~dp0logs
if not exist "%LOGDIR%" mkdir "%LOGDIR%"
endlocal
necho Done. Log: %LOGFILE%echo [%ENDTIME%] Finished with exit code %EXITCODE% >> "%LOGFILE%"for /f "usebackq delims=" %%t in (`powershell -NoProfile -Command "Get-Date -Format 'yyyyMMdd_HHmmss'"`) do set ENDTIME=%%tset EXITCODE=%ERRORLEVEL%"%PYTHON%" "%SCRIPT%" >> "%LOGFILE%" 2>&1
necho [%TIMESTAMP%] Starting Doc2Img.py > "%LOGFILE%"set LOGFILE=%LOGDIR%\doc2img_%TIMESTAMP%.lognfor /f "usebackq delims=" %%t in (`powershell -NoProfile -Command "Get-Date -Format 'yyyyMMdd_HHmmss'"`) do set TIMESTAMP=%%t
@echo off
REM run_doc2img.bat — runs Doc2Img.py using the specified Python and writes logs
setlocal
set PYTHON=D:\conda\envs\stock\python.exe
set SCRIPT=%~dp0Scripts\Doc2Img.py
set LOGDIR=%~dp0logs
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

for /f "usebackq delims=" %%t in (`powershell -NoProfile -Command "Get-Date -Format 'yyyyMMdd_HHmmss'"`) do set TIMESTAMP=%%t

set LOGFILE=%LOGDIR%\doc2img_%TIMESTAMP%.log

echo [%TIMESTAMP%] Starting Doc2Img.py > "%LOGFILE%"
"%PYTHON%" "%SCRIPT%" >> "%LOGFILE%" 2>&1
set EXITCODE=%ERRORLEVEL%

for /f "usebackq delims=" %%t in (`powershell -NoProfile -Command "Get-Date -Format 'yyyyMMdd_HHmmss'"`) do set ENDTIME=%%t
echo [%ENDTIME%] Finished with exit code %EXITCODE% >> "%LOGFILE%"

echo Done. Log: %LOGFILE%
endlocal