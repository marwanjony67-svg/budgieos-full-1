; Multiboot2 entry stub for a small x86_64 kernel.
; GRUB enters in 32-bit protected mode. This scaffold deliberately halts
; after validating the boot path; long-mode setup is the next implementation step.
BITS 32

section .multiboot
align 8
header_start:
    dd 0xE85250D6              ; Multiboot2 magic
    dd 0                       ; architecture: i386 protected mode
    dd header_end - header_start
    dd -(0xE85250D6 + 0 + (header_end - header_start))
    dw 0                       ; end tag type
    dw 0                       ; end tag flags
    dd 8                       ; end tag size
header_end:

section .text
align 16
global _start
extern kernel_main
_start:
    cli
    ; Keep the boot path explicit until GDT, paging and long-mode setup exist.
.hang:
    hlt
    jmp .hang
