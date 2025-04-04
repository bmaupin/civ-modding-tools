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
