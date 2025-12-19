# Developing mods for Sid Meier's Civilization: Beyond Earth

## Development

#### Run the game for development without tracking play time

ⓘ This will run the game with the test Steam app "Spacewar" if you wish to avoid tracking mod time as play time

```
cd ~/.local/share/Steam/steamapps/common/Sid\ Meier\'s\ Civilization\ Beyond\ Earth
SteamAppId=480 MESA_LOADER_DRIVER_OVERRIDE=zink LD_PRELOAD=/home/$USER/.local/share/Steam/ubuntu12_32/gameoverlayrenderer.so ./CivBE
```

- You can remove `LD_PRELOAD=/home/$USER/.local/share/Steam/ubuntu12_32/gameoverlayrenderer.so` if you don't want the Steam overlay
- You can remove `MESA_LOADER_DRIVER_OVERRIDE=zink` if you don't need it; see https://github.com/bmaupin/civ-be-linux-fixes/
- You can remove `SteamAppId=480` and instead create a file named `steam_appid.txt` that contains the string `480`

#### Set up Lua extension for Visual Studio Code

ⓘ This is recommended as any syntax errors in Lua code can cause Beyond Earth to crash

1. Go to _Extensions_, search for Lua, and install the _Lua_ extension by _sumneko_
1. Go to _File_ > _Preferences_ > _Settings_
1. Search for `lua` and configure the Lua extension as desired; here's my current user configuration:
   ```jsonc
   // Make it so that the Lua extension only diagnoses the currently open file instead of the entire workspace
   "Lua.workspace.maxPreload": 0,
   ```
1. To ignore other directories in a multi-directory workspace, e.g.
   ```
   mkdir -p ~/.steam/steam/steamapps/common/Sid\ Meier\'s\ Civilization\ Beyond\ Earth/.vscode/
   echo '{
     "Lua.diagnostics.enable": false
   }' > ~/.steam/steam/steamapps/common/Sid\ Meier\'s\ Civilization\ Beyond\ Earth/.vscode/settings.json
   ```

ⓘ The Lua Language Server does not support type definitions (I guess this is a feature of HavokScript?). The easiest fix is to remove them from any Lua files you're developing.

If you see _Undefined global_ errors, you can right-click > _Quick Fix_ > _Mark ... as defined global_. You may need to close and re-open the file for it to take effect.

#### Reload mod changes

To reload changes to the mod without exiting Beyond Earth:

1. Make any changes to the mod as needed

1. Quit any in-progress matches (but not Beyond Earth itself)

   ⓘ For mods that don't make changes to any art or sound assets, you may be able to change them during a match

1. While in the main menu or _Mods_ menu, delete the mod directory and copy it over again with the new mod content
1. Go to the _Mods_ menu
1. Check the mod to enable it

   ⓘ The mod should be unchecked to show that it has changed. If the mod was previously unchecked and you're not sure if the mod has been updated, you can check the box to enable the mod, run the command again, and you you should see that the mod is unchecked when it's been updated.

If the mod doesn't seem to be updating:

1. Create an empty file in the MODS directory and then delete the file

   ```
   touch ~/.local/share/aspyr-media/Sid\ Meier\'s\ Civilization\ Beyond\ Earth/MODS/test
   rm ~/.local/share/aspyr-media/Sid\ Meier\'s\ Civilization\ Beyond\ Earth/MODS/test
   ```

1. If that still doesn't work, go into the _DLC_ menu and unload and reload one of the DLC in order to force the mod to reload the latest changes.

⚠️ Make sure if you're loading a save game to test the mod that you have the same DLC loaded that the save was created with, otherwise Beyond Earth will crash as per https://github.com/bmaupin/civ-be-linux-fixes/?tab=readme-ov-file#the-game-crashes-loading-a-saved-game-with-mods-and-different-dlc

## Troubleshooting

#### Game crashes while developing a mod

If this happens, the most common error is a problem with your mod.

1. Check the logs, especially Lua.log if you're writing Lua

1. Add logging to the Lua code

   ```
   print("(Beyond Earth Eclipse) showing popup for transgenics")
   ```

   👉 One sign that the error is in the Lua is if you add logging and you don't see it in Lua.log. Often the code will fail silently.

1. Check the Lua code for errors

   AI in particular can often recommend bad code

👉 If there is a Lua error, Beyond Earth may not crash the first time a game is started or loaded, but a Lua error in that game will often cause the next game that's started or loaded to crash. As mentioned above, this can happen even if there are no errors in Lua.log.

#### Game crashes after Lua error in previous game

This seems like normal behaviour. If a Lua error occurs in a game, the game may continue to work fine. But the next game that's played or loaded may crash.

#### Runtime Error: bad argument #2 to 'lCanAdoptPolicy' (integer expected, got no value)

Errors like these can be caused when calling object functions with `.` (which is supposed to be only used for static functions) instead of `:`, e.g.

```lua
player.CanAdoptPolicy(GameInfo.Policies["POLICY_KNOWLEDGE_1"].ID)
```

instead of

```lua
player:CanAdoptPolicy(GameInfo.Policies["POLICY_KNOWLEDGE_1"].ID)
```

#### Add debugging code to Lua file

1. In vscode, do a search and replace
1. Enable _Use Regular Expression_
1. Search for:
   ```
   function (([a-z]*).*)
   ```
1. Replace with:
   ```
   function $1
   print("(UnitUpgradePopup) $2");
   ```
   (Replace `UnitUpgradePopup`)
1. Click _Replace All_
1. Save file
