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

TODO

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
