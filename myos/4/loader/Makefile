all:loader mbr
mbr:
	nasm -I include/ -o build/mbr.bin mbr.S
loader:
	nasm -I include/ -o build/loader.bin loader.S
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