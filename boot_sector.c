// boot_sector.c — C code in the initial 512 mb boot sector

#define IDT_BASE   0x10000u

struct __attribute__((packed)) idt_entry {
    unsigned short off_low;    // low 16 bits of address
    unsigned short sel;        // segment selector
    unsigned char  zero;       // reserved byte
    unsigned char  type_attr;  // standard interrupt gate attributes
    unsigned short off_high;   // high 16 bits of address
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

