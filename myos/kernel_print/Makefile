BUILD_DIR = ./build
ENTRY_POINT = 0xc0001500
AS = nasm
CC = gcc
LD = ld
LIB = -I lib/ -I lib/kernel/ -I lib/user/ -I kernel/ 
ASFLAGS = -f elf
CFLAGS = -Wall $(LIB) -c -fno-builtin -W -Wstrict-prototypes \
         -Wmissing-prototypes 
LDFLAGS = -Ttext $(ENTRY_POINT) -e main
OBJS = $(BUILD_DIR)/main.o $(BUILD_DIR)/print.o 
$(BUILD_DIR)/main.o: kernel/main.c lib/kernel/print.h 
	$(CC) $(CFLAGS) $< -o $@
$(BUILD_DIR)/print.o: lib/kernel/print.S
	$(AS) $(ASFLAGS) $< -o $@
######链接文件#########
$(BUILD_DIR)/kernel.bin: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@

###### make命令# ################
build:$(BUILD_DIR)/kernel.bin
mbr:
	$(AS) -I boot/include/ -o build/mbr.bin boot/mbr.S
loader:
	$(AS) -I boot/include/ -o build/loader.bin boot/loader.S
clean:
	rm -rf *.bin
	rm -rf build/*.bin
loadmbr:
	dd if=build/mbr.bin of=/home/sir/bochs/hd60M.img bs=512 count=1 conv=notrunc
loadloader:
	dd if=build/loader.bin of=/home/sir/bochs/hd60M.img bs=512 count=3 seek=2 conv=notrunc
loadkernel:
	dd if=build/kernel.bin of=/home/sir/bochs/hd60M.img bs=512 count=200 seek=9 conv=notrunc
load:loadmbr loadloader loadkernel