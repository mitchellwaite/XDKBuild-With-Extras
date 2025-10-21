# Fuck if I know if this is accurate :)

.include "../macros.S"

MAKEPATCH 0x00007204
0:
	nop
9:

MAKEPATCH 0x00007214
0:
	nop
9:

MAKEPATCH 0x000071B8
0:
	li r3, 0
9:

MAKEPATCH 0x0000723C
0:
	nop
	li r11, 0
9:

MAKEPATCH 0x001C1850
0:
	.long 0x00220023
	lwz r0, 0x1858(r28)
	rlwnm r4, r2, r12, 0x15, 0x1b
	xori r3, r11, 0x655c
	b 0x7d8ac4
	oris r9, r3, 0x736b
	addic r2, r28, 0x5061
	andi. r20, r19, 0x6974
	xori r15, r11, 0x6e31
	rlwnm r17, r1, r6, 0x1c, 0x1a
	addi r1, r25, 0
9:

MAKEPATCH 0x0008102C
0:
	nop
	lis r11, -0x7fe4
	ori r4, r11, 0x1850
9:

MAKEPATCH 0x00081090
0:
	b 0x81050
9:

MAKEPATCH 0x000810B0
0:
	b 0x81050
9:

MAKEPATCH 0x000810DC
0:
	b 0x81050
9:

MAKEPATCH 0x00081158
0:
	b 0x81050
9:

MAKEPATCH 0x000A2F48
0:
	li r3, 1
9:

MAKEPATCH 0x000A0FAC
0:
	b 0xa0fc4
9:

MAKEPATCH 0x000301A8
0:
	nop
9:

MAKEPATCH 0x000301AC
0:
	nop
9:

MAKEPATCH 0x000301C0
0:
	nop
9:

MAKEPATCH 0x000301D0
0:
	nop
9:

MAKEPATCH 0x000301FC
0:
	nop
9:

MAKEPATCH 0x00032198
0:
	li r3, 1
9:

MAKEPATCH 0x00001BE0
0:
	bla 0xb1d4
9:

MAKEPATCH 0x00001BF4
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00008038
0:
	bla 0xb1d4
9:

MAKEPATCH 0x00008058
0:
	addi r11, r11, 1
9:

MAKEPATCH 0x00008064
0:
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00009438
0:
	bla 0xb1d4
9:

MAKEPATCH 0x00009468
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x000095D8
0:
	bla 0xb1d4
9:

MAKEPATCH 0x00009608
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x0000972C
0:
	bla 0xb1d4
9:

MAKEPATCH 0x0000975C
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00009A58
0:
	bla 0xb1d4
9:

MAKEPATCH 0x00009A88
0:
	addi r11, r11, 1
	cmplwi cr6, r11, 0xc
9:

MAKEPATCH 0x00009DE4
0:
	bla 0xb1d4
9:

MAKEPATCH 0x00009E14
0:
	addi r11, r11, 1
	sldi r9, r9, 3
	cmpwi cr6, r11, 0xc
9:

MAKEPATCH 0x0000A0D8
0:
	bla 0xb1d4
9:

MAKEPATCH 0x0000A104
0:
	addi r11, r11, 1
	sldi r9, r9, 3
	cmpwi cr6, r11, 0xc
9:

MAKEPATCH 0x000018C0
0:
	bla 0xb188
9:

MAKEPATCH 0x0000B188
0:
	mflr r8
	bla 0x68c
	oris r4, r3, 0xe
	ori r4, r4, 0
	lis r3, 1
	addi r3, r3, -0x60
	li r5, 0xc
	bla 0x484
	lhz r3, 6(0)
	li r4, 0x21
	andc r3, r3, r4
	sth r3, 6(0)
	cmpldi r21, 0
	li r3, 0x21
	bla 0xb1e0
	li r3, 0xa
	bla 0xb1e0
	mtlr r8
	ba 0x2d8
	lis r3, 1
	addi r3, r3, -0x60
	blr
	lis r4, -0x8000
	ori r4, r4, 0x200
	sldi r4, r4, 0x20
	oris r4, r4, 0xea00
	slwi r3, r3, 0x18
	stw r3, 0x1014(r4)
	lwz r3, 0x1018(r4)
	rlwinm. r3, r3, 0, 6, 6
	beq 0
	blr
9:

# done with patch section

