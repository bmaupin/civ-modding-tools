## The problem

Lua.log no longer seems to be created in Linux as per this comment:

> Has anybody else noticed that the lua.log is no longer being generated after the June and August updates?

(https://steamcommunity.com/app/289070/discussions/0/144512942755435118/?ctp=183#c2942495544689782750)

The aforementioned June update was released 2020-06-25, and the August update was 2020-08-27.

## Research

#### To do

- [x] Check Windows binary; Steam depot: https://steamdb.info/depot/289072/
- [x] Check older/oldest Linux binary; Steam depot: https://steamdb.info/depot/533502/
- [ ] Compare differences between older and latest Linux binaries
- [ ] Test `EnableGameCoreEventLog`
- [ ] Test `EnableLogCollection`

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
