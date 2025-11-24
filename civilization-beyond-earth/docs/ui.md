# UI modding

## Add a new UI element

#### Requirements

- The Lua and XML file must be in the same directory
- The Lua and XML file must have the same name (apart from the extension)
- Neither the Lua nor the XML can have the same name as any of the UI files in the game

## Modify an existing UI element

1. Find the .lua file for the UI element in the game files
1. Copy the game .lua file into your mod

   ⚠️ The mod can only contain one copy of each file, so if the file exists in the base game and has an override in Rising Tide, you'll have to either publish two versions of your mod or accomodate the differences somehow so the file is compatible in both the base game and Rising Tide

   1. If the file exists in the base game and Rising Tide
      1. Compare the files. If the files differ, the file may need to be modified to be compatible with both the base game and Rising Tide
   1. If modding on Linux, get the filename from the Windows depot with the original case
      - Base game: https://steamdb.info/depot/65981/
      - Rising Tide: https://steamdb.info/depot/353830/
   1. Copy the file into your mod
      - If the file exists in the base game (even if it exists in Rising Tide) use the path in the base game for compatibility with both the base game and Rising Tide
