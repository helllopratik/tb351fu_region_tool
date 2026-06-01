#!/usr/bin/env python3
import os
import sys

def patch_proinfo(input_file, target_region):
    with open(input_file, 'rb') as f:
        data = bytearray(f.read())

    # Offsets for TB351FU (Lenovo Tab Plus)
    # 0x35: Numeric Region (01=ROW, 02=PRC)
    # 0x3c: Country Code (IN/US/etc -> CN)
    
    original_region_byte = data[0x35]
    original_cc = data[0x3c:0x3e].decode(errors='ignore')
    
    print(f"[*] Analyzing: {input_file}")
    print(f"[*] Current Region Byte [0x35]: {hex(original_region_byte)}")
    print(f"[*] Current Country Code [0x3c]: {original_cc}")

    if target_region == "PRC":
        data[0x35] = 0x32 # '2'
        data[0x3c:0x3e] = b'CN'
        print("[+] Changing to PRC (China)...")
    else:
        data[0x35] = 0x31 # '1'
        data[0x3c:0x3e] = b'IN' # Defaulting to IN for ROW
        print("[+] Changing to ROW (Global)...")

    # Verify changes
    new_region_byte = data[0x35]
    new_cc = data[0x3c:0x3e].decode(errors='ignore')
    
    output_file = f"modified/proinfo_{target_region.lower()}.bin"
    with open(output_file, 'wb') as f:
        f.write(data)
    
    print("-" * 30)
    print(f"[!] Verification After Patch:")
    print(f"    Region Byte: {hex(new_region_byte)}")
    print(f"    Country Code: {new_cc}")
    print(f"[SUCCESS] Saved to: {output_file}")

if __name__ == "__main__":
    print("TB351FU Proinfo Region Patcher")
    print("=" * 30)
    
    if not os.path.exists("modified"):
        os.makedirs("modified")

    files = [f for f in os.listdir(".") if "proinfo" in f and f.endswith(".bin")]
    if not files:
        # Check backups folder
        print("[!] No proinfo.bin found in current directory.")
        sys.exit(1)

    print("Available files:")
    for i, f in enumerate(files):
        print(f" {i}. {f}")
    
    choice = int(input("Select file index: "))
    target = input("Target Region (PRC/ROW): ").strip().upper()
    
    if target not in ["PRC", "ROW"]:
        print("[!] Invalid target region.")
        sys.exit(1)
        
    patch_proinfo(files[choice], target)
