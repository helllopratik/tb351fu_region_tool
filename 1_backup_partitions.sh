#!/bin/bash

# TB351FU Backup Script
# This script uses adb and fastboot to pull critical partitions.
# Note: For many of these, the device must be in a state where partitions are readable (Rooted or via specialized tools like mtkclient).

cat << "EOF"
  _______ ____  _________ __  _______ _    _ 
 |__   __|  _ \|____ ___|  _ \/ ____| |  | |
    | |  | |_) |   | |  | |_) | (___ | |  | |
    | |  |  _ <    | |  |  _ < \___ \| |  | |
    | |  | |_) |   | |  | |_) |____) | |__| |
    |_|  |____/    |_|  |____/|_____/ \____/ 
    
    TB351FU Region Tool - Backup Phase
EOF

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CURRENT_BKP="$BACKUP_DIR/backup_$TIMESTAMP"

mkdir -p "$CURRENT_BKP"

echo "[*] Initializing Backup..."

# Function to pull via ADB (requires root/custom recovery)
backup_adb() {
    local part=$1
    echo "[+] Attempting to backup $part via ADB..."
    adb shell su -c "dd if=/dev/block/by-name/$part of=/data/local/tmp/$part.bin"
    adb pull "/data/local/tmp/$part.bin" "$CURRENT_BKP/$part.bin"
    cp "$CURRENT_BKP/$part.bin" "$CURRENT_BKP/$part.img"
    adb shell su -c "rm /data/local/tmp/$part.bin"
}

# Check for device
if adb devices | grep -q "device$"; then
    echo "[!] Device detected in ADB mode."
    for p in proinfo nvram nvdata; do
        backup_adb $p
    done
else
    echo "[?] ADB device not found or unauthorized."
    echo "[!] If you are in Fastboot mode, note that most Mediatek devices do not allow 'pulling' partitions directly."
    echo "[!] Use MTKClient or SP Flash Tool Readback to get your proinfo.bin, then place it in $CURRENT_BKP"
fi

echo "[*] Backup process finished."
echo "[*] Files saved to: $CURRENT_BKP"
