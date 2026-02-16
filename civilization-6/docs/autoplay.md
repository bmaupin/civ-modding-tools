# Autoplay

ⓘ This will automatically play the game up to a certain number of turns, which is very useful when modding as play testing can be very time consuming.

#### Auto play a certain number of turns

1. (Optional) For better performance, start the game in strategic view when using auto play:

   _Menu_ > _Options_ > _Interface_ > _Start in Strategic View_ > _Enabled_ > _Confirm_

1. (Optional) Turn off the advisor to prevent popups when the auto play finishes

   _Menu_ > _Options_ > _Game_ > _Advisor_ > _Disabled_ > _Confirm_

1. Create a file in your mod (e.g. `Scripts/Autoplay.lua`) with this content:

   ```lua
   function StartAutoplay()
       AutoplayManager.SetTurns(100);
       AutoplayManager.SetReturnAsPlayer(0);
       -- Comment this line out for super fast auto play, but then you won't see what's happening
       AutoplayManager.SetObserveAsPlayer(PlayerTypes.OBSERVER);

       AutoplayManager.SetActive(true);
       print("**************************************** Starting auto play");
   end
   LuaEvents.NewGameInitialized.Add(StartAutoplay);
   ```

1. (Optional) Comment out `AutoplayManager.SetObserveAsPlayer(PlayerTypes.OBSERVER)` if you're okay not seeing the game play
   - It will play **much** faster (100x faster?); if there's a crash you can always re-enable this line and reload the save before the crash

1. Add the file to your .modinfo, e.g.

   ```xml
   <InGameActions>
       <AddGameplayScripts id="MiniCivVIAutoplay">
           <File>Scripts/Autoplay.lua</File>
       </AddGameplayScripts>
   ```

1. Start a new game

   If you're okay with the defualts, you can use _Single Player_ > _Play Now_

1. (Optional) When auto play has finished, you can immediately start a new game with the same settings using Restart

   _Menu_ > _Restart_
