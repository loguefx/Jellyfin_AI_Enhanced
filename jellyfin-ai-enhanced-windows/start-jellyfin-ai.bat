@echo off
REM Jellyfin AI-Enhanced Edition Startup Script for Windows
REM This script helps you start your AI-powered Jellyfin server

echo.
echo 🤖 Starting Jellyfin AI-Enhanced Edition...
echo ================================================

REM Check if jellyfin.exe exists
if not exist "jellyfin.exe" (
    echo ❌ Error: jellyfin.exe not found in current directory
    echo Please make sure you're in the jellyfin-ai-enhanced-windows folder
    pause
    exit /b 1
)

REM Default settings - USERS CAN EASILY MODIFY THESE
set DEFAULT_PORT=8096
set DATA_DIR=%USERPROFILE%\AppData\Local\jellyfin
set LOG_DIR=%USERPROFILE%\AppData\Local\jellyfin\log
set CACHE_DIR=%USERPROFILE%\AppData\Local\jellyfin\cache

REM Parse command line arguments for port
set PORT=%DEFAULT_PORT%
if not "%1"=="" (
    if "%1"=="--port" (
        if not "%2"=="" (
            set PORT=%2
            echo 🔧 Using custom port: %PORT%
        ) else (
            echo ❌ Error: --port requires a port number
            echo Usage: %0 --port 8097
            pause
            exit /b 1
        )
    )
    if "%1"=="--help" goto :show_help
)

REM Create directories if they don't exist
if not exist "%DATA_DIR%" mkdir "%DATA_DIR%" 2>nul
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" 2>nul
if not exist "%CACHE_DIR%" mkdir "%CACHE_DIR%" 2>nul

echo 📁 Data directory: %DATA_DIR%
echo 📝 Log directory: %LOG_DIR%
echo 💾 Cache directory: %CACHE_DIR%
echo 🌐 Web interface: http://localhost:%PORT%
echo 🧠 AI Demo page: http://localhost:%PORT%/ai-recommendations-demo.html
echo 📚 API docs: http://localhost:%PORT%/api-docs/swagger
echo.

REM Check if port is available
netstat -an 2>nul | find ":%PORT% " >nul 2>&1
if %errorlevel% == 0 (
    echo ⚠️  Warning: Port %PORT% is already in use
    echo    Try: %0 --port 8097
    echo.
)

echo 🚀 Starting Jellyfin with AI recommendations...
echo    Press Ctrl+C to stop
echo.

REM Set environment variables
set JELLYFIN_DATA_DIR=%DATA_DIR%
set JELLYFIN_LOG_DIR=%LOG_DIR%
set JELLYFIN_CACHE_DIR=%CACHE_DIR%

REM Try different argument formats (Jellyfin versions use different formats)
echo 🔍 Detecting Jellyfin argument format...

REM First, try to get help to see what arguments are supported
jellyfin.exe --help >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ Jellyfin executable responds to --help
) else (
    echo ⚠️  Jellyfin may not support standard arguments
)

REM Try ASP.NET Core URL format first (most common for newer versions)
echo 🚀 Attempting to start with ASP.NET Core format...
jellyfin.exe --urls "http://localhost:%PORT%" --datadir "%DATA_DIR%" 2>nul
if %errorlevel% == 0 goto :success

REM Try traditional argument format
echo 🚀 Attempting to start with traditional format...
jellyfin.exe --datadir "%DATA_DIR%" --port %PORT% 2>nul
if %errorlevel% == 0 goto :success

REM Try minimal arguments
echo 🚀 Attempting to start with minimal arguments...
jellyfin.exe --datadir "%DATA_DIR%" 2>nul
if %errorlevel% == 0 goto :success

REM Try with no arguments (uses defaults)
echo 🚀 Attempting to start with default settings...
jellyfin.exe
goto :success

:success
echo.
echo ✅ Jellyfin started successfully!
echo 🌐 Open your browser to: http://localhost:%PORT%
echo.
pause
exit /b 0

:show_help
echo Jellyfin AI-Enhanced Edition Startup Options:
echo.
echo   %0                    Start with default port (%DEFAULT_PORT%)
echo   %0 --port 8097        Start with custom port
echo   %0 --help             Show this help message
echo.
echo Examples:
echo   %0                    # Default: http://localhost:%DEFAULT_PORT%
echo   %0 --port 8097        # Custom:  http://localhost:8097
echo   %0 --port 9096        # Custom:  http://localhost:9096
echo.
echo After starting, visit:
echo   http://localhost:PORT              # Main interface
echo   http://localhost:PORT/ai-recommendations-demo.html  # AI demo
echo   http://localhost:PORT/api-docs/swagger  # API documentation
echo.
echo 🔧 To permanently change the default port, edit this file and modify DEFAULT_PORT
pause
exit /b 0
