// boot_sector.c — C code in the initial 512 mb boot sector

#define IDT_BASE   0x10000u

typedef unsigned char  u8;   // 1 byte
typedef unsigned short u16;  // 2 bytes

struct __attribute__((packed)) idt_entry {
    u16 off_low;
    u16 sel;
    u8  zero;
    u8  type_attr;
    u16 off_high;
};

void write_idt(void) {
    struct idt_entry dummy = {
        .off_low   = 0xEEFF,
        .sel       = 0xAAAA,
        .zero      = 0xBB,
        .type_attr = 0x8E,
        .off_high  = 0xCCDD
    };

    struct idt_entry *p = (struct idt_entry*)IDT_BASE;
    for (unsigned int i = 0; i < 256; ++i, p++)
        *p = dummy;

    // TODO: Write real IDT to memory
}

