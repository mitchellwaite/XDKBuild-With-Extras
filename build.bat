@echo off

echo ************************
echo * XDKBuild-With-Extras *
echo ************************
echo.

if not exist output mkdir output

echo Building kernel patch files...

bin\xenon-as.exe src\khv_vfuses_hdd.S -I src\include -o output\khv_vfuses_hdd.elf
bin\xenon-objcopy.exe output\khv_vfuses_hdd.elf -O binary output\khv_vfuses_hdd.bin
del output\khv_vfuses_hdd.elf

bin\xenon-as.exe src\khv_vfuses_jasperbb.S -I src\include -o output\khv_vfuses_jasperbb.elf
bin\xenon-objcopy.exe output\khv_vfuses_jasperbb.elf -O binary output\khv_vfuses_jasperbb.bin
del output\khv_vfuses_jasperbb.elf

echo Done!

echo.
echo Building SD patch files...

bin\xenon-as.exe src\sd_vfuses_sb.S -I src\include -o output\sd_vfuses_sb.elf
bin\xenon-objcopy.exe output\sd_vfuses_sb.elf -O binary output\sd_vfuses_sb.bin
del output\sd_vfuses_sb.elf

bin\xenon-as.exe src\sd_vfuses_jasperbb.S -I src\include -o output\sd_vfuses_jasperbb.elf
bin\xenon-objcopy.exe output\sd_vfuses_jasperbb.elf -O binary output\sd_vfuses_jasperbb.bin
del output\sd_vfuses_jasperbb.elf

echo Done!

echo.

echo Building SB patch file...
bin\xenon-as.exe src\sb_vfuses.S -I src\include -o output\sb_vfuses.elf
bin\xenon-objcopy.exe output\sb_vfuses.elf -O binary output\sb_vfuses.bin
del output\sb_vfuses.elf

echo Done!

echo.
echo Building XeBuild patches...
copy /b output\sb_vfuses.bin + output\sd_vfuses_jasperbb.bin + output\khv_vfuses_jasperbb.bin output\patches_g2mjasper_flash.bin
copy /b output\sb_vfuses.bin + output\sd_vfuses_sb.bin + output\khv_vfuses_hdd.bin output\patches_g2mjasper.bin

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