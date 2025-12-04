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

#### Stop autoplay

If you wish to stop the autoplay before it's finished:

```lua
Game.SetAIAutoPlay(1, 0);
```

⚠️ Note that using 0 for the first parameter doesn't work
