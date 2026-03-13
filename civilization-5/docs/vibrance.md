# Make the game colours more vibrant

This increases the vibrance (saturation) of the game colours since they can be a bit dull compared to Civ 6 or even Civ 4.

## Linux

#### Setup vkBasalt

1. Install [vkBasalt](https://github.com/DadSchoorse/vkBasalt)
   - On Ubuntu, download the _i386_ package for Debian: https://packages.debian.org/sid/vkbasalt

     ⓘ The `vkbasalt` package in the Ubuntu package repositories is only 64-bit, but since Civ 5 is 32-bit it needs a 32-bit vkbasalt

1. Download shaders
   1. Go here: https://github.com/gripped/vkBasalt-working-reshade-shaders/tree/master/allshaders/reshade-shaders-working/Shaders
   1. Download these shaders:
      - ReShade.fxh
      - ReShadeUI.fxh
      - Vibrance.fx
   1. Copy them to `~/.local/share/vkBasalt/shaders/` (create the directories as needed)
1. Configure vkBasalt
   1. Create a file named `~/.config/vkBasalt/vkBasalt.conf` (create the directory as needed) with these contents:

      ```
      # Define which effects to load
      effects = vibrance

      # Map effect name to full shader path
      vibrance = /home/user/.local/share/vkBasalt/shaders/Vibrance.fx

      # Explicitly tell vkBasalt where ReShade includes live
      reshadeIncludePath = /home/user/.local/share/vkBasalt/shaders

      # Increase saturation
      Vibrance = 0.5
      ```

   1. Replace `user` with your username
   1. Adjust `Vibrance` value as desired (higher is more vibrant)

#### Native

ⓘ vkBasalt is written for Vulkan and doesn't support OpenGL, however OpenGL has a Vulkan driver that outputs Vulkan calls so vkBasalt can be used. See [here](https://github.com/DadSchoorse/vkBasalt/issues/168) for more information.

1. Follow the steps above under _Setup vkBasalt_
1. Go to the game properties in steam and set this in _Launch Options_:
   ```
   VK_INSTANCE_LAYERS="VK_LAYER_VKBASALT_post_processing" VK_LAYER_PATH=/usr/share/vulkan/implicit_layer.d __GLX_VENDOR_LIBRARY_NAME=mesa MESA_LOADER_DRIVER_OVERRIDE=zink GALLIUM_DRIVER=zink %command%
   ```
1. Adjust `Vibrance` value in vkBasalt.conf as desired

#### Proton

1. Follow the steps above under _Setup vkBasalt_
1. Go to the game properties in steam and add `ENABLE_VKBASALT=1` to _Launch Options_, e.g.
   ```
   ENABLE_VKBASALT=1 %command%
   ```
1. Adjust `Vibrance` value in vkBasalt.conf as desired

## Windows

Use [ReShade](https://reshade.me/) with Vibrance.fx shader
