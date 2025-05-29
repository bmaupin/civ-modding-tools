# Developing mods for Sid Meier's Civilization V

## Development

#### Set up Lua extension for Visual Studio Code

ⓘ This can catch syntax errors ahead of time, which will save a lot of development time

1. Go to _Extensions_, search for Lua, and install the _Lua_ extension by _sumneko_
1. Go to _File_ > _Preferences_ > _Settings_
1. Search for `lua` and configure the Lua extension as desired; here's my current user configuration:
   ```jsonc
   // Make it so that the Lua extension only diagnoses the currently open file instead of the entire workspace
   "Lua.workspace.maxPreload": 0,
   ```
1. To ignore other directories in a multi-directory workspace, e.g.
   ```
   mkdir -p ~/.steam/steam/steamapps/common/Sid\ Meier\'s\ Civilization\ V/.vscode/
   echo '{
     "Lua.diagnostics.enable": false
   }' > ~/.steam/steam/steamapps/common/Sid\ Meier\'s\ Civilization\ V/.vscode/settings.json
   ```

If you see _Undefined global_ errors, you can right-click > _Quick Fix_ > _Mark ... as defined global_. You may need to close and re-open the file for it to take effect.

#### Reload mod changes without exiting the game

1. Go into the Mods menu in the game
1. Delete the mod directory (e.g. /home/$USER/.local/share/Aspyr/Sid Meier's Civilization 5/MODS/modname) and re-create it

## Troubleshooting

Check Lua logs in /home/$USER/.local/share/Aspyr/Sid Meier's Civilization 5/Logs/Lua.log
