# Steam Workshop

#### Overview

Civ 5 and Beyond Earth use Steam's legacy [RemoteStorage based Workshop API](https://partner.steamgames.com/doc/api/ISteamRemoteStorage) (newer games use [UGC](https://partner.steamgames.com/doc/api/ISteamUGC)).

#### References

- [Better Steam Web API Documentation](https://steamwebapi.azurewebsites.net/)

GET https://api.steampowered.com/IPublishedFileService/QueryFiles/v1/

#### Ways to interact with the Steam workshop API

- Directly, e.g. using curl
  - Requires Steam mobile authenticator
  - https://partner.steamgames.com/doc/webapi/IPublishedFileService
  - https://partner.steamgames.com/doc/webapi/isteamremotestorage
- https://github.com/theace0296/steamworks-node
  - Requires Steamworks SDK, which it will fetch
- https://github.com/nnnn20430/steamremotestorage-uploader/
  - Requires Steamworks SDK, but only to build
  - Would need a modification here to add/update tags: https://github.com/nnnn20430/steamremotestorage-uploader/blob/master/main.go
- ~~[SteamCMD](https://developer.valvesoftware.com/wiki/Command_line_options)~~
  - Can only create legacy items (`workshop_create_legacy_item`) but not update them
- ~~steamworks.js~~
  - Seems to be UGC only
- Greenworks?
  - Requires Steamworks SDK
  - Actively developed
  - Not published to npm
  - publishWorkshopFile
  - updatePublishedWorkshopFile
