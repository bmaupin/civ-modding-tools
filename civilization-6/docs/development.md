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
1. Start a new match in Civ 6
1. When you exit the match, the game will load any changes to mods

⚠️ If you get an _Error Starting Game_ popup when starting a match, starting a new match will cause the game to freeze. If this happens:

1. Exit Civ 6
1. Check the logs (see _Troubleshooting_ below) and fix your mod as needed

#### Troubleshooting

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
