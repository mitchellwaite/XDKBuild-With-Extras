@echo off

echo ************************
echo * XDKBuild-With-Extras *
echo ************************
echo.

if not exist output mkdir output

REM *** need to do this only once, the KHV patches are the same for all console types ***
echo Building KHV patch ELF files
bin\xenon-as.exe src\khv_vfuses_hdd.S -I src\include -o output\khv_vfuses_hdd.elf
bin\xenon-as.exe src\khv_vfuses_flash.S -I src\include -o output\khv_vfuses_flash.elf

echo Building KHV patch BIN files
bin\xenon-objcopy.exe output\khv_vfuses_hdd.elf -O binary output\khv_vfuses_hdd.bin
bin\xenon-objcopy.exe output\khv_vfuses_flash.elf -O binary output\khv_vfuses_flash.bin
del output\khv_vfuses_hdd.elf
del output\khv_vfuses_flash.elf

echo Done!
echo.

pause