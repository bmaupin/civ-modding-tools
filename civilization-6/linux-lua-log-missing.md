## The problem

Lua.log no longer seems to be created in Linux as per this comment:

> Has anybody else noticed that the lua.log is no longer being generated after the June and August updates?

(https://steamcommunity.com/app/289070/discussions/0/144512942755435118/?ctp=183#c2942495544689782750)

The aforementioned June update was released 2020-06-25, and the August update was 2020-08-27.

## Research

#### To do

- [x] Check Windows binary; Steam depot: https://steamdb.info/depot/289072/
- [x] Check older/oldest Linux binary; Steam depot: https://steamdb.info/depot/533502/
- [x] Test `EnableGameCoreEventLog`
- [x] Test `EnableLogCollection`
- [x] Create `Lua.log` manually
- [x] Run in gdb to see if LogAt is even called; maybe that's the issue?
- [ ] Compare invocations of Platform::LogEvent
- [ ] LogEvent is called by LogAt; what is calling LogAt? Check invocation site for parameters, etc
- [ ] Check
- [ ] Compare differences between older and latest Linux binaries

#### Key points

- Lua.log seems to be created by the function `LuaSystem::LuaScriptSystem::LogAt`
  - LogAt does not get called in the latest game binary
- Lua.log stopped being created starting from manifest 2305626520846987208 (20200827)
- Lua.log was created up until manifest 6242871612670547167 (20200723)
  - LogAt does get called in this binary!
  - This message gets logged:
    ```
    DebugHotloadCache: GameDebug initialized!
    ```
    - This is just the output of a print message in one of the Lua files (debughotloadcache.lua)

#### gdb

1. Tail to see when Lua.log is created and logged to

   ```
   tail -F Lua.log
   ```

1. Start game with gdb

   ```
   gdb Civ6
   (gdb) break LuaSystem::LuaScriptSystem::LoadFileHelper
   Breakpoint 1 at 0x3a744bc
   (gdb) run
   ```

1. Step through until file is created

   ```
   (gdb) nexti
   ```

Backtrace:

```
#0  0x00000000020e2592 in LuaSystem::LuaScriptSystem::LogAt(int, unsigned int, char const*, ...) ()
#1  0x00000000020e3a79 in LuaSystem::LuaScriptSystem::LoadFileHelper(lua_State*, wchar_t const*, bool) ()
#2  0x00000000020e2489 in LuaSystem::LuaScriptSystem::pLoadFile(lua_State*) ()
#3  0x00000000020a63f8 in hks::vm_call_internal(lua_State*, void*, int, hksInstruction const*) ()
#4  0x00000000020b887b in hks::runProtected(lua_State*, void (*)(lua_State*, void*, int, hksInstruction const*), void*, int)
    ()
#5  0x000000000207c6a6 in hksi_lua_pcall(lua_State*, int, int, int) ()
#6  0x00000000020d5c16 in Lua::Details::CCallWithErrorHandling(lua_State*, int (*)(lua_State*), void*) ()
#7  0x0000000001f1f9ac in ForgeUI::LuaContext::Initialize() ()
#8  0x0000000001f30bdf in ForgeUI::ControlBase::Initialize() ()
#9  0x0000000001f19584 in ForgeUI::ContextBase::Initialize() ()
#10 0x00000000015f96c3 in AppUIDebug::Startup() ()
#11 0x000000000161a8a7 in Civ6App::AppInit(unsigned int, unsigned int) ()
#12 0x00000000016177cf in Civ6App::GUIInit() ()
#13 0x000000000279c989 in AppHost::RunApp(int, char**, AppHost::Application*) ()
#14 0x000000000279c161 in AppHost::RunApp(char*, AppHost::Application*) ()
#15 0x0000000001630908 in WinMain ()
#16 0x0000000001374091 in ?? ()
#17 0x0000000001376179 in ThreadHANDLE::ThreadProc(void*) ()
#18 0x00007ffff729caa4 in start_thread (arg=<optimized out>) at ./nptl/pthread_create.c:447
#19 0x00007ffff7329c3c in clone3 () at ../sysdeps/unix/sysv/linux/x86_64/clone3.S:78
```

#### Notes

- `lua.log` does not seem to be referenced in the latest `Civ6` binary at all
- `lua.log` is not referenced in any of the game files except for the text definition for `LOC_GAME_START_ERROR_SCRIPT_PROCESSING`
- `Lua.log` is in the latest Windows binary

  ```
  $ strings -e b CivilizationVI.exe | grep -i lua.log
  Lua.log
  ```

Found it! `ua.log`; Lots of first letters cut off:

```
$ strings -e B -t x Civ6 | grep -i "\.log"
41e7775 ConsoleInterfaceDebug.log
41e77dd DataErrors.log
41ed9cd Startup.log
41ee4fd Engine.log
41ee529 NoRenderFrame.log
41ee571 /Graphics_Resources.log
41ef6f1 net_message_debug.log
41f080d LoadGameViewState.log
41f08e5 ocalization.log
41f2c5d Database.log
41f404d EOS.log
41fb675 net_connection_debug.log
41fb71d FiraxisLive.log
42016cd Profile.log
4201d79 Achievements.log
42037e1 GameCoreAppConfig.log
4207e5d Serialization.log
420d039 apSearch.log
420dcfd rtDef.log
4217041 Modding.log
421ec6d webhooks.log
42205b1 utomation.log
422ff91 Achievements_Steam.log
42302dd ssetCloudTuner.log
4230a31 lockerLog.log
4230be1 Clutter.log
42313d5 DynGeoLog.log
4232701 timeline.log
423369d ynthesisLog.log
4235ed9 enderer.log
4235f09 VisManager.log
423f1dd VFXSystem.log
4244ba1 net_transport_debug.log
424d835 serInterface.log
4251741 orgeUI_BLPTextureLoader.log
4252d05 orgeUI_StringCache.log
4278471 ua.log
42854dd Remarks.log
436ee55 *.log
437d6c5 ileSystem.log
```

Referenced in LuaSystem::LuaScriptSystem::LogAt:

```
Platform::LogEvent("Lua.log" // ...)
```

Platform::LogEvent is also used for all other logs (LoadGameViewState.log, Startup.log), but they're working; is there some kind of check or flag disabling lua logging?

- LogAt called from 0x20e3a79 in LoadFileHelper (202005 binary)

`print` statement seems to be handled in `LuaSystem::LuaScriptSystem::pInitializeMainState`?

- `LuaSystem::LuaScriptSystem::pGlobal_Print`
- subtract 0x1c0b58 from address in gdb to get ghidra address

Hmm, I'm not sure `LogAt` is what's logging ... I set a breakpoint at the top of `LogAt` and before it reaches the breakpoint, a log line has been created ...

The log file was created somewhere near here! (manifest 6242871612670547167)

```
0x0000000003a745b4 in LuaSystem::LuaScriptSystem::LoadFileHelper(lua_State*, wchar_t const*, bool) ()
(gdb) bt
#0  0x0000000003a745b9 in LuaSystem::LuaScriptSystem::LoadFileHelper(lua_State*, wchar_t const*, bool) ()
#1  0x0000000003a730a1 in LuaSystem::LuaScriptSystem::pLoadFile(lua_State*) ()
#2  0x0000000003a387cc in hks::vm_call_internal(lua_State*, void*, int, hksInstruction const*) ()
#3  0x0000000003a4a805 in hks::runProtected(lua_State*, void (*)(lua_State*, void*, int, hksInstruction const*), void*, int)
    ()
#4  0x0000000003a0ea7a in hksi_lua_pcall(lua_State*, int, int, int) ()
#5  0x0000000003a67db8 in Lua::Details::CCallWithErrorHandling(lua_State*, int (*)(lua_State*), void*) ()
#6  0x00000000038b656a in ForgeUI::LuaContext::Initialize() ()
#7  0x00000000038c5f19 in ForgeUI::ControlBase::Initialize() ()
#8  0x00000000038af6c4 in ForgeUI::ContextBase::Initialize() ()
#9  0x0000000002e3a434 in AppUIDebug::Startup() ()
#10 0x0000000002e62d25 in Civ6App::AppInit(unsigned int, unsigned int) ()
#11 0x0000000002e605e6 in Civ6App::GUIInit() ()
#12 0x000000000412db82 in AppHost::RunApp(int, char**, AppHost::Application*) ()
#13 0x000000000412d494 in AppHost::RunApp(char*, AppHost::Application*) ()
#14 0x0000000002e8513c in WinMain ()
#15 0x0000000002baaf71 in ?? ()
#16 0x0000000002bad059 in ThreadHANDLE::ThreadProc(void*) ()
#17 0x00007ffff729caa4 in start_thread (arg=<optimized out>) at ./nptl/pthread_create.c:447
#18 0x00007ffff7329c3c in clone3 () at ../sysdeps/unix/sysv/linux/x86_64/clone3.S:78
```

```
0x0000000003a745b4 in LuaSystem::LuaScriptSystem::LoadFileHelper(lua_State*, wchar_t const*, bool) ()
...
0x0000000003a66e34 in Lua::LoadBuffer(lua_State*, char const*, unsigned long, char const*) ()
...
0x0000000003a0ea75 in hksi_lua_pcall(lua_State*, int, int, int) ()
...
0x0000000003a4a802 in hks::runProtected(lua_State*, void (*)(lua_State*, void*, int, hksInstruction const*), void*, int) ()
...
0x0000000003a38aff in hks::vm_call_internal(lua_State*, void*, int, hksInstruction const*) ()
...
0x00000000043befb2 in int hks::execute<(HksBytecodeSharingMode)0>(lua_State*, hksInstruction const*, int) ()

```

do stepi from here:
0x0000000003a388a6 in hks::vm_call_internal(lua_State*, void*, int, hksInstruction const\*) ()

break \*0x3a38aff

#### Setup

Last build when Lua.log was working:

```
cd ~/.local/share/Steam/ubuntu12_32/steamapps/content/app_289070/depot_533502_6242871612670547167
cp -rv * ~/.steam/steam/steamapps/common/Sid\ Meier\'s\ Civilization\ VI && mv ~/.steam/steam/steamapps/common/Sid\ Meier\'s\ Civilization\ VI/Civ6Sub ~/.steam/steam/steamapps/common/Sid\ Meier\'s\ Civilization\ VI/Civ6
```

After Lua.log stopped working:

```
cd ~/.local/share/Steam/ubuntu12_32/steamapps/content/app_289070/depot_533502_2305626520846987208
cp -rv * ~/.steam/steam/steamapps/common/Sid\ Meier\'s\ Civilization\ VI && mv ~/.steam/steam/steamapps/common/Sid\ Meier\'s\ Civilization\ VI/Civ6Sub ~/.steam/steam/steamapps/common/Sid\ Meier\'s\ Civilization\ VI/Civ6
```

## Snippets

#### Log

```
(gdb) print (char*)$rsi
$14 = 0x7fffabccc1c4 "DebugHotloadCache: GameDebug initialized!"
```

#### LogEvent

```
(gdb) print (char*)$rsi
$1 = 0x7fffc95d28d0 "[7/23/2025 19:41:10.347] ServerConnection.cpp(483) FiraxisLive::No activity, disconnecting\n"
(gdb) printf "%ls\n", (wchar_t*)$rdi
FiraxisLive.log
```

#### \_\_libc_open64

File is already printed!

```
(gdb) print (char *)file
$2 = 0x7fff78006cd0 "/home/user/.pulse/client.conf"
```

#### Platform::OpenFile

```
(gdb) printf "%ls\n", (wchar_t*)$rdi
../../../Base/Platforms/Windows/Audio/banks.ini
```

## Notes

- LuaSystem::LuaScriptSystem::pGlobal_Print > LuaSystem::LuaScriptSystem::Log > Platform::LogEvent
- LoadFileHelper: loading Lua file?
- pGlobal_Print: doing the print

## Questions

- [x] Does new binary call pGlobal_Print ?
  - Yes
- [x] Where is Lua.log set?
  - ~~LogAt~~ (not called)
  - In Log!

#### To try

1. [ ] Check that my Platform::LogEvent breakpoint works in the old binary
1. [ ] Confirm LogEvent isn't being called for Lua.log
1. [ ] Figure out exactly which functions are and aren't being called between the two
   - pGlobal_Print: check
   - Log: check
   - LogEvent
1. [ ] Then where they diverge, look at the binary to see maybe why

#### Still trying to figure out what code is creating the file

1. Set up helper functions

   ```
   set $my_strlen = (long(*)(const char*))&strlen
   ```

   ```
   set $my_strcmp = (long(*)(const char*, const char*))&strcmp
   ```

1. Set initial breakpoints

   ```
   break LuaSystem::LuaScriptSystem::LoadFileHelper
   ```

1. After that breakpoint is reached, set more

```
break LuaSystem::LuaScriptSystem::pGlobal_Print
break LuaSystem::LuaScriptSystem::LogAt
break LuaSystem::LuaScriptSystem::Log
# break Platform::LogEvent
break __libc_open64 if (long)strstr((char*)file, "Lua.log")
?? break __libc_open64 if (long)(strstr((char*)file, ".log"))
break Platform::LogEvent if wcsstr((wchar_t*)$rdi, L"Lua.log")
break Platform::OpenFile if wcsstr((wchar_t*)$rdi, L".log")
```

No: too frequent breaks:

- Platform::LogEvent
- \_\_libc_open64

print (char \*)file

## Locations

### Good binary

- Log: 03a730a6

### Bad binary

- pGlobal_Print: 03a7469e
- Log: 03a73966

## Comparisons

- pGlobal_Print doesn't seem to differ

## Backtraces

### Good binary

#### Sequence

👉 Keep an eye on the thread

1. LoadFileHelper
1. pGlobal_Print?

#### \_\_libc_open64

```
#0  __libc_open64 (file=0x7fffabcbc4c0 "/home/user/.local/share/aspyr-media/Sid Meier's Civilization VI/Logs/Lua.log", oflag=577) at ../sysdeps/unix/sysv/linux/open64.c:30
#1  0x0000000002c3f2a3 in open ()
#2  0x0000000002c59b30 in CreateFileA ()
#3  0x0000000002c59d78 in CreateFileW ()
#4  0x0000000003ab6353 in Platform::OpenFile(wchar_t const*, Platform::FileData&) ()
#5  0x0000000003ab19a5 in ?? ()
#6  0x0000000003ab1fe0 in Platform::LogEvent(wchar_t const*, char const*, unsigned int) ()
#7  0x0000000003a73178 in LuaSystem::LuaScriptSystem::Log(char const*, ...) ()
#8  0x0000000003a74093 in LuaSystem::LuaScriptSystem::pGlobal_Print(lua_State*) ()
#9  0x00000000043c1868 in int hks::execute<(HksBytecodeSharingMode)0>(lua_State*, hksInstruction const*, int) ()
#10 0x0000000003a38b04 in hks::vm_call_internal(lua_State*, void*, int, hksInstruction const*) ()
#11 0x0000000003a4a805 in hks::runProtected(lua_State*, void (*)(lua_State*, void*, int, hksInstruction const*), void*, int) ()
#12 0x0000000003a0ea7a in hksi_lua_pcall(lua_State*, int, int, int) ()
#13 0x0000000003a66ce5 in Lua::Details::CallWithErrorHandling(lua_State*, unsigned int, unsigned int) ()
--Type <RET> for more, q to quit, c to continue without paging--c
#14 0x0000000003a66e39 in Lua::LoadBuffer(lua_State*, char const*, unsigned long, char const*) ()
#15 0x0000000003a745b9 in LuaSystem::LuaScriptSystem::LoadFileHelper(lua_State*, wchar_t const*, bool) ()
#16 0x0000000003a730a1 in LuaSystem::LuaScriptSystem::pLoadFile(lua_State*) ()
#17 0x0000000003a387cc in hks::vm_call_internal(lua_State*, void*, int, hksInstruction const*) ()
#18 0x0000000003a4a805 in hks::runProtected(lua_State*, void (*)(lua_State*, void*, int, hksInstruction const*), void*, int) ()
#19 0x0000000003a0ea7a in hksi_lua_pcall(lua_State*, int, int, int) ()
#20 0x0000000003a67db8 in Lua::Details::CCallWithErrorHandling(lua_State*, int (*)(lua_State*), void*) ()
```

#### pGlobal_Print

```
(gdb) bt
#0  0x0000000003a73dde in LuaSystem::LuaScriptSystem::pGlobal_Print(lua_State*) ()
#1  0x00000000043c1868 in int hks::execute<(HksBytecodeSharingMode)0>(lua_State*, hksInstruction const*, int) ()
#2  0x0000000003a38b04 in hks::vm_call_internal(lua_State*, void*, int, hksInstruction const*) ()
#3  0x0000000003a4a805 in hks::runProtected(lua_State*, void (*)(lua_State*, void*, int, hksInstruction const*), void*, int) ()
#4  0x0000000003a0ea7a in hksi_lua_pcall(lua_State*, int, int, int) ()
#5  0x0000000003a66ce5 in Lua::Details::CallWithErrorHandling(lua_State*, unsigned int, unsigned int) ()
#6  0x0000000003a66e39 in Lua::LoadBuffer(lua_State*, char const*, unsigned long, char const*) ()
#7  0x0000000003a745b9 in LuaSystem::LuaScriptSystem::LoadFileHelper(lua_State*, wchar_t const*, bool) ()
#8  0x0000000003a730a1 in LuaSystem::LuaScriptSystem::pLoadFile(lua_State*) ()
#9  0x0000000003a387cc in hks::vm_call_internal(lua_State*, void*, int, hksInstruction const*) ()
#10 0x0000000003a4a805 in hks::runProtected(lua_State*, void (*)(lua_State*, void*, int, hksInstruction const*), void*, int) ()
#11 0x0000000003a0ea7a in hksi_lua_pcall(lua_State*, int, int, int) ()
#12 0x0000000003a67db8 in Lua::Details::CCallWithErrorHandling(lua_State*, int (*)(lua_State*), void*) ()
#13 0x00000000038b656a in ForgeUI::LuaContext::Initialize() ()
#14 0x00000000038c5f19 in ForgeUI::ControlBase::Initialize() ()
#15 0x00000000038af6c4 in ForgeUI::ContextBase::Initialize() ()
#16 0x0000000002e3a434 in AppUIDebug::Startup() ()
#17 0x0000000002e62d25 in Civ6App::AppInit(unsigned int, unsigned int) ()
#18 0x0000000002e605e6 in Civ6App::GUIInit() ()
#19 0x000000000412db82 in AppHost::RunApp(int, char**, AppHost::Application*) ()
#20 0x000000000412d494 in AppHost::RunApp(char*, AppHost::Application*) ()
#21 0x0000000002e8513c in WinMain ()
#22 0x0000000002baaf71 in ?? ()
#23 0x0000000002bad059 in ThreadHANDLE::ThreadProc(void*) ()
#24 0x00007ffff729caa4 in start_thread (arg=<optimized out>) at ./nptl/pthread_create.c:447
#25 0x00007ffff7329c3c in clone3 () at ../sysdeps/unix/sysv/linux/x86_64/clone3.S:78
```

### Bad binary

#### Sequence

👉 Keep an eye on the thread

1. LoadFileHelper
1. pGlobal_Print
1. Log

LogEvent not getting called for Lua.log??? Confirm that my breakpoint is working

#### pGlobal_Print

```
#0  0x0000000003a7469e in LuaSystem::LuaScriptSystem::pGlobal_Print(lua_State*) ()
#1  0x00000000043c20b8 in int hks::execute<(HksBytecodeSharingMode)0>(lua_State*, hksInstruction const*, int) ()
#2  0x0000000003a393c4 in hks::vm_call_internal(lua_State*, void*, int, hksInstruction const*) ()
#3  0x0000000003a4b0c5 in hks::runProtected(lua_State*, void (*)(lua_State*, void*, int, hksInstruction const*), void*, int) ()
#4  0x0000000003a0f33a in hksi_lua_pcall(lua_State*, int, int, int) ()
#5  0x0000000003a675a5 in Lua::Details::CallWithErrorHandling(lua_State*, unsigned int, unsigned int) ()
#6  0x0000000003a676f9 in Lua::LoadBuffer(lua_State*, char const*, unsigned long, char const*) ()
#7  0x0000000003a74e67 in LuaSystem::LuaScriptSystem::LoadFileHelper(lua_State*, wchar_t const*, bool) ()
#8  0x0000000003a73961 in LuaSystem::LuaScriptSystem::pLoadFile(lua_State*) ()
#9  0x0000000003a3908c in hks::vm_call_internal(lua_State*, void*, int, hksInstruction const*) ()
#10 0x0000000003a4b0c5 in hks::runProtected(lua_State*, void (*)(lua_State*, void*, int, hksInstruction const*), void*, int) ()
#11 0x0000000003a0f33a in hksi_lua_pcall(lua_State*, int, int, int) ()
#12 0x0000000003a68678 in Lua::Details::CCallWithErrorHandling(lua_State*, int (*)(lua_State*), void*) ()
```

#### Log

```
#0  0x0000000003a73966 in LuaSystem::LuaScriptSystem::Log(char const*, ...) ()
#1  0x0000000003a74953 in LuaSystem::LuaScriptSystem::pGlobal_Print(lua_State*) ()
#2  0x00000000043c20b8 in int hks::execute<(HksBytecodeSharingMode)0>(lua_State*, hksInstruction const*, int) ()
#3  0x0000000003a393c4 in hks::vm_call_internal(lua_State*, void*, int, hksInstruction const*) ()
#4  0x0000000003a4b0c5 in hks::runProtected(lua_State*, void (*)(lua_State*, void*, int, hksInstruction const*), void*, int) ()
#5  0x0000000003a0f33a in hksi_lua_pcall(lua_State*, int, int, int) ()
#6  0x0000000003a675a5 in Lua::Details::CallWithErrorHandling(lua_State*, unsigned int, unsigned int) ()
#7  0x0000000003a676f9 in Lua::LoadBuffer(lua_State*, char const*, unsigned long, char const*) ()
#8  0x0000000003a74e67 in LuaSystem::LuaScriptSystem::LoadFileHelper(lua_State*, wchar_t const*, bool) ()
#9  0x0000000003a73961 in LuaSystem::LuaScriptSystem::pLoadFile(lua_State*) ()
#10 0x0000000003a3908c in hks::vm_call_internal(lua_State*, void*, int, hksInstruction const*) ()
#11 0x0000000003a4b0c5 in hks::runProtected(lua_State*, void (*)(lua_State*, void*, int, hksInstruction const*), void*, int) ()
#12 0x0000000003a0f33a in hksi_lua_pcall(lua_State*, int, int, int) ()
#13 0x0000000003a68678 in Lua::Details::CCallWithErrorHandling(lua_State*, int (*)(lua_State*), void*) ()
```

#### LogEvent

```
#0  0x0000000003ab27e7 in Platform::LogEvent(wchar_t const*, char const*, unsigned int) ()
#1  0x0000000002e66c27 in Civ6App::SetupIndependentSystems(unsigned int, unsigned int) ()
#2  0x0000000002e630b4 in Civ6App::AppInit(unsigned int, unsigned int) ()
#3  0x0000000002e60966 in Civ6App::GUIInit() ()
#4  0x000000000412e3d2 in AppHost::RunApp(int, char**, AppHost::Application*) ()
#5  0x000000000412dce4 in AppHost::RunApp(char*, AppHost::Application*) ()
#6  0x0000000002e8541c in WinMain ()
#7  0x0000000002bab1e1 in ?? ()
#8  0x0000000002bad2c9 in ThreadHANDLE::ThreadProc(void*) ()
#9  0x00007ffff729caa4 in start_thread (arg=<optimized out>) at ./nptl/pthread_create.c:447
#10 0x00007ffff7329c3c in clone3 () at ../sysdeps/unix/sysv/linux/x86_64/clone3.S:78
```

#### Platform::OpenFile
