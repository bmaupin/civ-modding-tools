# Assets

## Leader portraits

#### Specs

- 1600x900
- DDS
  - Format: _RGBA8_
  - Compression: _DXT5_
- Leader should be centred on left of image
  - i.e. centre of leader should be about pixel 400
  - Image can have a background or have a transparent background; transparent background matches the other leaders but it's not necessary
- 3 files total to create
  - DDS image
  - Environment XML that links to DDS
  - Scene XML that links to DDS and environment XML
- Leader's `ArtDefineTag` needs to point to scene XML
  - ⚠️ Leader, not Civilization

## Leader icons

#### Game assets

- Leader entry points to this atlas: `<IconAtlas>LEADER_ATLAS_XP1</IconAtlas>`
- Seems to be in this file: `<Filename>LeaderPortraitsXP1_256.dds</Filename>`

#### Specs

- Size: 256 x 256
- Image contains a centred circular icon surrounded by transparency
- Size of circular icon within image: 212 x 212
  - This includes a 3-pixel black outline inside the icon
- Image contains the top of the leader's torso from the base of the neck up to the top of their head
  - Leader's head fills about 85% of the image
- The leader is outlined in a 3-pixel black line
- Background has a gradient style
  - Top of gradient: `0a0f19`
  - Bottom of gradient differs
    - Greyish: `3d2d2d`
    - Bluish: `3b2459`
    - Greenish: `1d3f37`

#### Create icon from portrait

1. Open portrait in GIMP

1. Measure "face" part of image, e.g. 421 pixels

1. Resize the image

   The face should be 85% of the 212 x 212 image, so it should be about 180 pixels, e.g. if the face is 421 pixels the image needs to be resized 180/421 = 0.427553444 (42.76 percent)

   1. _Image_ > _Scale Image_

1. Cut out a circle with the top of the head at the top

   1. Chose _Ellipse Select_ and hold shift while dragging until you create a 212 x 212 circle
   1. Centre the circle over the face with the head almost touching the top

1. Draw a black border in the circle

   1. Change the foreground image to black
      1. Double-click it and select black or use `000000`
   1. _Edit_ > _Stroke Selection_
   1. Uncheck _Antialiasing_
   1. _Line width_ > 6 px > _Stroke_

1. Delete everything outside the selection

   1. _Layer_ > _Transparency_ > _Add Alpha Channel_
      ⓘ So anything we delete will be transparent
   1. _Select_ > _Invert_
   1. Press _Delete_ to delete everything outside the selection

1. Resize image

   1. _Image_ > _Crop to Content_
   1. _Image_ > _Canvas Size_
   1. 256 x 256
   1. Click _Center_ > _Resize_
   1. _Layer_ > _Layer to Image Size_

1. Export as DDS

   - DDS
   - Format: _RGBA8_
   - Compression: _DXT5_

TODO: Add steps for adding background gradient?

## Game assets

- Extract using Dragon Unpacker
- Models in Resource/Common
  - .dge
    - Granny state files?
  - .fsmxml
    - XML configuration for state machine
  - .fxsxml
    - XML configuration for mesh, animation, texture
  - .gr2
    - Granny files for mesh, animation,
- Textures in Resource/DX11
  - .dds
    - Direct Draw texture files

#### Find which package an asset is in

Grep seems to work:

```
Sid Meier's Civilization Beyond Earth$ grep -i LeaderPortraitsXP1_256.dds -r
grep: steamassets/resource/dx11/expansion1uitextures.fpk: binary file matches
```
