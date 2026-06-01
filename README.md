# TB351FU (Lenovo Tab Plus) Region Conversion Tools & Research

This repository contains tools and documentation for converting the Lenovo Tab Plus (TB351FU) between Global (ROW) and Chinese (PRC/ZUI) regions. This is the result of extensive testing on MediaTek (MT6789) hardware.

## ⚠️ CRITICAL WARNINGS
- **PRIVATE DATA:** The `proinfo` partition contains your unique **Serial Number** and **Widevine L1 DRM keys**. 
- **NEVER** share your `proinfo.bin` or flash a file from another user. Doing so will permanently break your Netflix HD (Widevine) and Warranty.
- **BOOTLOADER:** Always keep your original **Global (ROW) Preloader and LK (Bootloader)**. Flashing Chinese bootloaders on Global hardware leads to a "Black Screen" hard brick.

> [!NOTE]
> TB351FU DevHub link for users who want to all the development related links in one place including custom roms and recovery [TB351FU_Dev_HUB](https://helllopratik.github.io/tb351fu/).

---

## 🧪 Research Findings (Success & Failure)

### ✅ What Works (The "Hybrid" Method)
1. **The Handshake:** By patching the `proinfo` partition to `CNXX`, the device identity aligns with the ZUI 17 software.
2. **The Bypass:** Using the **ROW Bootloader** (Orange State) with **CN System Content** (super, boot, dtbo) works **ONLY** if you disable AVB verification.
3. **Recovery:** We successfully booted into a ZUI 17 recovery while using the ROW boot chain. This confirmed that the kernel was running, but the system was being blocked by regional security checks.
4. **The Fix:** Running `fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img` is required to stop the "Big Orange Screen" or "OS is Corrupted" loops.

### ❌ What Fails (The "Full" Method)
1. **CN Bootloader on ROW Hardware:** **FAILED**. This causes an instant black-screen bootloop because the ROW Preloader rejects the CN Bootloader's signature.
2. **Region Mismatch:** Flashing ZUI 17 without patching `proinfo` leads to the error: *"Current system is not compatible with the hardware."*
3. **Locked Bootloader:** A locked bootloader will strictly refuse any cross-region flashing. **Orange State must be visible.**

---

## 🛠 How to Flash the Patch

By default, the `proinfo` partition is "Protected" in SP Flash Tool. To flash your patched file, you must modify your `MT6789_Android_scatter.xml` (or `flash.xml`).

### 1. Enable proinfo in Scatter/XML
Search for the `proinfo` section and change `is_download` to `true` and `operation_type` to `UPDATE`.

**Required Segment:**
```xml
<partition_index name="SYS10">
      <partition_name>proinfo</partition_name>
      <file_name>proinfo_prc.bin</file_name>
      <is_download>true</is_download>
      <type>NORMAL_ROM</type>
      <linear_start_addr>0x27400000</linear_start_addr>
      <physical_start_addr>0x27400000</physical_start_addr>
      <partition_size>0x300000</partition_size>
      <region>UFS_LU2</region>
      <storage>HW_STORAGE_UFS</storage>
      <boundary_check>true</boundary_check>
      <is_reserved>false</is_reserved>
      <operation_type>UPDATE</operation_type>
      <is_upgradable>true</is_upgradable>
</partition_index>
```

### 2. Flashing Steps
1. Use `2_patch_region.py` to create your `proinfo_prc.bin`.
2. Update the scatter file as shown above.
3. In SP Flash Tool, select the modified scatter.
4. Flash `proinfo_prc.bin` via BROM Mode (Vol Up + Vol Down).
5. **Wipe Data:** You MUST perform a factory reset after flashing for the new region identity to take effect.

---

## 📂 Tool Usage
- `1_backup_partitions.sh`: Backup your unique IDs (Root required).
- `2_patch_region.py`: Patches `INXX/USXX` to `CNXX` and sets the region byte to `0x32`.

