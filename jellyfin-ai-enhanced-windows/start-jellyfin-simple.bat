@echo off
REM Simple Jellyfin AI-Enhanced Edition Startup Script
REM This script automatically detects the correct way to start Jellyfin

echo.
echo 🤖 Jellyfin AI-Enhanced Edition - Simple Startup
echo ================================================

REM Load configuration if it exists
if exist "jellyfin-config.bat" (
    echo 🔧 Loading configuration...
    call jellyfin-config.bat
) else (
    echo 🔧 Using default configuration...
    set JELLYFIN_PORT=8096
    set JELLYFIN_DATA_DIR=%USERPROFILE%\AppData\Local\jellyfin
    set JELLYFIN_LOG_DIR=%USERPROFILE%\AppData\Local\jellyfin\log
    set JELLYFIN_CACHE_DIR=%USERPROFILE%\AppData\Local\jellyfin\cache
    set JELLYFIN_EXTRA_ARGS=
    set AUTO_OPEN_BROWSER=true
)

REM Check if jellyfin.exe exists
if not exist "jellyfin.exe" (
    echo ❌ Error: jellyfin.exe not found in current directory
    echo Please make sure you're in the jellyfin-ai-enhanced-windows folder
    pause
    exit /b 1
)

REM Handle command line arguments
if "%1"=="--port" (
    if not "%2"=="" (
        set JELLYFIN_PORT=%2
        echo 🔧 Using command line port: %JELLYFIN_PORT%
    )
)

if "%1"=="--help" goto :show_help

REM Create directories
if not exist "%JELLYFIN_DATA_DIR%" mkdir "%JELLYFIN_DATA_DIR%" 2>nul
if not exist "%JELLYFIN_LOG_DIR%" mkdir "%JELLYFIN_LOG_DIR%" 2>nul
if not exist "%JELLYFIN_CACHE_DIR%" mkdir "%JELLYFIN_CACHE_DIR%" 2>nul

echo.
echo 📁 Data directory: %JELLYFIN_DATA_DIR%
echo 🌐 Web interface: http://localhost:%JELLYFIN_PORT%
echo 🧠 AI Demo page: http://localhost:%JELLYFIN_PORT%/ai-recommendations-demo.html
echo.

REM Check if port is available
netstat -an 2>nul | find ":%JELLYFIN_PORT% " >nul 2>&1
if %errorlevel% == 0 (
    echo ⚠️  Warning: Port %JELLYFIN_PORT% is already in use
    echo    Edit jellyfin-config.bat to change the port
    echo.
)

echo 🚀 Starting Jellyfin...

REM Set environment variables
set JELLYFIN_DATA_DIR=%JELLYFIN_DATA_DIR%
set JELLYFIN_LOG_DIR=%JELLYFIN_LOG_DIR%
set JELLYFIN_CACHE_DIR=%JELLYFIN_CACHE_DIR%

REM Try different startup methods until one works
echo 🔍 Auto-detecting startup method...

REM Method 1: ASP.NET Core URLs (most common for newer versions)
jellyfin.exe --urls "http://localhost:%JELLYFIN_PORT%" --datadir "%JELLYFIN_DATA_DIR%" %JELLYFIN_EXTRA_ARGS% >nul 2>&1 &
timeout /t 3 /nobreak >nul
tasklist | find "jellyfin.exe" >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ Started with ASP.NET Core format
    goto :started
)

REM Method 2: Traditional format
jellyfin.exe --datadir "%JELLYFIN_DATA_DIR%" --port %JELLYFIN_PORT% %JELLYFIN_EXTRA_ARGS% >nul 2>&1 &
timeout /t 3 /nobreak >nul
tasklist | find "jellyfin.exe" >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ Started with traditional format
    goto :started
)

REM Method 3: Minimal arguments
jellyfin.exe --datadir "%JELLYFIN_DATA_DIR%" %JELLYFIN_EXTRA_ARGS% >nul 2>&1 &
timeout /t 3 /nobreak >nul
tasklist | find "jellyfin.exe" >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ Started with minimal arguments (using default port)
    goto :started
)

REM Method 4: No arguments (last resort)
echo 🚀 Trying default startup...
start /min jellyfin.exe
timeout /t 3 /nobreak >nul
tasklist | find "jellyfin.exe" >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ Started with default settings
    goto :started
)

echo ❌ Failed to start Jellyfin with any method
echo.
echo 🔧 Troubleshooting tips:
echo   1. Try running: jellyfin.exe --help
echo   2. Check Windows Firewall settings
echo   3. Run as Administrator
echo   4. Check if antivirus is blocking the application
echo.
pause
exit /b 1

:started
echo.
echo ✅ Jellyfin AI-Enhanced Edition is starting up!
echo ⏳ Please wait 10-15 seconds for full startup...
echo.
echo 🌐 Web interface: http://localhost:%JELLYFIN_PORT%
echo 🧠 AI Demo page: http://localhost:%JELLYFIN_PORT%/ai-recommendations-demo.html
echo 📚 API docs: http://localhost:%JELLYFIN_PORT%/api-docs/swagger
echo.

REM Auto-open browser if configured
if "%AUTO_OPEN_BROWSER%"=="true" (
    echo 🌐 Opening browser...
    timeout /t 5 /nobreak >nul
    start http://localhost:%JELLYFIN_PORT%
)

echo Press any key to exit this window (Jellyfin will continue running)
pause >nul
exit /b 0

:show_help
echo Jellyfin AI-Enhanced Edition - Simple Startup
echo.
echo Usage:
echo   %0                    Start with default/configured settings
echo   %0 --port 8097        Start with custom port
echo   %0 --help             Show this help
echo.
echo Configuration:
echo   Edit jellyfin-config.bat to change default settings
echo.
echo Troubleshooting:
echo   If startup fails, try running as Administrator
echo   Check Windows Firewall and antivirus settings
echo.
pause
exit /b 0
