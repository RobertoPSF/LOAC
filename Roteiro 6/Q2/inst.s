.section .text
.globl main
main:
    addi s0, zero, 4
    addi a4, s0, 4
    addi a2, s0, 0xc
    slli a2, a2, 2
    srai a4, a4, 2