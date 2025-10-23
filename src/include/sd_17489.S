# SD17489 patches for rgh2 XDK kernel 
# can be used on all rgh2 hadware revisons 

.include "macros.S"
.globl _start
_start:

#============================================================================
# branch to smc xell eject check
#============================================================================   
MAKEPATCH 0X310 
0:
   bl 0x4c20 
9:

#============================================================================
# branch to patch engine apply khv patches
#============================================================================
MAKEPATCH 0X6b4  
0:
   b       0x4b48
9:

#============================================================================
# 
#============================================================================
MAKEPATCH 0Xd28
0:
   li      %r3, 0
9:

#============================================================================
# 
#============================================================================
MAKEPATCH 0Xce0
0:
   b       0x8
9:

#============================================================================
# 
#============================================================================
MAKEPATCH 0Xd7c 
0:
   nop
9:

.ifdef vfuses
#============================================================================
# read vfuses
#============================================================================
MAKEPATCH 0XA80
0:
   lis     %r3, 0x1800
   ori     %r3, %r3, 0
   lwz     %r4, 0x64(%r3)
   lwz     %r5, 0x70(%r3)
   add     %r3, %r3, %r4
   add     %r4, %r3, %r5
   mr      %r3, %r10
   li      %r5, 0xc
   bl      0x460
   nop 
9:
.endif

#============================================================================
# PCI init, SMC handshake, patching engine, Boot XeLL
#============================================================================   
MAKEPATCH 0X4f30
0:

pci_init:         
   li      %r5, 0x200
   oris    %r5, %r5, 0x8000
   sldi    %r5, %r5, 32
   oris    %r5, %r5, 0xC800
   lbz     %r4, 0x4D(%r5)
   isync
   cmplwi  %r4, 0
   beq     smc_init

   lis     %r3, -0x51FF
   lis     %r4, -0x8000 
   ori     %r4, %r4, 0x200   
   sldi    %r4, %r4, 32
   oris    %r4, %r4, 0xEA00
   stw     %r3, 0x101C(%r4)

# SMC handshake
smc_init:            
   mflr    %r12
   bl      sub_50F0
   mtlr    %r12
   li      %r8, 0x200
   oris    %r8, %r8, 0x8000
   sldi    %r8, %r8, 32
   oris    %r8, %r8, 0xEA00
   lis     %r9, 0x400
   lis     %r10, 0x100
   li      %r11, 0
   stw     %r9, 0x1084(%r8)
   stw     %r10, 0x1080(%r8)
   stw     %r11, 0x1080(%r8)
   stw     %r11, 0x1080(%r8)
   stw     %r11, 0x1080(%r8)
   stw     %r11, 0x1084(%r8)

smc_handshake_loop:            
   lwz     %r12, 0x1094(%r8)
   and.    %r12, %r12, %r9
   beq     smc_handshake_loop
   stw     %r9, 0x1094(%r8)
   lwz     %r12, 0x1090(%r8)
   lwz     %r3, 0x1090(%r8)
   lwz     %r3, 0x1090(%r8)
   lwz     %r3, 0x1090(%r8)
   stw     %r11, 0x1094(%r8)
   srwi    %r3, %r12, 24
   cmpwi   %r3, 1
   bne     smc_handshake_loop

# This is a list of valid powerup causes:
#
# class PowerUpCause(Enum):
#     POWER           = 0x11
#     EJECT           = 0x12
#     UNDOCUMENTED_15 = 0x15
#     UNDOCUMENTED_16 = 0x16
#     REMOPOWER       = 0x20
#     UNDOCUMENTED_21 = 0x21
#     REMOX           = 0x22
#     WINBUTTON       = 0x24
#     UNDOCUMENTED_30 = 0x30
#     UNDOCUMENTED_31 = 0x31
#     KIOSK           = 0x41
#     WIRELESSX       = 0x55
#     WIREDXF1        = 0x56
#     WIREDXF2        = 0x57
#     WIREDXB2        = 0x58
#     WIREDXB1        = 0x59
#     WIREDXB3        = 0x5A

# Get the powerup cause from the smc
   extrwi  %r3, %r12, 8,8
   cmpwi   %r3, 0
   beq     start_kernel
   lbz     %r4, 0x4F(%r5)
   cmplw   %r3, %r4
   beq     load_xell
   lbz     %r4, 0x4E(%r5)
   cmplw   %r3, %r4
   beq     load_xell

# Boot the kernel... no need to go further
start_kernel:            
   lis     %r3, 0x300
   blr

load_xell:            
   li      %r7, 0x200
   oris    %r7, %r7, 0x8000
   sldi    %r7, %r7, 32
   oris    %r7, %r7, 6
   ori     %r7, %r7, 0x1010

# Set post code 0x10
   li      %r3, 0x10
   sldi    %r3, %r3, 56
   std     %r3, 0(%r7)

# Not sure what this does tbh... will figure it out
   bl      sub_4FCC

# Construct the address to XeLL in the memory mapped NAND space
# XeLL offset in NAND is different for each console type
# Corona is indeed the same offset as SB consoles. BB consoles (256/512)
# are a bit screwy with the location of the patch sets and such

# The offsets might not make sense to you. You might think, how tf is XeLL
# found at 0xC80F or 0xC8B8??? Well, fear not, this does actually make sense.
# On the Xbox 360, NAND is mapped in to memory at 0x80000200C8000000. See that
# C8? Well, that's the beginning of the NAND memory map. The 0F/B8 is the offset
# from the beginning of the logical NAND data- XeLL on a 16MB image lives at
# 0xF0000, in a BB image it lives at 0xB8000. The reason we can't just do a load
# immediate into the register is because 64-bit load immediates aren't a thing-
# all we get is the 16 bit li instruction so we get the rigamarole to load a 64-bit
# value into the register to point to the memory mapped location where XeLL lives
# Assembly is fun!

# 16mb/64mb SB/Corona BB: 0xF0000
   .ifdef xell_C80F
   .set xell_offset, 0xC80F
   .endif

# Jasper/Trinity BB: 0xB8000
   .ifdef xell_C8B8
   .set xell_offset, 0xC8B8
   .endif

# Armin's hacky devkit image... when xeBuild does a 64mb devkit image,
# it puts XeLL in the filesystem a whole 0x4000 later than usual. idk
# why, but i'm going to see if we can just plop XeLL somewhere at the
# end of flash so we don't need to add any extra instructions to the SD
# Going to try 0x1600000, looks like there's free space

   .ifdef xell_hacky
   .set xell_offset, 0xC960
   .endif

   li      %r5, 0x200
   oris    %r5, %r5, 0x8000
   sldi    %r5, %r5, 32
   oris    %r5, %r5, xell_offset  # XeLL loaction in flash changes for full flash fs vs. 16mb
   mr      %r5, %r5
   lis     %r6, -0x8000
   sldi    %r6, %r6, 32
   oris    %r6, %r6, 0x1C00
   mr      %r9, %r6
   mtspr   0x139, %r11

# Set post code 0x11
   li      %r3, 0x11
   sldi    %r3, %r3, 56
   std     %r3, 0(%r7)
   
   lis     %r4, 1
   mtctr   %r4 

xell_copy_loop:            
   lwz     %r8, 0(%r5)
   stw     %r8, 0(%r6)
   dcbst   %r0, %r6
   icbi    %r0, %r6
   sync
   isync
   addi    %r6, %r6, 4
   addi    %r5, %r5, 4
   bdnz    xell_copy_loop

# Set POST code 0x12
   li      %r3, 0x12
   sldi    %r3, %r3, 56
   std     %r3, 0(%r7)

# Jump to XeLL
   li      %r4, 0x30 # '0'
   mfmsr   %r3
   andc    %r3, %r3, %r4
   mtsrr1  %r3
   mtsrr0  %r9
   rfid

sub_4FCC:            
   lis     %r3, -0x8000
   ori     %r3, %r3, 0x17c   
   sldi    %r3, %r3, 32
   oris    %r3, %r3, 0x400
   ori     %r3, %r3, 0x50fC
   li      %r30, 0x200
   oris    %r30, %r30, 0x8000
   sldi    %r30, %r30, 32

loc_4FEC:            
   lwzu    %r4, 4(%r3)
   cmplwi  %r4, 0
   beqlr
   lwzu    %r31, 4(%r3)
   stwbrx  %r31, %r30, %r4
   li      %r31, 0xFF
   andc    %r4, %r4, %r31
   ori     %r4, %r4, 4
   lwbrx   %r31, %r30, %r4
   lwzu    %r29, 4(%r3)
   or      %r31, %r31, %r29
   stwbrx  %r31, %r30, %r4
   b       loc_4FEC
# End of function sub_4FCC

   .long 0xD0000010
   .long 0xEA000000
   .long 0x00000156
   .long 0xD0008010
   .long 0xE0000000
   .long 0x00000002
   .long 0xD0010010
   .long 0xEC800000
   .long 0x00000002
   .long 0xD0100010
   .long 0xEA001800
   .long 0x00000002
   .long 0xD0108010
   .long 0xEA001200
   .long 0x00000006
   .long 0xD0108014
   .long 0xEA001220
   .long 0x00000006
   .long 0xD0110010
   .long 0xEA001300
   .long 0x00000006
   .long 0xD0110014
   .long 0xEA001320
   .long 0x00000006
   .long 0xD0120010
   .long 0xEA002000
   .long 0x00000156
   .long 0xD0121010
   .long 0xEA003000
   .long 0x00000106
   .long 0xD0128010
   .long 0xEA004000
   .long 0x00000156
   .long 0xD0129010
   .long 0xEA005000
   .long 0x00000106
   .long 0xD0138010
   .long 0xEA001400
   .long 0x00000006
   .long 0xD0140010
   .long 0xEA00C000
   .long 0x00000006
   .long 0xD0140014
   .long 0xC8000000
   .long 0x00000006
   .long 0xD0148010
   .long 0xEA001600
   .long 0x00000006
   .long 0xD0150010
   .long 0xEA001000
   .long 0x00000002
   .long 0x00000000

sub_50F0:            
   li      %r3, 0x2E 
   lis     %r4, -0x8000 
   ori     %r4, %r4, 0x200   
   sldi    %r4, %r4, 32
   oris    %r4, %r4, 0xEA00
   slwi    %r3, %r3, 24
   stw     %r3, 0x1014(%r4)

loc_510C:            
   lwz     %r3, 0x1018(%r4)
   rlwinm. %r3, %r3, 0,6,6
   beq     loc_510C
   blr
# End of function sub_50F0

# TODO this looks like the patching engine
loc_511C:            
   mfmsr   %r7
   li      %r8, 0x10
   andc    %r8, %r7, %r8
   mtmsrd  %r8
   bl      sub_50F0
   li      %r5, 0x200 
   oris    %r5, %r5, 0x8000
   sldi    %r5, %r5, 32
   oris    %r5, %r5, 0xC800 
   mr      %r5, %r5
   lwz     %r6, 0x70(%r5)
   lwz     %r4, 0x64(%r5)
   cmplwi  %r6, 0
   bne     loc_5158
   lis     %r6, 1

loc_5158:            
   add     %r4, %r4, %r6
   addi    %r4, %r4, 0x5C #location of patches jasper bb 0x5c
   or      %r3, %r5, %r4
   isync

loc_5168:            
   mtmsrd  %r8
   isync
   lwzu    %r4, 4(%r3)
   cmpwi   %r4, -1
   beq     loc_51B0
   addi    %r4, %r4, -4
   lwzu    %r6, 4(%r3)
   mtctr   %r6

loc_5188:            
   mtmsrd  %r8
   isync
   lwzu    %r6, 4(%r3)
   mtmsrd  %r7
   isync
   stwu    %r6, 4(%r4)
   dcbst   %r0, %r4
   icbi    %r0, %r4
   bdnz    loc_5188
   b       loc_5168

loc_51B0:            
   sync
   isync
   mtmsrd  %r7
   rfid

9:
#============================================================================
   .long 0xFFFFFFFF
   .end
#============================================================================
