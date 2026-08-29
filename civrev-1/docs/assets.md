# Assets

## General

- .fpk files seem to contain most assets
  - .dds, .xml, .mp3, .wav
  - Models: .gr2, .nxb
- Shader files (.fxobj)
- A few mp3s

## Formats

#### .dds

- Direct3D texture

#### .fpk

- Firaxis package format
- CivRev uses fpk version 6
- Can be extracted with [dragon unpacker](https://github.com/bmaupin/civ-modding-tools/blob/main/civilization-5/assets.md)

#### .gr2

- 3D models and skeletons stored in the proprietary Granny3D format
- Also used by Civ 5?

#### .nxb

- What are these?
  - Header is NXUSTREAM
  - Nvidia PhysX?
    - Physics effects and simulations
    - Integrated into Gamebryo

## FPKs

#### common0.fpk

- Sound effect audio (wav)

#### hoa.fpk

- Assets for Hall of Achievements

#### level.fpk

- Some warrior (`swordsman`) assets
- Unit icons (dds)

#### pedia.fpk

- Assets for Civiliopedia
  - Icons, pictures, etc

#### pregame.fpk

- Civ icons
- Sound effects
- Strings (txt)
  - Civs, great people, techs, units, wonders
- UI assets (dds)
- Visual effect configurations (xml)

#### units.fpk

- Assets for units
  - Archer
  - Artillery
  - Barbarians
  - Battleship
  - Bomber
  - Cannon
  - Caravan
  - Catapult
  - Cruiser
  - Fighter
  - Fishing boat
  - Galleon
  - Galley
  - Great people
  - Horseman
  - ICBM
  - Knight
  - Legion
  - Modern infantry (`modern_soldier`)
  - Pikeman (`phalanx`)
  - Rifleman
  - Settler
  - Spy
  - Submarine
  - Tank (`armor`/`moderntank`)
  - Warrior (`swordsman`)
  - Worker
