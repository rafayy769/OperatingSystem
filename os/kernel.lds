/* PHDRS
{
    null PT_NULL FILEHDR PHDRS;
    code PT_LOAD;
}

SECTIONS
{
    .text 0x600: ALIGN(0x100) { *(.text) } :code
    .data : { *(.data) }
    .bss : { *(.bss) }
    /DISCARD/ : { *(.eh_frame) }
} */

ENTRY(main);

PHDRS
{
    headers PT_LOAD FILEHDR PHDRS;
    code PT_LOAD;
}

SECTIONS
{
    /* .text 0x500: { *(.text) } :code */
    .text 0x600: ALIGN(0x100) { *(.text) } :code
    .data : { *(.data) }
    .bss : { *(.bss) }
    /DISCARD/ : { *(.eh_frame) }
}