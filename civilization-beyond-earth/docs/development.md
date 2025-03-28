# Developing mods for Sid Meier's Civilization: Beyond Earth

## Development

#### Set up Lua extension for Visual Studio Code

ⓘ This is recommended as any syntax errors in Lua code can cause Beyond Earth to crash

1. Go to _Extensions_, search for Lua, and install the _Lua_ extension by _sumneko_
1. Go to _File_ > _Preferences_ > _Settings_
1. Search for `lua` and configure the Lua extension as desired; here's my current user configuration (folder configuration is in [../.vscode/settings.json](../.vscode/settings.json)):
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

1. Delete the mod directory and copy it over again with the new mod content

   ⓘ It's necessary that the mod directory get deleted, otherwise changes won't get picked up. If the mod doesn't show up in the Mods menu, run the command again until the mod shows up in the Mods menu (it may need to be run several times). As best as I can tell, the command can be run at any time before the mod is loaded, even in the Mods menu itself.

   e.g.

   ```
   rm -rf ~/.local/share/aspyr-media/Sid\ Meier\'s\ Civilization\ Beyond\ Earth/MODS/micro\ beyond\ earth*; ./scripts/install-mod.sh
   ```

   Or to delete just the current version:

   ```
   rm -rf ~/.local/share/aspyr-media/Sid\ Meier\'s\ Civilization\ Beyond\ Earth/MODS/micro\ beyond\ earth\ \(v\ 6\)/; ./scripts/install-mod.sh
   ```

1. Quit any in-progress games (but not Beyond Earth itself)
1. Go to the _Mods_ menu
1. Check the mod to enable it

   ⓘ The mod should be unchecked to show that it has changed. If the mod was previously unchecked and you're not sure if the mod has been updated, you can check the box to enable the mod, run the command again, and you you should see that the mod is unchecked when it's been updated.

If the above steps don't work, i.e. you delete the mod directory and the mod is still showing up as checked in the Mods menu, this has been observed for mods that are bigger or have a lot of files (not sure which).

In that case, go into the _DLC_ menu and make any change, which will force mods to be reloaded. For example, enabling or disabling the Exoplanets Map Pack DLC may work well (if your mod doesn't depend on that DLC).

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
