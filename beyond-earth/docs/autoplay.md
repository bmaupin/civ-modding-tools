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
