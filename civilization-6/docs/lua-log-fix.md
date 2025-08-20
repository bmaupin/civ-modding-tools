# Fix for missing Lua.log

## Description

Lua.log is referenced sometimes in game error messages, for example:

> Error Starting Game
>
> There was an error starting the game.
>
> We recommend disabling any mods and trying again.
>
> Error - One or more of the startup scripts has an error. See lua.log

However, on Linux and Mac, it seems that starting around 2020-08-27, the Lua.log file is no longer created.

## Fix

### Install

#### Linux

Run [lua-log-patcher.sh](../scripts/lua-log-patcher.sh), e.g.

```
./lua-log-patcher.sh ~/.steam/steam/steamapps/common/Sid\ Meier\'s\ Civilization\ VI/Civ6
```

#### Windows

The Windows build does not have this issue as far as I'm aware

### Uninstall

To uninstall the patch:

1. Open Steam and go to _Library_

1. Find _Sid Meier's Civilization VI_ and right-click on it > _Properties_

1. _Installed Files_ > _Verify integrity of game files_

## Issue submitted with Aspyr 2025-07-25

Response:

> Your Bug Report has been logged!

> After 30 days, this ticket will be archived in our Bug Database and closed. Archived tickets are still visible in our database and help inform future updates/patches for our games.

## How the patch was developed

#### Find the problem

1.  Search the Civ6 binary and game core libraries for `Lua.log`

    - No results searching for `Lua.log` but `ua.log` was found; seems like the first letter can get cut off:

      ```
      $ strings -e B -t x Civ6.bak | grep -i "ua.log"
      4278471 ua.log
      ```

1.  Open the binary in Ghidra and analyse

1.  Go to the location of `Lua.log`

    1. _Navigation_ > _Go To_ > `file(0xfile(0x4278471))

1.  Look for usages of that string in Ghidra

    1. Find where Lua.log actually starts (the address was for `ua.log`)

    1. Right-click the actual address (0x4278470) > _References_ > _Show References To Address_

       - Found usages in these functions:
         - LuaSystem::LuaScriptSystem::Log
         - LuaSystem::LuaScriptSystem::LogAt

1.  Open binary with gdb

    1. Set breakpoints on those functions

       ```
       break LuaSystem::LuaScriptSystem::Log
       ```

       ```
       break LuaSystem::LuaScriptSystem::LogAt
       ```

1.  Debug to see when the log is created

    - Seems to be created by `LuaSystem::LuaScriptSystem::Log` (which calls other functions)

1.  Start debugging to determine why the log isn't being created

    - `Log` calls `Platform::LogEvent` to log to Lua.log
    - There's an if statement before this call that checks the value of RDI+8
    - When Lua.log was working, this value was 1
      ```
      print *(int*)($rdi + 8)
      $5 = 1
      ```
    - In the latest builds, this value is 0
      ```
      print *(int*)($rdi + 8)
      $5 = 0
      ```

1.  Set a watch on that value

    ```
    set $field = (void*)($rdi + 8)
    watch *(int*)$field
    ```

    Then do a reverse-continue:

    ```
    rc
    ```

    It breaks here:

    ```
    Old value = 1
    New value = 0
    0x0000000003a722c0 in LuaSystem::LuaScriptSystem::LuaScriptSystem(void* (*)(void*, void*, unsigned long, unsigned long), int, int) ()
    ```

1.  Examine that address

    Good binary:

    ```
        03a722b6 48 b8 01        MOV        RAX,-0xffffffff
                 00 00 00
                 ff ff ff ff
    ```

    and the bad one:

    ```
         03a72b76 48 b8 00        MOV        RAX,-0x100000000
                  00 00 00
                  ff ff ff ff
    ```

#### Create a patch

1. Get the actual function name

   - I just grabbed this from the Ghidra Listing at the top of the function:

     `_ZN9LuaSystem15LuaScriptSystemC1EPFPvS1_S1_mmEii`

1. Get the address

   - In Ghidra you can just hover over the address and write down _Byte Source Offset_

   - Without Ghidra:

     1. Get the virtual address

        ```
        $ objdump -D Civ6 | grep -A20 -B5 '_ZN9LuaSystem15LuaScriptSystemC1EPFPvS1_S1_mmEii' | grep 'movabs $0xffffffff00000000
        3bfc806: 48 b8 00 00 00 00 ff movabs $0xffffffff00000000,%rax
        ```

     1. Convert to physical address

        Probably just virtual address + 0x400000; get this value from the `PhysAddr` column of LOAD:

        ```
        $ readelf -l Civ6

        Elf file type is EXEC (Executable file)
        Entry point 0x2cae8b4
        There are 10 program headers, starting at offset 64

        Program Headers:
          Type           Offset             VirtAddr           PhysAddr
                         FileSiz            MemSiz              Flags  Align
          PHDR           0x0000000000000040 0x0000000000400040 0x0000000000400040
                         0x0000000000000230 0x0000000000000230  R E    0x8
          INTERP         0x0000000000000270 0x0000000000400270 0x0000000000400270
                         0x000000000000001c 0x000000000000001c  R      0x1
              [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
          LOAD           0x0000000000000000 0x0000000000400000 0x0000000000400000
                         0x0000000004d5d09c 0x0000000004d5d09c  R E    0x200000
        ```

1. Replace `00` with `01`

   - e.g. using a hex editor; before:

     ```
     3bfc806: 48 b8 00 00 00 00 ff
     ```

     after:

     ```
     3bfc806: 48 b8 01 00 00 00 ff
     ```

1. I tested, and that worked!

1. When creating a patch script, instead of using the exact function name, I used the demangled function name and discovered there are actually three variants of the same function that need to be patched:

   ```
   $ objdump --demangle --disassemble "${bin_path}" | grep -A20 -B5 'LuaSystem::LuaScriptSystem::LuaScriptSystem' | grep -B 13 'movabs $0xffffffff00000000' | egrep 'LuaSystem::LuaScriptSystem::LuaScriptSystem|0xffffffff00000000'
   0000000003bfc570 <LuaSystem::LuaScriptSystem::LuaScriptSystem()@@Base>:
    3bfc582:       48 b8 00 00 00 00 ff    movabs $0xffffffff00000000,%rax
   0000000003bfc76c <LuaSystem::LuaScriptSystem::LuaScriptSystem(void* (*)(void*, void*, unsigned long, unsigned long))@@Base>:
    3bfc784:       48 b8 00 00 00 00 ff    movabs $0xffffffff00000000,%rax
   0000000003bfc7e4 <LuaSystem::LuaScriptSystem::LuaScriptSystem(void* (*)(void*, void*, unsigned long, unsigned long), int, int)@@Base>:
    3bfc806:       48 b8 00 00 00 00 ff    movabs $0xffffffff00000000,%rax
   ```

   So I modified the patch script accordingly to patch them all
