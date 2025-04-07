# API

#### GameEvents

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

#### objective

```
Sid Meier's Civilization Beyond Earth$ find . -iname "*.lua" -exec egrep -o "objective:.*" "{}" \; | cut -d '(' -f 1 | less | sort -u
objective:DidFail
objective:DidSucceed
objective:Fail
objective:GetEpilogue
objective:GetFocusPlot
objective:GetHash
objective:GetIndex
objective:GetOwner
objective:GetPrompt
objective:GetPromptImagePath
objective:GetPromptOptionA
objective:GetPromptOptionB
objective:GetPromptOptionC
objective:GetPromptTooltipA
objective:GetPromptTooltipB
objective:GetPromptTooltipC
objective:GetQuest
objective:GetSummary
objective:GetType
objective:IsInProgress
objective:SetEpilogue
objective:SetFocusPlot
objective:SetImagePath
objective:SetPrompt
objective:SetPromptOptionA
objective:SetPromptOptionB
objective:SetPromptOptionC
objective:SetSuccessConditionsMet
objective:SetSummary
objective:ShowObjectiveReceivedPopup
objective:ShowUpdateNotification
objective:Succeed
```

#### quest

```
$ find . -iname "*.lua" -exec egrep -o "quest:.*" "{}" \; | cut -d '(' -f 1 | less | sort -u
quest:DidFail
quest:DidSucceed
quest:Fail
quest:GetFailureSummary
quest:GetHash
quest:GetIndex
quest:GetNameOverride
quest:GetObjectives
quest:GetObjectiveWithIndex
quest:GetOwner
quest:GetPrologue
quest:GetReward
quest:GetType
quest:IsInProgress
quest:SetFailureSummary
quest:SetNameOverride
quest:SetProgress
quest:SetPrologue
quest:SetReward
quest:Succeed
quest:WasUpdated
```
