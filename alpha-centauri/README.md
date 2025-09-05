# Sid Meier's Alpha Centauri

## Common issues

#### Audio crackling

The audio crackles when playing in Steam with Proton. The fix here seems to work: https://www.gog.com/forum/sid_meier_s_alpha_centauri_/fix_for_static_sound

The script has also been added here for purposes of preservation: [scripts/sound_fix.sh](scripts/sound_fix.sh)

#### Force the game to use a specific monitor

Using Proton, the game seems to always show on whichever monitor is primary in Wayland.

The suggested workaround is to run the game in a virtual desktop:

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
