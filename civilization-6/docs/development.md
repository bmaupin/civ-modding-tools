# Developing mods for Sid Meier's Civilization VI

## Development

#### Differences from Civ V/Beyond Earth

- Mods are automatically loaded when the game starts up!
- Mod directory names don't need to contain the version
- Filenames don't need to be lower-cased for Linux mods
- .modinfo file doesn't contain checksums
- A lot more can be done with XML; less need to use Lua (which can be error-prone)
- Mods can conditionally remove items from game database
- Mods work with multiplayer
- Mods don't disable achievements

#### Reload mod changes without exiting the game

1. Make changes to your mod as needed (can be done before or after starting a match)
   1. (Recommended) During development, update the description somehow so you know it's been updated (e.g. add a timestamp)
1. Create or open a new map in World Builder, or start a new match in Civ 6
1. When you exit back to the main menu, the game will load any changes to mods

#### In-game databases

The in-game databases are cached in the user directory (e.g. ~/.local/share/aspyr-media/Sid Meier's Civilization VI/Cache) and can be opened with an SQLite browser to browse database structure, run queries for testing, etc.

#### Important files

> [!IMPORTANT]
>
> - Data defined under Assets/Configuration/ is for the frontend configuration and must be modified by files listed under `<FrontEndActions>` in the .modinfo file
> - Data defined under Assets/Gameplay/ is for data used during gameplay and must be modified by files listed under `<InGameActions>` in the .modinfo file

- Base/Assets/Gameplay/Data/Schema/01_GameplaySchema.sql
  - Primary Gameplay database schema
  - Useful when modifying the database
- Base/Assets/Configuration/Data/Schema/AdditionalTables.sql
  - Database schema for additional queries used in SetupParameters.xml
- Base/Assets/Configuration/Data/Schema/SetupParameters.sql
  - Primary Configuration database schema
- Base/Assets/Configuration/Data/SetupParameters.xml
  - Game setup parameters
  - Serves as a reference when adding new options to the game setup screen
- Base/Assets/Gameplay/Data/GlobalParameters.xml
  - Global configuration parameters

#### Run the game for development without tracking play time

ⓘ This will run the game with the test Steam app "Spacewar" if you wish to avoid tracking mod time as play time

1. Start Steam

1. Open a terminal and run this command:

   ```
   cd ~/.local/share/Steam/steamapps/common/Sid\ Meier\'s\ Civilization\ VI/
   SteamAppId=480 LD_PRELOAD=/home/$USER/.local/share/Steam/ubuntu12_64/gameoverlayrenderer.so ./Civ6
   ```

- You can remove `LD_PRELOAD=/home/$USER/.local/share/Steam/ubuntu12_64/gameoverlayrenderer.so` if you don't want the Steam overlay
- You can remove `SteamAppId=480` and instead create a file named `steam_appid.txt` that contains the string `480`
- If you really want to be particular you can replace the game's _Launch Options_ in steam with `exit` to prevent running up play time (or just hide it from your library)

⚠️ It has to be run from the command line in order to override the app ID; running it from within the Steam client won't pick up a different app ID from `steam_appid.txt` or `SteamAppId`

## Troubleshooting

### Game crashes with no error message

⚠️ On Linux and Mac, it appears that lua.log is not generated. See [Fix for missing Lua.log](./lua-log-fix.md).

1. Check Lua.log and Modding.log

   ⓘ They may not show an error if the game crashed

1. Check net_message_debug.log to see what the game was doing just before the crash
   - It will show information such as `GameTurnComplete`, which player, etc

1. Undo the most recent changes and see if the game no longer crashes

1. If you still can't figure out the issue, do a git bisect to figure out when the crash started

1. Break down changes into smaller pieces until the cause of the crash is identified

### Game UI does not respond to clicks

This could happen, for example, if an item is removed from the database but the game Lua code has a hard-coded reference to it.

### Database changes aren't applied

Check Modding.log and Database.log for errors (see below)

### _Error Starting Game_ popup

If you get an _Error Starting Game_ popup, starting or loading any game after that point will cause Civ 6 to freeze.

If you see this popup:

1. Read the message in the popup and follow the appropriate steps below
1. Exit Civ 6
   - Civ 6 may not exit so you may need to click _Stop_ in Steam
1. Fix the issue and try again

#### _Error - One or more Mods failed to load content._

Check these logs in ~/.local/share/aspyr-media/Sid Meier's Civilization VI/Logs:

- Modding.log, e.g.
  ```
  [1010254.528] ERROR: Failed to apply updates to gameplay database.
  [1010254.528] ERROR: Rolling back database to a good state.
  ```
- Database.log, e.g.
  ```
  [1010254.528] [Gameplay] ERROR: Invalid Reference on FavoredReligions.ReligionType - "RELIGION_ZOROASTRIANISM" does not exist in Religions
  [1010254.528] [Gameplay]: Failed Validation.
  ```

#### _Error - One or more of the startup sripts has an error. See lua.log_

⚠️ On Linux and Mac, it appears that lua.log is not generated. See [Fix for missing Lua.log](./lua-log-fix.md).

In my case, this was caused because I was using a map size that was too small and triggering errors in the game engine.
