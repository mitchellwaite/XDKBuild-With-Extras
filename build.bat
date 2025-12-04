@echo off

echo ************************
echo * XDKBuild-With-Extras *
echo ************************
echo.

if exist output rmdir /S /Q output

mkdir output
mkdir output\patch_sections

echo Building kernel patch files...

call:buildPatchSection khv_vfuses_sb
call:buildPatchSection khv_vfuses_jasperbb
call:buildPatchSection khv_vfuses_trinitybb
call:buildPatchSection khv_vfuses_coronabb
call:buildPatchSection khv_vfuses_devkit

echo Done!

echo.
echo Building SD patch files...

call:buildPatchSection sd_vfuses_bb
call:buildPatchSection sd_vfuses_sb
call:buildPatchSection sd_vfuses_devkit
call:buildPatchSection sd_shadowboot

echo Done!

echo.

call:buildPatchSection sb_vfuses
call:buildPatchSection sb_shadowboot

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

REM *** This is a bit hacky for a devkit image...
REM *** Corona BB KHV patches are the same as SB minus the HDD redirection (i.e. fuses and patches are at 0xE0000)
REM *** The "devkit" SD patch looks for XeLL at 0xF4000 because XeBuild can't be consistent in where the start
REM *** of the filesystem in a small block image is. SB patches are ignored pretty much.. just here to make sure
REM *** the sections in the patch file are correct and xeBuild doesn't freak out (plz open source xebuild)
copy /b output\patch_sections\sb_vfuses.bin + output\patch_sections\sd_vfuses_devkit.bin + output\patch_sections\khv_vfuses_devkit.bin output\patches_devjasper.bin


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
certutil -hashfile "output\patches_devjasper.bin" SHA256
echo.

echo.
echo All Done!

pause
goto:eof

:buildPatchSection
bin\xenon-as.exe src\%~1.S -I src\include -o output\patch_sections\%~1.elf
bin\xenon-objcopy.exe output\patch_sections\%~1.elf -O binary output\patch_sections\%~1.bin
del output\patch_sections\%~1.elf
goto:eof