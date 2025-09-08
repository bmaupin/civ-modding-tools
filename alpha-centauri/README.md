# Sid Meier's Alpha Centauri

## Common issues

#### Audio crackling

The audio crackles when playing in Steam with Proton. The fix here seems to work: https://www.gog.com/forum/sid_meier_s_alpha_centauri_/fix_for_static_sound

The script has also been added here for purposes of preservation: [scripts/sound_fix.sh](scripts/sound_fix.sh)

#### Force the game to use a specific monitor

Using Proton, the game seems to always show on whichever monitor is primary in Wayland.

💡 [Thinker mod](#thinker-mod) has windowed support out of the box

Otherwise, you can run the game in a virtual desktop:

1. `protontricks 2204130 winecfg`
1. _Graphics_ > check _Emulate a virtual desktop_
1. _Desktop size_ > 1024 x 768
1. When running the game, the resolution may auto adjust. Once the main menu appears, you can resize the game window as needed.

What doesn't work:

- Disabling the other monitor in the display settings works, but if you re-enable it while the game is running, the game display (or mouse control) messes up and the game becomes unplayable
- Setting the monitor you wish to run the game on as the primary display will cause the game to display on that monitor, but if you click away from the game on the other monitor, the game will no longer display when you go back to it.

#### Load Game defaults to home folder

Need to browse to ~/.steam/steam/steamapps/common/Sid Meier's Alpha Centauri/saves

## Tips for faster gameplay

ⓘ As with most 4X games, games of Alpha Centauri can be very long. These are some notes at attempts to make the game quicker.

#### Keyboard shortcuts

One of the best way to make the game go quicker is to use keyboard shortcuts.

- Enter: ending the turn, choosing the default selection for most popups
- Esc: close popups (e.g. research complete, base founded), go back during setup
- Shift-A: automate (formers, etc)
  - When [Thinker mod](#thinker-mod) is installed, this can be used to automate any unit! Colony pods, military units, etc.
- /: explore automatically (scouts, etc)

#### Game options

1. When starting a game, choose _Customize Rules_

1. As desired, enable any of these options for potentially faster gameplay:

   - _One for All_ (Allow cooperative victory, this is enabled by default)
   - _Do or Die_ (Don't restart eliminated players)
   - _Blind Research_ (Select an area of research instead of a specific tech)
   - _Time Warp_ (Accelerated start, gives extra units and bases on the first turn)

## Map sizes

ⓘ One of the most important factors in the length of a 4X game is the size of the map. Map sizes in Alpha Centauri are a bit different; see [docs/map-sizes.md](docs/map-sizes.md) for more information.

💡 With [Thinker mod](#thinker-mod) installed, map sizes can be even smaller because there can be more land and less ocean. See below for more information.

#### Choosing a map size

1. Choose one of the included map sizes; see below for creating custom world sizes with or without modding

1. At _Select Ocean Coverage_, choose _30-50% of surface_ to increase the land surface and the chance of having more factions in the game

#### Use a custom map size without modding

ⓘ This is the easiest way to use a custom map size but you will be limited to a 16x16 map. See below if you wish to create a smaller map.

When starting the game, you can choose a custom map size:

1. At the main menu, choose _Start Game_ > _Make Random Map_ > _Custom Size_

1. Set _Horizontal_ and _Vertical_ to a value equal to or greater than 16

   👉 Any value less than 16 will automatically be set to 16. For example, if you try to create a 10x20 map, the game will create a 16x20 map.

#### Add custom world sizes

ⓘ This is the only way to get map sizes smaller than 16x16

👉 Some of these maps are so small, the game may immediately end when started. Simply try again (choose _Quick Start_ to start a new game with the same settings as the previous game).

1. Back up `alpha.txt` in the game's root directory

1. Open `alpha.txt` and find the section beginning with `#WORLDSIZE`

1. Edit the section as desired

   For example, these are the smallest viable world sizes based on my testing (see below for more information):

   ```
   #WORLDSIZE
   6
   10x16 320 tiles 2-3 factions, 10, 16
   12x14 336 tiles 2-3 factions, 12, 14
   12x16 384 tiles 2-3 factions, 12, 16
   14x14 392 tiles 2-3 factions, 14, 14
   14x16 448 tiles 2-4 factions, 14, 16
   16x14 448 tiles 2-4 factions, 16, 14
   ```

   ⚠️ Make sure the number under `#WORLDSIZE` matches the number of world sizes in the list

## Thinker mod

#### Install

See [https://github.com/induktio/thinker/](https://github.com/induktio/thinker/)

If playing on Linux using Proton, use these launch options to start the game with the Thinker mod:

```
/home/$USER/.local/share/Steam/ubuntu12_32/reaper SteamLaunch AppId=2204130 -- /home/$USER/.local/share/Steam/ubuntu12_32/steam-launch-wrapper -- "/home/$USER/.local/share/Steam/steamapps/common/SteamLinuxRuntime_sniper"/_v2-entry-point --verb=waitforexitandrun -- "/home/$USER/.local/share/Steam/steamapps/common/Proton 9.0 (Beta)"/proton waitforexitandrun "/home/$USER/.local/share/Steam/steamapps/common/Sid Meier's Alpha Centauri/thinker.exe" -PromptForGamePath # %command%
```

#### Configure

Modify `thinker.ini` as desired

E.g. to play in windowed mode:

```
video_mode=2
window_width=1368
window_height=768
```

To lower sea levels so that there's more land to make space for more factions on smaller maps:

```
world_sea_levels=30,40,50
```

ⓘ Each of the values corresponds to the options in the _Select Ocean Coverage_ setting when starting a new game

#### To play SMAC in SMACX

([https://github.com/induktio/thinker/blob/master/Details.md#smac-in-smacx-mod](https://github.com/induktio/thinker/blob/master/Details.md#smac-in-smacx-mod))

SMAC modders decided to switch to modifying SMACX (the expansion pack) so they wouldn't have to maintain two versions of their mods. Because some players still prefer the base game (SMAC), a mod was developed that allows playing the base game in the expansion pack: _SMAC in SMACX_

Thinker includes the SMAC in SMACX mod. To use it, set this line in `thinker.ini`:

```
smac_only=1
```

#### Map sizes

Modify `smac_mod/alphax.txt` or `alphax.txt`:

```
#WORLDSIZE
4
10x16 320 tiles 3-4 factions, 10, 16
12x16 384 tiles 3-4 factions, 12, 16
14x16 448 tiles 3-5 factions, 14, 16
16x16 512 tiles 5-6 factions, 16, 16
```
