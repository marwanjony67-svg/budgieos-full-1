// BudgieOS Full kernel scaffold (freestanding C++).
// This file is a placeholder entry for the next x86_64 boot milestone.
using u16 = unsigned short;

static volatile u16* const VGA_TEXT = reinterpret_cast<volatile u16*>(0xB8000);

static void write_line(const char* text, unsigned row) {
    for (unsigned col = 0; text[col] != '\0' && col < 80; ++col) {
        VGA_TEXT[row * 80 + col] = static_cast<u16>(0x0F00u | static_cast<unsigned char>(text[col]));
    }
}

extern "C" void kernel_main() {
    write_line("BudgieOS Full - BNU kernel scaffold", 0);
    write_line("Boot path is under development.", 1);
    for (;;) {
        asm volatile("hlt");
    }
}
