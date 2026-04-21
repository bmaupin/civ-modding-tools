# Autoplay

ⓘ This will automatically play the game up to a certain number of turns, which is very useful when modding as play testing can be very time consuming.

#### Start autoplay

Use `Game.SetAIAutoPlay()`, e.g.

```lua
local function AutoPlay()
    -- First parameter is number of turns to autoplay, second is player to return control to (or -1 for none)
    Game.SetAIAutoPlay(100, 0);
end
Events.SequenceGameInitComplete.Add(AutoPlay);
```

#### Speed up autoplay

Move the screen to the top of the map so it doesn't have to render all the actions

⚠️ Don't use the debug panel to hide graphical elements when using autoplay as this will cause the game to crash and doesn't provide much of a speedup beyond moving the screen to the top of the map

#### Stop autoplay early

If you wish to stop the autoplay before it's finished:

```lua
if Game.GetAIAutoPlay() > 0 then
    Game.SetAIAutoPlay(1, 0);
end
```

⚠️ The `Game.GetAIAutoPlay()` check is recommended because `Game.SetAIAutoPlay(1, 0)` will do one more turn of autoplay (setting the first parameter to 0 doesn't work). Here's an example using `GameEvents.PlayerDoTurn`:

```lua
local function CheckAutoPlay(playerID)
    -- Only run the check once per turn
    if playerID ~= 0 then
        return;
    end

    if someCondition then
        if Game.GetAIAutoPlay() > 0 then
            Game.SetAIAutoPlay(1, 0);
        end
    end
end
GameEvents.PlayerDoTurn.Add(CheckAutoPlay);
```

#### Resume autoplay

You can use code like this to resume autoplay if needed:

```lua
if Game.GetAIAutoPlay() == 0 then
    Game.SetAIAutoPlay(400 - Game.GetGameTurn(), 0);
end
```

#### Known issues

- The game may stop autoplay in certain situations (e.g. a unit was disbanded)???
- Don't use the debug panel to hide UI elements during autoplay (to speed it up); it will cause the game to crash (and doesn't seem to give much of a speedup over just moving the screen to the top of the map)
- There may be other graphical quirks or inconsistencies when playing with autoplay
  - The UI may not show the current tech being researched
