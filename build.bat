@echo off

echo ************************
echo * XDKBuild-With-Extras *
echo ************************
echo.

if exist output rmdir /S /Q output

mkdir output
mkdir output\patch_sections

echo Building kernel patch files...

bin\xenon-as.exe src\khv_vfuses_sb.S -I src\include -o output\patch_sections\khv_vfuses_sb.elf
bin\xenon-objcopy.exe output\patch_sections\khv_vfuses_sb.elf -O binary output\patch_sections\khv_vfuses_sb.bin
del output\patch_sections\khv_vfuses_sb.elf

bin\xenon-as.exe src\khv_vfuses_jasperbb.S -I src\include -o output\patch_sections\khv_vfuses_jasperbb.elf
bin\xenon-objcopy.exe output\patch_sections\khv_vfuses_jasperbb.elf -O binary output\patch_sections\khv_vfuses_jasperbb.bin
del output\patch_sections\khv_vfuses_jasperbb.elf

bin\xenon-as.exe src\khv_vfuses_trinitybb.S -I src\include -o output\patch_sections\khv_vfuses_trinitybb.elf
bin\xenon-objcopy.exe output\patch_sections\khv_vfuses_trinitybb.elf -O binary output\patch_sections\khv_vfuses_trinitybb.bin
del output\patch_sections\khv_vfuses_trinitybb.elf

bin\xenon-as.exe src\khv_vfuses_coronabb.S -I src\include -o output\patch_sections\khv_vfuses_coronabb.elf
bin\xenon-objcopy.exe output\patch_sections\khv_vfuses_coronabb.elf -O binary output\patch_sections\khv_vfuses_coronabb.bin
del output\patch_sections\khv_vfuses_coronabb.elf

echo Done!

echo.
echo Building SD patch files...

bin\xenon-as.exe src\sd_vfuses_sb.S -I src\include -o output\patch_sections\sd_vfuses_sb.elf
bin\xenon-objcopy.exe output\patch_sections\sd_vfuses_sb.elf -O binary output\patch_sections\sd_vfuses_sb.bin
del output\patch_sections\sd_vfuses_sb.elf

bin\xenon-as.exe src\sd_vfuses_bb.S -I src\include -o output\patch_sections\sd_vfuses_bb.elf
bin\xenon-objcopy.exe output\patch_sections\sd_vfuses_bb.elf -O binary output\patch_sections\sd_vfuses_bb.bin
del output\patch_sections\sd_vfuses_bb.elf

bin\xenon-as.exe src\sd_vfuses_devkit.S -I src\include -o output\patch_sections\sd_vfuses_devkit.elf
bin\xenon-objcopy.exe output\patch_sections\sd_vfuses_devkit.elf -O binary output\patch_sections\sd_vfuses_devkit.bin
del output\patch_sections\sd_vfuses_devkit.elf
echo Done!

echo.

echo Building SB patch file...
bin\xenon-as.exe src\sb_vfuses.S -I src\include -o output\patch_sections\sb_vfuses.elf
bin\xenon-objcopy.exe output\patch_sections\sb_vfuses.elf -O binary output\patch_sections\sb_vfuses.bin
del output\patch_sections\sb_vfuses.elf

echo Done!

echo.
echo Building XeBuild patches...

REM *** For XDKBuild, literally all the patch sets are identical for falcon and later on 16mb consoles
REM *** Zephyr and xenon patches *exist* but Jrunner uses the falcon console type for glich2m on them anyway
copy /b output\patch_sections\sb_vfuses.bin + output\patch_sections\sd_vfuses_sb.bin + output\patch_sections\khv_vfuses_sb.bin output\patches_g2mjasper.bin
copy output\patches_g2mjasper.bin output\patches_g2mfalcon.bin
copy output\patches_g2mjasper.bin output\patches_g2mtrinity.bin
copy output\patches_g2mjasper.bin output\patches_g2mcorona.bin


REM *** BB consoles all have different patch sets. C'est la vie.
copy /b output\patch_sections\sb_vfuses.bin + output\patch_sections\sd_vfuses_bb.bin + output\patch_sections\khv_vfuses_jasperbb.bin output\patches_g2mjasper_flash.bin
copy /b output\patch_sections\sb_vfuses.bin + output\patch_sections\sd_vfuses_bb.bin + output\patch_sections\khv_vfuses_trinitybb.bin output\patches_g2mtrinity_flash.bin
copy /b output\patch_sections\sb_vfuses.bin + output\patch_sections\sd_vfuses_sb.bin + output\patch_sections\khv_vfuses_coronabb.bin output\patches_g2mcorona_flash.bin

REM *** This is a bit hacky for a devkit image... need to figure out how we go about patching the SD properly
REM *** Corona BB KHV patches are the same as SB minus the HDD redirection (i.e. fuses and patches are at 0xE0000)
REM *** The "devkit" SD patch looks for XeLL at 0x1600000 because XeBuild can't be consistent in where the start
REM *** of the filesystem in a small block image is. SB patches are ignored pretty much.. just here to make sure
REM *** the sections in the patch file are correct and xeBuild doesn't freak out (plz open source xebuild)
copy /b output\patch_sections\sb_vfuses.bin + output\patch_sections\sd_vfuses_devkit.bin + output\patch_sections\khv_vfuses_coronabb.bin output\patches_devkit.bin


echo Done!

echo.
echo SHA256 hashes:
echo.
certutil -hashfile "output\patches_g2mjasper.bin" SHA256
echo.
certutil -hashfile "output\patches_g2mjasper_flash.bin" SHA256
echo.
certutil -hashfile "output\patches_g2mtrinity_flash.bin" SHA256
echo.
certutil -hashfile "output\patches_g2mcorona_flash.bin" SHA256
echo.
certutil -hashfile "output\patches_devkit.bin" SHA256
echo.

echo.
echo All Done!

pause