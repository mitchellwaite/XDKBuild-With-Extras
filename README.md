# XDKBuild-With-Extras

XDKBuild but with more patches. (Eventually)

RGLoader is nice, but it's quite a bit more complex to set up. It's also nice to be able to boot the system without a hard drive installed on a 16mb system... xshell is "good enough" for a lot of things. I'd like to have a "set it and forget it" NAND image that just has "the" patch set and that's that.

## Building xeBuild patches

Run `build.bat`. It will generate a folder containing patches you can drop in to your J-runner folder. Inside the output folder, the individual patch sections can also be seen.

So far, only Glitch2m and DevGL on 16m/256m/512m/4g is supported (they both use the same patch set).

## Potential future items

- XDKBuild for 64mb XSB machines
- XDKBuild for JTAG
- FreeBoot Syscall 0 backdoor installed by default

## Credits

- [xvistaman2005/XDKbuild (original XDKbuild repository)](https://github.com/xvistaman2005/XDKbuild)
- [Byrom90/Xbox_360_Research (17559 patch set)](https://github.com/Byrom90/Xbox_360_Research/blob/main/xeBuild_Patches/KHV_17559/17559_KHV_Patchset.s)
- [GoobyCorp/Xbox-360-Crypto (patch decompiler, BL patching code)](https://github.com/GoobyCorp/Xbox-360-Crypto)  