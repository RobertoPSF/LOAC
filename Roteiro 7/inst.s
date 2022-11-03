.section .text
.globl main

addi a2, zero, 1
addi s1, zero, 1
addi a0, a2, 1
addi a1, a0, 1

loop:
	beq a2, a1, loop
    add a0, a0, a2
    add a1, a1, s1
    beq a2, s1, loop