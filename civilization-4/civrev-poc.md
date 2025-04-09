# Civilization Revolution mod POC

## Notes

### Civ Rev

#### UI

View

- Offset a little bit, maybe 15° or so to the right
- Cities appear at a 45° offset within that, just like Civ 4

Trees

- 3 trees per tile
- The tree asset is different, similar shape but more cartoony

#### Code

PS3

- ISO can be directly extracted
- Wonders and intros are .bik movies
- Art and music assets available in .fpk files
  - units, leader heads, buildings, music, "misc", "level", etc.
  - ⚠️ .fpk files don't seem to be readable, they might be obfuscated, compressed, encrypted, etc.
- Game binary in eboot.bin file
- No code? Python, XML, etc

Xbox 360

- ISO needs to be extracted with special tool like https://github.com/rikyperdana/extract-xiso
- .fpk files are version 6 and can be extracted with dragon unpacker ([See Civ 5 notes](../civilization-5/assets.md))
- .fpk files seem to contain most assets!
  - .dds, .xml, .mp3, .wav
- Contents that differ from PS3
  - A few MP3s ("happy village" and "space station"), maybe for scenarios?
  - Shader files (.fxobj)
  - Game binary in .xex file
- Models in an unknown format: .gr2, .nxb

### Civ 4

#### UI

Leaders

- Are they 3D and can they be reskinned?
  - See CIV4ArtDefines_Leaderhead.xml
  - They have .nif (3D mesh) and .kfm (keyframe) files, so it seems yes?

Units

- Already 3 per tile
  - Can be modded (`iGroupSize`) in CIV4UnitInfos.xml as per https://www.reddit.com/r/CivIV/comments/umx7c0/any_mods_to_increase_unit_size/
- Different models, more realistic

Trees

- Similar shape as Civ Rev but more realistic
- A bunch per tile; can this be modded?
  - I think this might be in `ART_DEF_FEATURE_FOREST` in CIV4ArtDefines_Feature.xml
    - See .nif files, these are the 3D models, e.g. Art/Terrain/Features/TreeEvergreen/Evergreen01_01.nif`
    - We'd have to create a new .nif file with just the trees we want, then mod the XML to use only that .nif file
    - The simplest model (Evergreen01_01.nif) has 8 trees, and it goes up from there
