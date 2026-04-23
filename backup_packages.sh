#!/bin/bash

# 1. ตั้งค่า วันที่-เวลา
DATETIME=$(date "+%Y-%m-%d_%H-%M")
OUTPUT_FILE="install_my_packages_${DATETIME}.sh"
LOG_FILE="backup_log_${DATETIME}.txt"

# 2. รายการ Pattern ของ DE ที่เราต้องการจะ Ignore (ข้าม)
# คุณสามารถเพิ่มชื่อ DE อื่นๆ ลงใน regex นี้ได้
IGNORE_PATTERN="gnome|plasma|kde|xfce4|mate|deepin|budgie|cinnamon|lxqt|lxde|sway|hyprland"

{
    echo "=========================================="
    echo "เริ่มการสำรองข้อมูล (โหมดข้าม DE): $(date)"
    echo "Pattern ที่จะข้าม: $IGNORE_PATTERN"
    echo "=========================================="

    # สร้างส่วนหัวของไฟล์ติดตั้ง
    echo "#!/bin/bash" > "$OUTPUT_FILE"
    echo "# สร้างอัตโนมัติ (ไม่รวม DE) เมื่อ: $(date)" >> "$OUTPUT_FILE"
    echo "sudo pacman -Syu --needed --noconfirm \\" >> "$OUTPUT_FILE"

    # 3. ดึงรายชื่อ กรองออก และบันทึก
    # grep -Ev จะทำการเลือกบรรทัดที่ "ไม่ตรงกับ" pattern ที่ระบุ
    PACKAGES=$(pacman -Qeq | grep -Ev "$IGNORE_PATTERN")

    if [ -z "$PACKAGES" ]; then
        echo "[ERROR] ไม่พบแพ็กเกจหลังจากกรอง DE ออกแล้ว"
        exit 1
    fi

    echo "$PACKAGES" >> "$OUTPUT_FILE"

    # นับจำนวน
    TOTAL_BEFORE=$(pacman -Qeq | wc -l)
    TOTAL_AFTER=$(echo "$PACKAGES" | wc -l)
    IGNORED_COUNT=$((TOTAL_BEFORE - TOTAL_AFTER))

    echo "[INFO] รายการทั้งหมด: $TOTAL_BEFORE"
    echo "[INFO] ข้ามไป (DE): $IGNORED_COUNT รายการ"
    echo "[SUCCESS] บันทึกลงสคริปต์แล้ว: $TOTAL_AFTER รายการ"

    chmod +x "$OUTPUT_FILE"
    echo "=========================================="
} 2>&1 | tee "$LOG_FILE"
