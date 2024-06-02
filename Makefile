
# sudo apt-get install g++ binutils libc6-dev-i386
# sudo apt-get install VirtualBox grub-legacy xorriso

GCCPARAMS =  -Iinclude -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore -Wno-write-strings -O1

SRC_DIRS := src
BUILD_DIR := build


run: mykernel.iso
	@echo "\033[0;32mRun VirtualBox\033[0m"
	# @cp mykernel.iso /mnt/d/VirtualBox\ VMs/
	# @/mnt/d/VirtualBox/VBoxManage.exe startvm Multiboot
	qemu-system-x86_64 -m 500 -cdrom mykernel.iso


mykernel.bin: src/kernel.c src/loader.nasm
# just compile all the source files together	
	@echo "\033[0;32mCompile mykernel.bin\033[0m"
	[ ! -f $(BUILD_DIR) ] && mkdir $(BUILD_DIR)
	gcc -c -m32 -fPIE $(GCCPARAMS) -o $(BUILD_DIR)/kernel.o src/kernel.c
	nasm src/loader.nasm -Iinclude -f elf32  -o $(BUILD_DIR)/loader.o
	ld -m elf_i386 -nostdlib -o mykernel.bin $(BUILD_DIR)/loader.o $(BUILD_DIR)/kernel.o

mykernel.iso: mykernel.bin src/grub.cfg
	@echo "\033[0;32mMake mykernel.iso\033[0m"
	@mkdir iso
	@mkdir iso/boot
	@mkdir iso/boot/grub
	@cp mykernel.bin iso/boot/mykernel.bin
	@cp mykernel.bin iso/boot/module1.bin
	
	@cp src/grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue --output=mykernel.iso iso


.PHONY: clean 
clean:
	@echo "\033[0;32mClean mykernel.bin mykernel.iso iso\033[0m"
	rm -rf mykernel.bin mykernel.iso iso $(BUILD_DIR)
