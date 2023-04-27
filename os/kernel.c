void main()
{
    asm("mov $0x0e, %ah\n"
        "mov $0x48, %al\n"
        "hlt");
}