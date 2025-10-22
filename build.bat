@echo off

echo ************************
echo * XDKBuild-With-Extras *
echo ************************
echo.

if not exist output mkdir output

REM *** need to do this only once, the KHV patches are the same for all console types ***
echo Building kernel patch files...
bin\xenon-as.exe src\khv_vfuses_hdd.S -I src\include -o output\khv_vfuses_hdd.elf
bin\xenon-as.exe src\khv_vfuses_flash.S -I src\include -o output\khv_vfuses_flash.elf
bin\xenon-objcopy.exe output\khv_vfuses_hdd.elf -O binary output\khv_vfuses_hdd.bin
bin\xenon-objcopy.exe output\khv_vfuses_flash.elf -O binary output\khv_vfuses_flash.bin
del output\khv_vfuses_hdd.elf
del output\khv_vfuses_flash.elf
echo Done!

echo.
echo Building SD patch file...
bin\xenon-as.exe src\sd_vfuses.S -I src\include -o output\sd_vfuses.elf
bin\xenon-objcopy.exe output\sd_vfuses.elf -O binary output\sd_vfuses.bin
del output\sd_vfuses.elf
echo Done!

echo.
echo Building SB patch file...
bin\xenon-as.exe src\sb_vfuses.S -I src\include -o output\sb_vfuses.elf
bin\xenon-objcopy.exe output\sb_vfuses.elf -O binary output\sb_vfuses.bin
del output\sb_vfuses.elf
echo Done!

echo.
echo Building XeBuild patches...
copy /b output\sb_vfuses.bin + output\sd_vfuses.bin + output\khv_vfuses_flash.bin output\patches_g2mjasper_flash.bin
copy /b output\sb_vfuses.bin + output\sd_vfuses.bin + output\khv_vfuses_hdd.bin output\patches_g2mjasper.bin

REM *** For XDKBuild, literally all the patch sets are identical for falcon and later on 16mb consoles
REM *** Zephyr and xenon patches *exist* but Jrunner uses the falcon console type for glich2m on them anyway
copy output\patches_g2mjasper.bin output\patches_g2mfalcon.bin
copy output\patches_g2mjasper.bin output\patches_g2mtrinity.bin
copy output\patches_g2mjasper.bin output\patches_g2mcorona.bin

REM *** TODO need to figure out what the difference between jasper/trinity/corona bigffs images are
REM *** Then we can see what's what
echo Done!

echo.
echo.
echo All Done!

pause