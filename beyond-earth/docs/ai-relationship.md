# AI relationship to player

The AI player relationship seems to have a number of different properties. See here for more information: https://civilization.fandom.com/wiki/Diplomacy_(CivBE)

## Relationship

This is the defining property in Rising Tide that determines how the AI relates to the player. The relationship levels are defined in `CivBERelationshipLevels.xml`:

- RELATIONSHIP_LEVEL_WAR
- RELATIONSHIP_LEVEL_HOSTILE
- RELATIONSHIP_LEVEL_NEUTRAL
- RELATIONSHIP_LEVEL_COOPERATIVE
- RELATIONSHIP_LEVEL_ALLIED

The relationship doesn't seem to be set directly in Lua; perhaps it's in one of the game binaries?

## Fear and respect

Fear and respect are the primary ways that the relationship level between the AI and the player are set.

Each of these will generate a score that will match corresponding thresholds set for each leader in order to define which stage of fear and respect is required for each relationship level; these are stored in `Leader_RelationshipFearStages` and `Leader_RelationshipRespectStages`.

#### Fear

Fear is calculated in `RecalculateFear` in `DiplomacyAI.lua`. The calculation is the same for all players and based on a number of factors which represent how the AI feels the player compares to them in power. It seems to be primarily based on military power but other factors such as population and science seem to be taken into account.

#### Respect

Respect is manipulated directly by reactions:

- `CivBEReactions.xml` lists all of the different reactions and the corresponding change to respect
- `DefaultReactionHelpers.lua` triggers these reactions based on different game events such as building a wonder, declaring war or peace, founding a city, etc.
- I believe respect is also influenced by the different traits players may choose during the game which influence their preferences

## Approach and Opinion

The base game used approach and opinion to determine how the AI relates to the player. Some of this logic is in `DiplomacySystem.lua`. See here for more information: https://civilization.fandom.com/wiki/Diplomacy_(CivBE)/Base

👉 In Rising Tide, since fear and respect are used to determine the relationship to the player, `DiplomacyAI.lua` maps them to approach and opinion values that can still be used for other systems, such as what dialogue the AI would choose when communicating with the player (`CivBEDiplomacy_Responses.xml`), etc.

#### Approach

Each AI will have an "approach" towards the player; from `CivBEMajorCivApproachTypes.xml`:

- MAJOR_CIV_APPROACH_WAR
- MAJOR_CIV_APPROACH_HOSTILE
- MAJOR_CIV_APPROACH_DECEPTIVE
- MAJOR_CIV_APPROACH_GUARDED
- MAJOR_CIV_APPROACH_AFRAID
- MAJOR_CIV_APPROACH_FRIENDLY
- MAJOR_CIV_APPROACH_NEUTRAL

#### Opinion

Each AI will have an "opinion" of the player; from `DiplomacyAI.lua`:

- MAJOR_CIV_OPINION_ALLY
- MAJOR_CIV_OPINION_COMPETITOR
- MAJOR_CIV_OPINION_ENEMY
- MAJOR_CIV_OPINION_FAVORABLE
- MAJOR_CIV_OPINION_FRIEND
- MAJOR_CIV_OPINION_NEUTRAL
- MAJOR_CIV_OPINION_UNFORGIVABLE
- NO_MAJOR_CIV_OPINION_TYPE
