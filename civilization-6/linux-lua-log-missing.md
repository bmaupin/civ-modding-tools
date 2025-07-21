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
