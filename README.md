# TB351FU (Lenovo Tab Plus) Region Conversion Toolkit

![Region Tool Banner](./assets/region-tool-banner.svg)

This repository contains tools to convert the **Lenovo Tab Plus (TB351FU)** between Global (ROW) hardware and the Chinese (PRC/ZUI) ROM.

## 🚀 NO PROINFO FLASHING REQUIRED
> [!IMPORTANT]
> **DO NOT flash `proinfo.bin`.** Our research has confirmed that modifying the `proinfo` partition is **NOT** necessary to boot cross-region ROMs and carries high risk (losing Serial Number and Widevine L1). 
> 
> The region lock is bypassed by patching the **Bootloader (LK)** and **Device Tree (DTBO)** instead.

---

## 🧪 How it Works
The TB351FU bootloader checks if the hardware region (stored in RPMB) matches the software region (defined in DTBO). If they do not match, the device displays a "Hardware incompatible" error and powers off.

**The Bypass Logic:**
1.  **DTBO Patch:** Changes the "Expected" region in the firmware to match your physical hardware. 
    - (e.g. Change CN firmware from expecting `PRC` to expecting `ROW`).
2.  **LK Patch:** Spoofs the system property `androidboot.countrycode`. 
    - (e.g. Force CN ROM to see `CN` so ZUI features work, or force ROW ROM to see `IN/US` so Google services work).

---

## 🛠 Usage Instructions

### 1. Prerequisites
-   **Bootloader Unlocked** (Orange State must be visible).
-   ROM Firmware files (Stock CN or stock ROW).
-   Linux environment (or WSL) to run the patch script.

### 2. Patching the Firmware

#### Option A: Install CN ROM on Global (ROW) Hardware
1.  Copy **`lk.img`** and **`dtbo.img`** from your **CN ROM** folder into the **`assets/`** directory.
2.  Run the script:
    ```bash
    chmod +x convert_cn_to_row.sh
    ./convert_cn_to_row.sh
    ```
3.  Flash the files in **`modified/`** using the CN Scatter.

#### Option B: Install Global (ROW) ROM on Chinese hardware
1.  Copy **`lk.img`** and **`dtbo.img`** from your **ROW ROM** folder into the **`assets/`** directory.
2.  Run the script:
    ```bash
    chmod +x convert_row_to_cn.sh
    ./convert_row_to_cn.sh
    ```
3.  Flash the files in **`modified/`** using the ROW Scatter.

### 3. Flashing & Final Steps
1.  Open **SP Flash Tool v6**.
2.  Load the target ROM Scatter file.
3.  In the partition list, replace `dtbo` and `lk` with the patched versions from the **`modified/`** folder.
4.  **Keep all other original files** from the target ROM.
5.  Flash using **"Download Only"** mode.
6.  **Wipe Data:** After flashing, you **must** enter recovery and perform a **Factory Reset** (Format Userdata/Metadata) to boot successfully.

---

## 📂 File Structure
-   `convert_cn_to_row.sh`: Patches CN firmware for ROW tablets.
-   `convert_row_to_cn.sh`: Patches ROW firmware for CN tablets.
-   `magiskboot`: The core utility used for hex patching.
-   `assets/`: Place your stock images here.
-   `modified/`: The output folder for compatible images.

---

> [!NOTE]
> For more development links, custom recoveries, and ROMs, visit the [TB351FU DevHub](https://helllopratik.github.io/tb351fu/).
