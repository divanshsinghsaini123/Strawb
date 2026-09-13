#!/bin/bash
set -e

# Always run inside apps/postgress directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Ensure backups directory exists
BACKUPS_DIR="$SCRIPT_DIR/backups"
mkdir -p "$BACKUPS_DIR"

# Detect Docker binary (handles WSL / Git Bash / Linux / Windows)
DOCKER_CMD="docker"
if grep -qi microsoft /proc/version 2>/dev/null; then
  # Inside WSL: check if Windows Docker Desktop binary is available
  if command -v docker.exe &>/dev/null; then
    DOCKER_CMD="docker.exe"
  elif [ -f "/mnt/c/Program Files/Docker/Docker/resources/bin/docker.exe" ]; then
    DOCKER_CMD="/mnt/c/Program Files/Docker/Docker/resources/bin/docker.exe"
  fi
elif ! command -v docker &>/dev/null && command -v docker.exe &>/dev/null; then
  DOCKER_CMD="docker.exe"
fi

# Fetch running containers and strip Windows carriage returns (\r)
RUNNING_CONTAINERS=$($DOCKER_CMD ps --format '{{.Names}}' 2>/dev/null | tr -d '\r')

# Detect container: look for medusa-postgres first (local), then strawb_postgres (server)
DETECTED_CONTAINER=""
if echo "$RUNNING_CONTAINERS" | grep -qi "^medusa-postgres$"; then
  DETECTED_CONTAINER="medusa-postgres"
elif echo "$RUNNING_CONTAINERS" | grep -qi "^strawb_postgres$"; then
  DETECTED_CONTAINER="strawb_postgres"
elif echo "$RUNNING_CONTAINERS" | grep -qi "postgres"; then
  DETECTED_CONTAINER=$(echo "$RUNNING_CONTAINERS" | grep -i "postgres" | head -n 1)
fi

CONTAINER_NAME="${1:-$DETECTED_CONTAINER}"
if [ -z "$CONTAINER_NAME" ]; then
  CONTAINER_NAME="strawb_postgres"
fi

DB_USER="strawb-user"
DB_NAME="strawb-db"

# Generate timestamp (format: YYYYMMDD_HHMMSS, e.g., 20260913_153045)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TIMESTAMPED_FILE="$BACKUPS_DIR/backup_${TIMESTAMP}.sql"
LATEST_FILE="$SCRIPT_DIR/latest.sql"

echo "=========================================="
echo "🚀 Strawb Database Backup"
echo "=========================================="
echo "Docker Command:   $DOCKER_CMD"
echo "Target Container: $CONTAINER_NAME"
echo "Database:         $DB_NAME"
echo "Latest File:      $LATEST_FILE"
echo "Archive Folder:   $BACKUPS_DIR"
echo "Timestamp:        $TIMESTAMP"
echo "------------------------------------------"

# Verify if docker container is running
if ! echo "$RUNNING_CONTAINERS" | grep -qi "^$CONTAINER_NAME$"; then
  echo "❌ Error: Could not find running container '$CONTAINER_NAME'."
  echo "Running containers found:"
  if [ -n "$RUNNING_CONTAINERS" ]; then
    echo "$RUNNING_CONTAINERS" | sed 's/^/  - /'
  else
    echo "  (none)"
    echo "💡 Note: If running inside WSL, make sure Docker Desktop -> Settings -> Resources -> WSL Integration is turned ON."
  fi
  exit 1
fi

echo "⏳ Creating database dump..."
$DOCKER_CMD exec -i "$CONTAINER_NAME" pg_dump -U "$DB_USER" -d "$DB_NAME" > "$LATEST_FILE"

# Check if file was created and is not empty
if [ ! -s "$LATEST_FILE" ]; then
  echo "❌ Error: Backup file is empty or failed to generate."
  rm -f "$LATEST_FILE"
  exit 1
fi

# Copy timestamped historical copy into backups folder
cp "$LATEST_FILE" "$TIMESTAMPED_FILE"

FILESIZE=$(du -h "$LATEST_FILE" 2>/dev/null | cut -f1)

echo "------------------------------------------"
echo "✅ Backup completed successfully!"
echo "📁 Latest (inside apps/postgress): $LATEST_FILE ($FILESIZE)"
echo "📁 Archive (inside backups/):      $TIMESTAMPED_FILE ($FILESIZE)"
echo "=========================================="
PS D:\strawb\apps\postgress> .\backup.bat
'backups' is not recognized as an internal or external command,
operable program or batch file.
'R_NAME' is not recognized as an internal or external command,
operable program or batch file.
'rmat' is not recognized as an internal or external command,
operable program or batch file.
PS D:\strawb\apps\postgress> 


