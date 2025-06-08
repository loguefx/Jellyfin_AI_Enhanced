@echo off
REM Jellyfin AI-Enhanced Edition Configuration File
REM Users can edit these settings to customize their Jellyfin installation

REM =============================================================================
REM USER CONFIGURABLE SETTINGS
REM =============================================================================

REM Default port for Jellyfin web interface
REM Change this if port 8096 is already in use
set JELLYFIN_PORT=8096

REM Data directory (where Jellyfin stores its database and configuration)
REM Default: %USERPROFILE%\AppData\Local\jellyfin
REM You can change this to any folder you prefer
set JELLYFIN_DATA_DIR=%USERPROFILE%\AppData\Local\jellyfin

REM Log directory (where Jellyfin stores log files)
set JELLYFIN_LOG_DIR=%USERPROFILE%\AppData\Local\jellyfin\log

REM Cache directory (where Jellyfin stores temporary files)
set JELLYFIN_CACHE_DIR=%USERPROFILE%\AppData\Local\jellyfin\cache

REM =============================================================================
REM ADVANCED SETTINGS (modify only if you know what you're doing)
REM =============================================================================

REM Additional Jellyfin arguments
REM Add any extra command line arguments here
set JELLYFIN_EXTRA_ARGS=

REM Startup timeout (seconds to wait for Jellyfin to start)
set STARTUP_TIMEOUT=30

REM Auto-open browser after startup (true/false)
set AUTO_OPEN_BROWSER=true

REM =============================================================================
REM EXAMPLES OF COMMON CONFIGURATIONS
REM =============================================================================

REM Example 1: Use a different port
REM set JELLYFIN_PORT=8097

REM Example 2: Use a custom data directory
REM set JELLYFIN_DATA_DIR=D:\MyJellyfin\Data

REM Example 3: Store everything in a custom location
REM set JELLYFIN_DATA_DIR=C:\JellyfinServer\Data
REM set JELLYFIN_LOG_DIR=C:\JellyfinServer\Logs
REM set JELLYFIN_CACHE_DIR=C:\JellyfinServer\Cache

REM Example 4: Add extra arguments
REM set JELLYFIN_EXTRA_ARGS=--nowebclient

REM =============================================================================
REM DO NOT MODIFY BELOW THIS LINE
REM =============================================================================

echo Configuration loaded:
echo   Port: %JELLYFIN_PORT%
echo   Data: %JELLYFIN_DATA_DIR%
echo   Logs: %JELLYFIN_LOG_DIR%
echo   Cache: %JELLYFIN_CACHE_DIR%
if not "%JELLYFIN_EXTRA_ARGS%"=="" echo   Extra args: %JELLYFIN_EXTRA_ARGS%
