# Database

## Deleting items from the database

1. First, make sure no Lua scrips have the item hard-coded, e.g.

   ```
   cd ~/.local/share/Steam/steamapps/common/"Sid Meier's Civilization VI"
   find . -iname "*.lua" -exec grep -oP 'DISTRICT_[A-Z_]+' "{}" \;
   ```

   ⚠️ If you skip this step you will likely cause the game to crash

1. In the mod, delete the item's type, e.g.

   ```sql
   DELETE FROM Types WHERE Type = 'UNIT_BUILDER';
   ```

1. In `01_gameplayschema.sql`, find the primary table where the type is used, e.g.

   ```sql
   CREATE TABLE "Units" (
     -- ...
     FOREIGN KEY (UnitType) REFERENCES Types(Type) ON DELETE CASCADE ON UPDATE CASCADE,
   ```

1. In `01_gameplayschema.sql` go through the database to make sure all references to that table have `ON DELETE CASCADE ON UPDATE CASCADE`, e.g.

   ```sql
   FOREIGN KEY (UnitType) REFERENCES Units(UnitType) ON DELETE CASCADE ON UPDATE CASCADE,
   ```

1. If there are any references that don't do cascade delete, decide if the rows referencing the deleted item need to be deleted or if they can be ignored, e.g.

   ```sql
   FOREIGN KEY (EmbarkUnitType) REFERENCES Units(UnitType) ON DELETE SET DEFAULT ON UPDATE SET DEFAULT,
   ```

## ConfigurationUpdates

This allows overriding a configuration default for a rule set, for example:

```xml
<Row SourceGroup="Game" SourceId="RULESET" SourceValue="RULESET_MC6_CIVREV" TargetGroup="Game" TargetId="CITY_STATE_COUNT" TargetValue="0" Hash="0" Static="1" />
```

- `SourceValue` should match the rule set
- `Static`: if set to 1, then the value will never change; for example, moving the city state slider will have no effect and the city state count will always show 0 in this case
- `TargetId` should match a `ConfigurationId` in modinfo or setupparameters.xml

In this example, checking the _No religion_ option unchecks the religious victory, and vice-versa:

```xml
<Row SourceGroup="Game" SourceId="MC6_NO_RELIGION" SourceValue="0" TargetGroup="Game" TargetId="VICTORY_RELIGIOUS" TargetValue="1" Hash="0" />
<Row SourceGroup="Game" SourceId="MC6_NO_RELIGION" SourceValue="1" TargetGroup="Game" TargetId="VICTORY_RELIGIOUS" TargetValue="0" Hash="0" />
```

- `SourceID` should match a `ConfigurationId` in modinfo or setupparameters.xml

## ParameterCriteria

If _No religion_ is checked, disable religious victory:

```xml
<Row ParameterId="VICTORY_RELIGIOUS" ConfigurationGroup="Game" ConfigurationId="MC6_NO_RELIGION" Operator="NotEquals" ConfigurationValue="1" />
```

ⓘ This is different than `ConfigurationUpdates` (above), which checks or unchecks religious victory; this disables it so that it cannot be checked or unchecked.

- `ConfigurationId` must match a `ConfigurationId` in modinfo or setupparameters.xml
- `ParameterId` must match an existing `ParameterId` from `Parameters`

## ParameterDependencies

Use this to hide a parameter altogether, e.g. to hide `CityStateCount` when the `RULESET_MC6_CIVREV` ruleset is in use:

```xml
<Row ParameterId="CityStateCount" ConfigurationGroup="Game" ConfigurationId="RULESET" Operator="NotEquals" ConfigurationValue="RULESET_MC6_CIVREV" />
```

## RulesetSupportedValues

This seems to be used to limit the supported configuration parameter values. For example, _Ancient Rivals_ limits the starting era to the ancient era:

```xml
<Row Ruleset="RULESET_SCENARIO_ANCIENT_RIVALS" Domain="StandardEras" Value="ERA_ANCIENT"/>
```

## RulesetUnsupportedValues

This is the opposite of `RulesetSupportedValues`. As best as I can tell it only seems to be used for disabling random leader pool players:

```xml
<!-- Disable random leader pool players which are inaccessible -->
<Row Ruleset="RULESET_SCENARIO_ANCIENT_RIVALS" Domain="Players:StandardPlayers" Value="RANDOM_POOL1" />
```
