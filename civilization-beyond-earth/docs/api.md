# API

## General

#### Deriving API from game source

1. CD to game source

1. Get API calls, e.g.

   ```
   find . -iname "*.lua" -exec egrep -o "quest:.*" "{}" \; | cut -d '(' -f 1 | sort -u
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
Sid Meier's Civilization Beyond Earth$ find . -iname "*.lua" -exec egrep -o "GameEvents\..*" "{}" \; | cut -d . -f 1,2 | sort -u
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

Other game events; found by searching game core library for calls to `LuaSupport::CallHook`:

```
GameEvents.CityKilled
GameEvents.CityMoved
GameEvents.GameCoreUpdateEnd
GameEvents.GameCoreTestVictory
GameEvents.GatherPerTurnReplayStats
GameEvents.PersonalityTraitAdded
GameEvents.PersonalityTraitRemoved
GameEvents.PlayerAdoptPolicyBranch
GameEvents.PlayerAdoptPolicy
GameEvents.PlayerFoundStation
GameEvents.PlayerPreAIUnitUpdate
GameEvents.SetAlly
GameEvents.StationTradeRouteCircuitCompleted
GameEvents.StationTradeRouteCompleted
GameEvents.TeamMeet
GameEvents.TeamSetHasTech
GameEvents.UnitGetSpecialExploreTarget
GameEvents.UnitKilledInCombat
GameEvents.WonderSiteDestroyed
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

#### player

```
Sid Meier's Civilization Beyond Earth$ find . -iname "*.lua" -exec egrep -o "player:.*" "{}" \; | cut -d '(' -f 1 | egrep -v "player:\s|player:table" | sort -u
player:AcquireCity
player:AddArtifact
player:AddCovertOpsMessage
player:AddMarvel
player:AddMinorMarvelPlot
player:AddNotification
player:AddPerk
player:AddPersonalityTrait
player:AssignUnitUpgrade
player:BeginFrigidAcquisitionTracking
player:BeginFungalActionTracking
player:BeginPrimordialActionTracking
player:CalculateAffinityScoreNeededForNextLevel
player:CalculateTotalYield
player:CanAdoptPolicy
player:CanCreate
player:CanEverResearch
player:CanFound
player:CanResearch
player:CanResearchForFree
player:CanTrain
player:CanUnlockPolicyBranch
player:ChangeAffinityScore
player:ChangeCulture
player:ChangeDiplomaticCapital
player:ChangeEnergy
player:ChangeExpeditionsEverCompleted
player:ChangeFreePromotionCount
player:ChangeMarvelQuestEverCompleted
player:ChangeNumFreeAffinityLevels
player:Cities
player:ClearUnusedMinorMarvelPlots
player:CountNumBuildings
player:Disband
player:DoBeginDiploWithHuman
player:DoesUnitHavePendingUpgrades
player:DoesUnitHavePerk
player:DoesUnitHaveUpgrade
player:DoRevealAlienNests
player:DoRevealContinentOutline
player:FindPathLength
player:GetActiveFlavor
player:GetAffinityLevel
player:GetAffinityScoreTowardsNextLevel
player:GetAgreementsDiploCapitalChange
player:GetAIFactManager
player:GetAllActivePlayerPerkTypes
player:GetAllAvailableTechs
player:GetAnyUnitHasOrderToGoody
player:GetArtifactAcquisitionRate
player:GetArtifactData
player:GetArtifactTypeAtIndex
player:GetArtifactValueAtIndex
player:GetAssignedUpgradeAtLevel
player:GetBaseCombatStrengthWithPerks
player:GetBaseMovesWithPerks
player:GetBaseRangedCombatStrengthWithPerks
player:GetBaseRangeWithPerks
player:GetBeaconActivationCost
player:GetBeaconPlot
player:GetBestUnitUpgrade
player:GetBuildingClassCount
player:GetCapitalCity
player:GetChangePersonalityTraitCost
player:GetCityByID
player:GetCivilizationAdjective
player:GetCivilizationDescription
player:GetCivilizationDescriptionKey
player:GetCivilizationShortDescription
player:GetCivilizationShortDescriptionKey
player:GetCivilizationType
player:GetClosestGoodyPlot
player:GetCommuniqueRecords
player:GetCovertAgents
player:GetCovertOpsRiskModifier
player:GetCurrentEra
player:GetCurrentResearch
player:GetDiplomaticCapital
player:GetDiplomaticCapitalPerTurnFromAgreements
player:GetDiplomaticCapitalPerTurnFromCities
player:GetDominantAffinityType
player:GetEmancipationCommittedStrength
player:GetEndTurnBlockingNotificationIndex
player:GetEndTurnBlockingType
player:GetEnergy
player:GetEverPoppedGoody
player:GetExcessHealth
player:GetExpeditionsEverCompleted
player:GetFear
player:GetFirstReadyUnit
player:GetForeignPolicyPerTurnCapitalCost
player:GetForeignPolicyPurchaseCapitalCost
player:GetFreePerksForUnit
player:GetHandicapType
player:GetID
player:GetLastArtifactReward
player:GetLeaderType
player:GetMajorCivApproach
player:GetMinorCivType
player:GetName
player:GetNameKey
player:GetNationalSecurityProject
player:GetNavalMovementChangeFromPlayerPerks
player:GetNetDiplomaticCapitalPerTurn
player:GetNextPendingConfrontationReaction
player:GetNickName
player:GetNotificationDismissed
player:GetNotificationIndex
player:GetNotificationStr
player:GetNotificationSummaryStr
player:GetNotificationTurn
player:GetNumArtifacts
player:GetNumCities
player:GetNumCommuniqueRecords
player:GetNumCovertAgents
player:GetNumDomesticQuestsMarkedUpdated
player:GetNumEarthlingsSettled
player:GetNumFreeTechs
player:GetNumMilitaryUnits
player:GetNumNotifications
player:GetNumOutposts
player:GetNumPendingConfrontationReactionsWithPlayer
player:GetNumPlots
player:GetNumPoliciesInBranch
player:GetNumPoliciesInDepth
player:GetNumQuestsMarkedUpdated
player:GetNumUnassignedCovertAgents
player:GetNumUnitsOutOfSupply
player:GetNumVictoryQuestsMarkedUpdated
player:GetNumWorldWonders
player:GetOriginalCapitalIDInfo
player:GetOutpostByID
player:GetOverflowResearch
player:GetPerksForUnit
player:GetPerksForUpgrade
player:GetPersonalityTraitInCategory
player:GetPersonalityTraits
player:GetPlayerColor
player:GetPlayerColors
player:GetPlotDanger
player:GetPolicyResearchFromExpeditions
player:GetProgressToNationalSecurityProjectActivates
player:GetQuests
player:GetQuestWithIndex
player:GetQueuePosition
player:GetRecommendedExpeditionPlots
player:GetRecommendedFoundCityPlots
player:GetRecommendedWorkerPlots
player:GetRelationship
player:GetReplayData
player:GetResearchCost
player:GetResearchProgress
player:GetResearchTurnsLeft
player:GetRespect
player:GetRevealPlayersTurn
player:GetScience
player:GetScore
player:GetScoreFromCities
player:GetScoreFromFuturePolicies
player:GetScoreFromFutureTech
player:GetScoreFromLand
player:GetScoreFromPolicies
player:GetScoreFromPopulation
player:GetScoreFromReligion
player:GetScoreFromScenario1
player:GetScoreFromScenario2
player:GetScoreFromScenario3
player:GetScoreFromScenario4
player:GetScoreFromTechs
player:GetScoreFromWonders
player:GetStartingPlot
player:GetTeam
player:GetTotalArtifactYield
player:GetTotalCulturePerTurn
player:GetTotalDiploCapitalIncomeFromBlackMarket
player:GetTotalDiploCapitalSpentInBlackMarket
player:GetTotalDiplomaticCapitalCostsPerTurn
player:GetTotalDiplomaticCapitalCostsPerTurnFromAgreements
player:GetTotalDiplomaticCapitalPerTurn
player:GetTraitModificationCost
player:GetTranscendenceTurnsRemaining
player:GetTurnsUntilNationalSecurityProjectActivates
player:GetUnimprovedAvailableLuxuryResource
player:GetUnitByID
player:GetUpgradesForUnitClassLevel
player:GetUpgradeStatsForUnit
player:GetVirtueBreadthKickerRequirementDiscount
player:GetVirtueDepthKickerRequirementDiscount
player:GiveArtifactReward
player:GrantScience
player:HasAnyPendingUpgrades
player:HasIdleCovertAgents
player:HasPerk
player:HasPersonalityTrait
player:HasPlayerDoneQuestType
player:HasPlayerProgressedTowardVictory
player:HasPlotBonusMessage
player:HasRecievedArtifactReward
player:IgnoreUnitUpgrade
player:IncreaseArtifactAcquisitionRate
player:InitCity
player:InitUnit
player:InitUnitWithNameOffset
player:IsAffectedByHealthLevel
player:IsAlien
player:IsAlive
player:IsAnyGoodyPlotAccessible
player:IsAnyPlotImproved
player:IsBeaconActive
player:IsCapitalConnectedToCity
player:IsEmpireUnhealthy
player:IsEverAlive
player:IsHuman
player:IsMajorCiv
player:IsMinorCiv
player:IsMinorMarvelPlotUnused
player:IsNationalSecurityProjectActive
player:IsNeutralProxy
player:IsObserver
player:IsQuestInProgress
player:IsTradeAvailable
player:IsTurnActive
player:IsUnitUpgradeIgnored
player:IsUnitUpgradeTierReady
player:MayNotAnnex
player:Plots
player:RecruitCovertAgents
player:RemoveArtifactAtIndex
player:RetrieveAndRemovePlotBonusMessageText
player:SetBeaconActive
player:SetContactPieceFound
player:SetEndTurnBlocking
player:SetStartingPlot
player:SetTotalArtifactYield
player:ShowArtifactSelectedInPopup
player:StartNationalSecurityProject
player:Units
player:UseMinorMarvelPlot
```

#### quest

```
$ find . -iname "*.lua" -exec egrep -o "quest:.*" "{}" \; | cut -d '(' -f 1 | sort -u
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
