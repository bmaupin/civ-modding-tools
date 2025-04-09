# Assets

## .fpk

#### Versions

The FPK version seems to be the first byte

- Pirates: FPK version 2
- Civ 4: FPK version 4
- CivRev: FPK version 6
- Civ 5: FPK version 6

#### Extracting .fpk files

.fpk files in Civ 4 are different from Civ 5. They need to be extracted with PakBuild, available here: https://forums.civfanatics.com/threads/civ4-pakbuild.136023/

```
$ wine cmd /c "PakBuild.exe /?"

PAK File Builder v2.14
Copyright (c) 2003-2005 Firaxis Games[TM], Inc.  All Rights Reserved.


Usage: PakBuild [/options]

Additional Options:
   /L=layout_file         Loads the specified layout file.
   /B=layout_file         Builds PAK files according to settings in the specified layout file.
   /I=input_path          Set the input path (defaults to the current directory).
   /O=output_path         Set the output path (defaults to the current directory).
   /R=root_name           Set the root name of the pak files (defaults to "Pak").
   /S=size_limit          Maximum size for each PAK file (defaults to 0 meaning there is no size limit).
   /X=exclude_extension   File extension(s) to exclude (use semi-colon to delimit multiples; defaults to no exclusions; more than one /
X flag can be used).
         /F                     Use full paths for file names in a PAK; avoids duplicate file name collisions.
   /C[=compression_level] Compress all PAK files (with optional compression level from 0-9; 0 = no compression, 1 = best speed, 6 = def
ault, 9 = best compression).
   /Q                     Enable quick packing. Only files that are new or newer are packed. They are packed in update*.FPK.
   /U                     Unpack all PAK files in the input folder to the output folder (no PAK files will be built).
   /H                     Display this help message.
   /?                     Display this help message.

   If no options are specified, the program displays a dialog for creating a layout.
```

## .nif

#### Working with .nif files

These are 3D models that can be modified with [Nifskope](https://github.com/niftools/nifskope) or Blender (with a plugin)
