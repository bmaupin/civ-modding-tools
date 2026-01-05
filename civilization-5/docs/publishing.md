# Publish to Steam workshop

https://partner.steamgames.com/doc/features/workshop/implementation

#### Update an existing mod

1. Check first to see if the Steam Workshop agreement has changes that need to be accepted

   ⚠️ As best as I can tell, if there's a new version of the agreement and a new version of the mod is published before the agreement is agreed to, the mod will not be shown in the Steam workshop except by direct link, e.g. it will not be visible when browsing workshop items

   1. Go here: [https://steamcommunity.com/workshop/workshoplegalagreement/](https://steamcommunity.com/workshop/workshoplegalagreement/)

   1. If there are any new changes, accept them

1. Go to the mod in the Steam workshop to get the latest version

1. Increment the version in the .modinfo file and build the new mod package file

1. Start Steam

1. Publish a new version of the mod, e.g.

   ```
   steamremotestorage-uploader -a 8930 -i MODID -f "modname.civ5mod" -n "v2: Version summary"
   ```

#### Publish a mod for the first time

1. Package the content as needed

   - Mod files should not be lower-cased when the mod is published to Steam; this will be done by the mod installer. Lower-casing the mod files ahead of time will result in an md5 error.
   - Mod files should be compressed with 7zip with the extension `.civ5mod`

1. Create a preview image

   - This is the image shown on the workshop search page and in the workshop item page
     - This is not the same as the screenshots, which can be added later
   - Existing preview images appear to be square, so this is probably best
   - Steam recommends JPG, PNG and GIF

1. Browse the Steam workshop to figure out which tags to use

   1. Go here: https://steamcommunity.com/app/8930/workshop/

   1. On the right look under _Browse By Tag_ to see available tags

1. Upload the mod to Steam

   ⓘ It appears that steamcmd's `workshop_build_item` parameter only works with games that use Steam's newer UGC storage. Using it with Civ 5 will result in an error. steamcmd does have another parameter (`workshop_create_legacy_item`) for older Steam games using the legacy storage (remote storage), however this seems to only work for the initial file upload and not updates.

   1. Download steamremotestorage-uploader

      https://github.com/bmaupin/steamremotestorage-uploader/releases

   1. Extract steamremotestorage-uploader

      ```
      tar xvf steamremotestorage-uploader-v2.0.tar.xz
      ```

   1. Copy it to the path, e.g. `~/bin`

   1. Update the rpath so it can be run from anywhere

      ```
      patchelf --set-rpath "$PWD" steamremotestorage-uploader
      ```

   1. Start Steam

      ⓘ Steam must be running for steamremotestorage-uploader to work

   1. Upload to Steam

      e.g.

      ```
      steamremotestorage-uploader -a 8930 -t "Mini Civ 5" -tags "Gameplay,Maps" -f "mini civ 5 (v 1).civ5mod" -p /path/to/preview.png
      ```

   1. Make a note of the item ID

   1. Go to the mod in your browser using the item ID, e.g.

      https://steamcommunity.com/sharedfiles/filedetails/?id=3489957747

   1. Change the visibility as desired (it will be hidden by default)

   1. (Optional) Add release notes for the first release

      The Steam API doesn't support release notes when creating an item, so add release notes if you'd like (e.g. _v1: Initial release_)

1. Later, upload screenshots

   https://steamcommunity.com/sharedfiles/filedetails/?id=2042081690

## Troubleshooting

👉 See also: [https://github.com/bmaupin/steamremotestorage-uploader?tab=readme-ov-file#troubleshooting](https://github.com/bmaupin/steamremotestorage-uploader?tab=readme-ov-file#troubleshooting)

#### Mod doesn't install after uploading it to Steam

Check ~/.local/share/Aspyr/Sid\ Meier\'s\ Civilization\ 5/Logs/ModInstaller.log
