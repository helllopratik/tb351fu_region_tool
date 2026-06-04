#!/bin/bash

# TB351FU ROW-to-CN Conversion Script
# This script patches ROW firmware images to be compatible with CN hardware
# (Used when installing Global ROM on a Chinese tablet)

IMAGE_DIR="./assets"
OUT_DIR="./modified"
MAGISKBOOT="./magiskboot"

mkdir -p "$OUT_DIR"

if [ ! -f "$MAGISKBOOT" ]; then
    echo "Error: magiskboot not found in current directory!"
    exit 1
fi

echo "--- TB351FU Region Patcher (ROW ROM -> CN HW) ---"

SUCCESS=0

# 1. Patch lk.img (Spoof countrycode to IN)
# We use 'IN' as it is the default for most TB351FU ROW backups
if [ -f "$IMAGE_DIR/lk.img" ]; then
    echo "[*] Patching lk.img..."
    cp "$IMAGE_DIR/lk.img" "$OUT_DIR/lk_row_patched.img"
    # Replace 'androidboot.countrycode=%s' with 'androidboot.countrycode=IN'
    # Hex: 616e64726f6964626f6f742e636f756e747279636f64653d2573 -> 616e64726f6964626f6f742e636f756e747279636f64653d494e
    "$MAGISKBOOT" hexpatch "$OUT_DIR/lk_row_patched.img" 616e64726f6964626f6f742e636f756e747279636f64653d2573 616e64726f6964626f6f742e636f756e747279636f64653d494e
    SUCCESS=1
else
    echo "[!] Error: lk.img not found in $IMAGE_DIR"
fi

# 2. Patch dtbo.img (Change expected region to PRC)
if [ -f "$IMAGE_DIR/dtbo.img" ]; then
    echo "[*] Patching dtbo.img..."
    cp "$IMAGE_DIR/dtbo.img" "$OUT_DIR/dtbo_row_patched.img"
    # Replace 'ROW\0' with 'PRC\0'
    # Hex: 524f5700 -> 50524300
    "$MAGISKBOOT" hexpatch "$OUT_DIR/dtbo_row_patched.img" 524f5700 50524300
    SUCCESS=1
else
    echo "[!] Error: dtbo.img not found in $IMAGE_DIR"
fi

echo "--------------------------------"
if [ $SUCCESS -eq 1 ]; then
    echo "Done! Patched images are in $OUT_DIR"
    echo "Flash these images using SP Flash Tool v6 with the ROW ROM scatter."
else
    echo "[FAIL] No images were patched. Please place lk.img and dtbo.img in $IMAGE_DIR"
    exit 1
fi
