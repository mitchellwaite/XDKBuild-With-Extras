# XDKBuild-With-Extras

This is the RGLoader dev branch. Patches are based on the following:

https://github.com/GoobyCorp/Xbox-360-Crypto/tree/master/Patches/RGL/17559-dev

The gist of the patch set is that we're using XDKBuild SB/SD patches and adding the RGLoader kernel patches. The XDKBuild kernel patches for virtual fuses and the flag fixer remain. So far i've tested this on an RGH3 falcon and it works pretty perfectly.

## Building xeBuild patches

Run `build.bat`. It will generate a folder containing patches you can drop in to your J-runner folder. Inside the output folder, the individual patch sections can also be seen.

So far, only Glitch2m and DevGL on 16m/256m/512m/4g is supported (they both use the same patch set).

## Potential future items

- XDKBuild for JTAG
- FreeBoot Syscall 0 backdoor installed by default (non-RGLoader)

## Credits

- [xvistaman2005/XDKbuild (original XDKbuild repository)](https://github.com/xvistaman2005/XDKbuild)
- [Byrom90/Xbox_360_Research (17559 patch set)](https://github.com/Byrom90/Xbox_360_Research/blob/main/xeBuild_Patches/KHV_17559/17559_KHV_Patchset.s)
- [GoobyCorp/Xbox-360-Crypto (patch decompiler, BL patching code)](https://github.com/GoobyCorp/Xbox-360-Crypto)
- https://web.archive.org/web/20180513003510/http://www.razielconsole.com/forum/guide-e-tutorial-xbox-360/945-[x360-reversing]-chapter-2-cd-patches.html
- https://github.com/g91/XBLS/blob/master/Research/code/1bl_583.c#L9