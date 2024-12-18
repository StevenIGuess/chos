

BUILD_DIR=build
SRC_DIR=src

.PHONY: all image kernel bootloader clean always


#
# Image
#

image: $(BUILD_DIR)/main_drive.img

$(BUILD_DIR)/main_drive.img: bootloader 
	cp $(BUILD_DIR)/bootloader.bin $(BUILD_DIR)/main_drive.img
	truncate -s 1440k $(BUILD_DIR)/main_drive.img
	#dd if=/dev/zero of=$(BUILD_DIR)/main_drive.img bs=512 count=2880
	#mkfs.fat -F 12 -n "NBOS" $(BUILD_DIR)/main_drive.img
	#dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main_drive.img conv=notrunc
	#mcopy -i $(BUILD_DIR)/main_drive.img $(BUILD_DIR)/kernel.bin "::kernel.bin"

#
# Bootloader
#
bootloader: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: always
	nasm -f bin $(SRC_DIR)/bootloader.asm -o $(BUILD_DIR)/bootloader.bin


#
# Always
#
always:
	mkdir -p $(BUILD_DIR) 


qemu: image
		qemu-system-x86_64 -fda $(BUILD_DIR)/main_drive.img


clean:
		rm $(BUILD_DIR)/*
