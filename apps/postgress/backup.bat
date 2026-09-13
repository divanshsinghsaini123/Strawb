@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

if not exist backups mkdir backups

set "CONTAINER_NAME=medusa-postgres"
docker ps --format "{{.Names}}" | findstr /i /c:"medusa-postgres" >nul 2>&1
if errorlevel 1 (
    docker ps --format "{{.Names}}" | findstr /i /c:"strawb_postgres" >nul 2>&1
    if not errorlevel 1 (
        set "CONTAINER_NAME=strawb_postgres"
    ) else (
        for /f "tokens=*" %%C in ('docker ps --filter "name=postgres" --format "{{.Names}}"') do (
            set "CONTAINER_NAME=%%C"
            goto :found_container
        )
    )
)

:found_container
set "DB_USER=strawb-user"
set "DB_NAME=strawb-db"

for /f %%A in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "TIMESTAMP=%%A"

set "BACKUP_FILE=backups\backup_%TIMESTAMP%.sql"
set "LATEST_FILE=latest.sql"

echo ==========================================
echo [*] Strawb Database Backup
echo ==========================================
echo Target Container: %CONTAINER_NAME%
echo Database:         %DB_NAME%
echo Latest File:      %LATEST_FILE%
echo Archive Folder:   backups
echo Timestamp:        %TIMESTAMP%
echo ------------------------------------------

docker ps --format "{{.Names}}" | findstr /i /c:"%CONTAINER_NAME%" >nul 2>&1
if errorlevel 1 (
    echo [!] Error: Container '%CONTAINER_NAME%' is not running.
    echo Running containers found:
    docker ps --format "  - {{.Names}} ({{.Image}})"
    exit /b 1
)

echo [*] Creating database dump...
docker exec -i %CONTAINER_NAME% pg_dump -U %DB_USER% -d %DB_NAME% > %LATEST_FILE%

if not exist "%LATEST_FILE%" (
    echo [!] Error: Backup failed to generate.
    exit /b 1
)

copy /y "%LATEST_FILE%" "%BACKUP_FILE%" >nul

echo ------------------------------------------
echo [+] Backup completed successfully!
echo [*] Latest:  %~dp0%LATEST_FILE%
echo [*] Archive: %~dp0%BACKUP_FILE%
echo ==========================================
