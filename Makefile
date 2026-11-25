BUILD := build
ISO_ROOT := $(BUILD)/iso
CXX := g++
AS := nasm
LD := ld
CXXFLAGS := -m32 -ffreestanding -fno-exceptions -fno-rtti -fno-stack-protector -fno-pic -Wall -Wextra -O2
LDFLAGS := -m elf_i386 -T linker.ld -nostdlib

.PHONY: all clean iso
all: iso

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/boot.o: boot/boot.asm | $(BUILD)
	$(AS) -f elf32 $< -o $@

$(BUILD)/kernel.o: kernel/kernel.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD)/kernel.elf: $(BUILD)/boot.o $(BUILD)/kernel.o linker.ld
	$(LD) $(LDFLAGS) -o $@ $(BUILD)/boot.o $(BUILD)/kernel.o

iso: $(BUILD)/kernel.elf
	mkdir -p $(ISO_ROOT)/boot/grub
	cp $(BUILD)/kernel.elf $(ISO_ROOT)/boot/kernel.elf
	printf 'set timeout=0\nset default=0\nmenuentry "BudgieOS Full" {\n  multiboot2 /boot/kernel.elf\n  boot\n}\n' > $(ISO_ROOT)/boot/grub/grub.cfg
	grub-mkrescue -o $(BUILD)/budgieos-full.iso $(ISO_ROOT)

clean:
	rm -rf $(BUILD)
