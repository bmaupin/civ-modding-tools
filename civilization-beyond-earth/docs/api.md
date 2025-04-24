# API

## General

#### Deriving API from game source

1. CD to game source

1. Get API calls, e.g.

   ```
   find . -iname "*.lua" -exec egrep -o "quest:.*" "{}" \; | cut -d '(' -f 1 | less | sort -u
   ```

#### Deriving API from game core libraries

1. CD to game directory

1. Get Lua API calls, e.g.

   ```
   strings libCvGameCoreDLL_Expansion1.so | grep ^CvLua | grep "::" | grep -i quest | sort -u | cut -c 6- | sed 's/::l/:/'
   ```

👉 There are a lot of functions like this in the game core libraries, but they seem to be C++ functions that aren't exposed to Lua:

```
CvQuest::GetPlayer
```

The Lua functions look like this:

```
CvLuaQuest::lGetOwner
```

## APIs

#### Controls (UI)

e.g. `Controls.Button:GetSizeX()`

```
:BuildEntry()
:CalculateInternals()
:CalculateInternalSize()
:CalculateSize()
:ChangeParent()
:ClearCallback()
:ClearEntries()
:DestroyAllChildren()
:DoAutoSize()
:GetButton()
:GetOffsetVal()
:GetOffsetX()
:GetOffsetY()
:GetScrollValue()
:GetSizeVal()
:GetSizeX()
:GetSizeY()
:GetText()
:IsChecked()
:IsHidden()
:IsReversing()
:IsStopped()
:LocalizeAndSetText()
:LocalizeAndSetToolTip()
:Play()
:RegisterCallback()
:RegisterCharCallback()
:RegisterCheckHandler()
:RegisterDownEndCallback()
:RegisterSelectionCallback()
:RegisterSliderCallback()
:RegisterUpEndCallback()
:ReprocessAnchoring()
:Reverse()
:SetAlpha()
:SetCheck()
:SetColor()
:SetColorByName()
:SetDisabled()
:SetEndVal()
:SetHide()
:SetMapSize()
:SetOffsetVal()
:SetOffsetY()
:SetScrollValue()
:SetSizeVal()
:SetSizeX()
:SetSizeY()
:SetText()
:SetTexture()
:SetTextureOffset()
:SetToBeginning()
:SetToolTipString()
:SetVoid1()
:SetWrapWidth()
:SortChildren()
:UnloadTexture()
```

#### GameEvents

From game code:

```
Sid Meier's Civilization Beyond Earth$ find . -iname "*.lua" -exec egrep -o "GameEvents\..*" "{}" \; | cut -d . -f 1,2 | less | sort -u
GameEvents.ActivatePlayers
GameEvents.AIFactAdded
GameEvents.AIFactUpdated
GameEvents.AlienNestDestroyed
GameEvents.BuildFinished
GameEvents.BuildingProcessed
GameEvents.CityCaptureComplete
GameEvents.CityCreated
GameEvents.CityIntrigueLevelChanged
GameEvents.CityWillBeKilled
GameEvents.CovertAgentArrivedInCity
GameEvents.CovertAgentCompletedOperation
GameEvents.CovertAgentRecruited
GameEvents.CycleUnitsComplete
GameEvents.EarthlingSettlement
GameEvents.FungalMinorMarvelActivated
GameEvents.GameCoreUpdateBegin
GameEvents.GoodyExplored
GameEvents.HeroLandmarkVisible
GameEvents.HostilitySet
GameEvents.LandmarkAction
GameEvents.OrbitalUnitLaunched
GameEvents.OutpostFounded
GameEvents.OutpostKilled
GameEvents.PlayerCityFounded
GameEvents.PlayerDiscoveredUnitType
GameEvents.PlayerDoTurn
GameEvents.PlayerExploredGoody
GameEvents.PlayerKilled
GameEvents.PlayerOpinionChanged
GameEvents.PlotAffectedByFungalEffect
GameEvents.ProjectProcessed
GameEvents.RequestStationSpawnChoice
GameEvents.SetPopulation
GameEvents.StationDestroyed
GameEvents.StationKilled
GameEvents.StationTradeRouteCreated
GameEvents.StationWithdrawn
GameEvents.TeamsDeclaredWar
GameEvents.TeamTechResearched
GameEvents.TradeRouteCreated
GameEvents.UnitKilled
GameEvents.UnitSetXY
```

From game core library:

```
Sid Meier's Civilization Beyond Earth$ strings libCvGameCoreDLL_Expansion1.so | grep GCEvent:: | sort -u | sed 's/GCEvent::/GameEvents./'
GameEvents.AffinityLevelChanged
GameEvents.AlienNestAttacked
GameEvents.AlienNestCreated
GameEvents.AlienNestDestroyed
GameEvents.BuildFinished
GameEvents.BuildingProcessed
GameEvents.CityAcquired
GameEvents.CityCreated
GameEvents.CityKilled
GameEvents.CityMoved
GameEvents.CityPlotAdded
GameEvents.CovertAgentArrivedInCity
GameEvents.CovertAgentCompletedOperation
GameEvents.CovertAgentRecruited
GameEvents.DeclaredWar
GameEvents.DiplomacyRelationshipChanged
GameEvents.EarthlingSettlement
GameEvents.GoodyExplored
GameEvents.HeroLandmarkVisible
GameEvents.LandmarkAction
GameEvents.MadePeace
GameEvents.OrbitalUnitLaunched
GameEvents.OutpostFounded
GameEvents.OutpostPlotAcquired
GameEvents.PersonalityTraitAdded
GameEvents.PersonalityTraitRemoved
GameEvents.PlayerPerksChanged
GameEvents.PolicyProcessed
GameEvents.ProjectProcessed
GameEvents.StationDestroyed
GameEvents.StationRevealed
GameEvents.StationWithdrawn
GameEvents.TechProcessed
GameEvents.TradeRouteCancelled
GameEvents.TradeRouteCircuitCompleted
GameEvents.TradeRouteCompleted
GameEvents.TradeRouteCreated
GameEvents.TradeRouteDestroyed
GameEvents.UnitAttacked
GameEvents.UnitCreated
GameEvents.UnitKilled
GameEvents.UnitPerksChanged
GameEvents.UnitSetXY
```

#### objective

```
Sid Meier's Civilization Beyond Earth$ find . -iname "*.lua" -exec egrep -o "objective:.*" "{}" \; | cut -d '(' -f 1 | less | sort -u
objective:DidFail()
objective:DidSucceed()
objective:GetEpilogue()
objective:GetFocusPlot()
objective:GetHash()
objective:GetIndex()
objective:GetOwner()
objective:GetPrompt()
objective:GetPromptImagePath()
objective:GetPromptOptionA()
objective:GetPromptOptionB()
objective:GetPromptOptionC()
objective:GetPromptTooltipA()
objective:GetPromptTooltipB()
objective:GetPromptTooltipC()
objective:GetQuest()
objective:GetSummary()
objective:GetType()
objective:IsInProgress()
```

⚠️ Be careful with these; they may cause the game to crash

```
objective:Fail()
objective:SetEpilogue()
objective:SetFocusPlot()
objective:SetImagePath()
objective:SetPrompt()
objective:SetPromptOptionA()
objective:SetPromptOptionB()
objective:SetPromptOptionC()
objective:SetSuccessConditionsMet()
objective:SetSummary()
objective:ShowObjectiveReceivedPopup()
objective:ShowUpdateNotification()
objective:Succeed()
```

#### quest

```
$ find . -iname "*.lua" -exec egrep -o "quest:.*" "{}" \; | cut -d '(' -f 1 | less | sort -u
quest:DidFail()
quest:DidSucceed()
quest:GetFailureSummary()
quest:GetHash()
quest:GetIndex()
quest:GetNameOverride()
quest:GetObjectives()
quest:GetObjectiveWithIndex()
quest:GetOwner()
quest:GetPrologue()
quest:GetReward()
quest:GetType()
quest:IsInProgress()
quest:WasUpdated()
```

⚠️ Be careful with these; they may cause the game to crash

```
quest:Fail()
quest:SetFailureSummary()
quest:SetNameOverride()
quest:SetProgress()
quest:SetPrologue()
quest:SetReward()
quest:Succeed()
```
