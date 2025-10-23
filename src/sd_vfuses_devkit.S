# Builds SD patches with VFuse support for small block consoles (and corona???) with XeLL located at 0x1600000

.set vfuses, 1
.set xell_hacky, 1

.include "sd_17489.S"
