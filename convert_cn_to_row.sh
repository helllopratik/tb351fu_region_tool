#!/bin/bash

# TB351FU CN-to-ROW Conversion Script
# This script patches CN firmware images to be compatible with ROW hardware
# without modifying the sensitive proinfo partition.

IMAGE_DIR="./assets"
OUT_DIR="./modified"
MAGISKBOOT="./magiskboot"

mkdir -p "$OUT_DIR"

if [ ! -f "$MAGISKBOOT" ]; then
    echo "Error: magiskboot not found in current directory!"
    exit 1
fi

echo "--- TB351FU Region Patcher ---"

SUCCESS=0

# 1. Patch lk.img (Spoof countrycode to CN)
if [ -f "$IMAGE_DIR/lk.img" ]; then
    echo "[*] Patching lk.img..."
    cp "$IMAGE_DIR/lk.img" "$OUT_DIR/lk_patched.img"
    "$MAGISKBOOT" hexpatch "$OUT_DIR/lk_patched.img" 616e64726f6964626f6f742e636f756e747279636f64653d2573 616e64726f6964626f6f742e636f756e747279636f64653d434e
    SUCCESS=1
else
    echo "[!] Error: lk.img not found in $IMAGE_DIR"
fi

# 2. Patch dtbo.img (Change expected region to ROW)
if [ -f "$IMAGE_DIR/dtbo.img" ]; then
    echo "[*] Patching dtbo.img..."
    cp "$IMAGE_DIR/dtbo.img" "$OUT_DIR/dtbo_patched.img"
    "$MAGISKBOOT" hexpatch "$OUT_DIR/dtbo_patched.img" 50524300 524f5700
    SUCCESS=1
else
    echo "[!] Error: dtbo.img not found in $IMAGE_DIR"
fi

echo "--------------------------------"
if [ $SUCCESS -eq 1 ]; then
    echo "Done! Patched images are in $OUT_DIR"
    echo "Flash these images using SP Flash Tool v6 with the CN ROM scatter."
else
    echo "[FAIL] No images were patched. Please place lk.img and dtbo.img in $IMAGE_DIR"
    exit 1
fi
