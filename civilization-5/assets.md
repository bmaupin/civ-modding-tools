# Assets

#### Extract textures from Civ 5

This is useful to compare your assets with the ones from the game to make sure they're properly formatted

1. Figure out which file the asset is in

   1. For example, Russia is defined here: Assets/Gameplay/XML/Civilizations/CIV5Civilizations.xml

   1. We want to find the alpha icon, so that's defined as `<AlphaIconAtlas>CIV_ALPHA_ATLAS</AlphaIconAtlas>`

   1. Then we can find `<Atlas>CIV_ALPHA_ATLAS</Atlas>` in Assets/Gameplay/XML/GameInfo/CIV5IconTextureAtlases.xml

   1. Looking at the largest size, it points to CivSymbolAtlas128.dds

   1. TODO

1. Download Dragon Unpacker: https://www.elberethzone.net/en/dragon-unpacker.html

   - Reference: https://forums.civfanatics.com/threads/extracting-art-assets.536900/

1. Use Dragon Unpacker (drgunpack5.exe) to extract the `.dds` and corresponding `-index.dds` file for the asset

   - Many icon textures are in Sid Meier's Civilization V/Resource/DX9/UITextures.fpk

1. If a file has a corresponding `-index.dds` file, extract both files without conversion and convert using CivDdsUnpacker from https://forums.civfanatics.com/threads/dds-unpacker-for-interface-textures.389316/
