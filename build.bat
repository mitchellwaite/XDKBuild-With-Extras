@echo off

echo Build KHV patches
bin\xenon-as.exe src\khv_vfuses_hdd.S -I src\include -o output\khv_vfuses_hdd.elf

echo Assemble bin files
bin\xenon-objcopy.exe output\khv_vfuses_hdd.elf -O binary output\khv_vfuses_hdd.bin
del output\khv_vfuses_hdd.elf

echo Done!