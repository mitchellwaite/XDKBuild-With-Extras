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

bin\xenon-as.exe src\khv_vfuses_trinitybb.S -I src\include -o output\khv_vfuses_trinitybb.elf
bin\xenon-objcopy.exe output\khv_vfuses_trinitybb.elf -O binary output\khv_vfuses_trinitybb.bin
del output\khv_vfuses_trinitybb.elf

bin\xenon-as.exe src\khv_vfuses_coronabb.S -I src\include -o output\khv_vfuses_coronabb.elf
bin\xenon-objcopy.exe output\khv_vfuses_coronabb.elf -O binary output\khv_vfuses_coronabb.bin
del output\khv_vfuses_coronabb.elf

echo Done!

echo.
echo Building SD patch files...

bin\xenon-as.exe src\sd_vfuses_sb.S -I src\include -o output\sd_vfuses_sb.elf
bin\xenon-objcopy.exe output\sd_vfuses_sb.elf -O binary output\sd_vfuses_sb.bin
del output\sd_vfuses_sb.elf

bin\xenon-as.exe src\sd_vfuses_bb.S -I src\include -o output\sd_vfuses_bb.elf
bin\xenon-objcopy.exe output\sd_vfuses_bb.elf -O binary output\sd_vfuses_bb.bin
del output\sd_vfuses_bb.elf

echo Done!

echo.

echo Building SB patch file...
bin\xenon-as.exe src\sb_vfuses.S -I src\include -o output\sb_vfuses.elf
bin\xenon-objcopy.exe output\sb_vfuses.elf -O binary output\sb_vfuses.bin
del output\sb_vfuses.elf

echo Done!

echo.
echo Building XeBuild patches...

REM *** For XDKBuild, literally all the patch sets are identical for falcon and later on 16mb consoles
REM *** Zephyr and xenon patches *exist* but Jrunner uses the falcon console type for glich2m on them anyway
copy /b output\sb_vfuses.bin + output\sd_vfuses_sb.bin + output\khv_vfuses_hdd.bin output\patches_g2mjasper.bin
copy output\patches_g2mjasper.bin output\patches_g2mfalcon.bin
copy output\patches_g2mjasper.bin output\patches_g2mtrinity.bin
copy output\patches_g2mjasper.bin output\patches_g2mcorona.bin


REM *** BB consoles all have different patch sets. C'est la vie.
copy /b output\sb_vfuses.bin + output\sd_vfuses_bb.bin + output\khv_vfuses_jasperbb.bin output\patches_g2mjasper_flash.bin
copy /b output\sb_vfuses.bin + output\sd_vfuses_bb.bin + output\khv_vfuses_trinitybb.bin output\patches_g2mtrinity_flash.bin
copy /b output\sb_vfuses.bin + output\sd_vfuses_sb.bin + output\khv_vfuses_coronabb.bin output\patches_g2mcorona_flash.bin

REM *** TODO sha256 checks in case something gets messed up???
REM *** Then we can see what's what

echo Done!

echo.
echo.
echo All Done!

pause