<img width="1010" height="835" alt="image" src="https://github.com/user-attachments/assets/2b873ca7-2fc5-4e71-864e-600d733ac6eb" />

# Usage

This returns a list of memory map entries, each describing a region’s:

- Base address (64-bit)
- Length (64-bit)
- Type (usable, reserved, ACPI reclaimable, etc.)

| Type | Meaning          |
|------|------------------|
| 1    | Usable RAM       |
| 2    | Reserved         |
| 3    | ACPI reclaimable |
| 4    | ACPI NVS         |
| 5    | Bad memory       |

## Section 1

```
(qemu) x/gx 0x00090000
00090000: 0x0000000000000000
(qemu) x/gx 0x00090000 + 8
00090008: 0x000000000009fc00
(qemu) x/wx 0x00090000 + 8 + 8
00090010: 0x0000000000000001
```

## Section 2

```
(qemu) x/gx 0x00090000 + 20
00090014: 0x000000000009fc00
(qemu) x/gx 0x00090000 + 20 + 8
0009001C: 0x0000000000000400
(qemu) x/wx 0x00090000 + 20 + 8 + 8
00090024: 0x00000002
```

## Section 3

```
(qemu) x/gx 0x00090000 + 40
00090028: 0x00000000000f0000
(qemu) x/gx 0x00090000 + 40 + 8
00090030: 0x0000000000010000
(qemu) x/gx 0x00090000 + 40 + 8 + 8
00090038: 0x0000000000000002
```

## Section 4

```
(qemu) x/gx 0x00090000 + 60
0009003c: 0x0000000000100000
(qemu) x/gx 0x00090000 + 60 + 8
00090044: 0x0000000007ee0000
(qemu) x/gx 0x00090000 + 60 + 8 + 8
0009004c: 0x0000000000000001
```

## Section 5

```
(qemu) x/gx 0x00090000 + 80
00090050: 0x0000000007fe0000
(qemu) x/gx 0x00090000 + 80 + 8
00090058: 0x0000000000020000
(qemu) x/gx 0x00090000 + 80 + 8 + 8
00090060: 0x0000000000000002
```

## Section 6

```
(qemu) x/gx 0x00090000 + 100
00090064: 0x00000000fffc0000
(qemu) x/gx 0x00090000 + 100 + 8
0009006c: 0x0000000000040000
(qemu) x/gx 0x00090000 + 100 + 8 + 8
00090074: 0x0000000000000002

```
