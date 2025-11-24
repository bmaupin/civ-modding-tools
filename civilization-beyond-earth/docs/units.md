# Units

## Creating a new unit

- `ReloadUnitSystem` must be set to 1 in the `.modinfo` file
- Unit needs to have its own unique class or the `Civilization_UnitClassOverrides` table must be updated to point an existing class to the new unit

## Unit upgrades

#### UnitUpgradePopup.lua

- View_GridOfUnits
  - Default view, a grid of all units
- View_UnitUpgrade
  - View for a particular unit after clicking on it
- UpdateSingleUnit
  - Used to set all the properties for each unit (perks, upgrades, etc)
- UpdateCurrentUpgrade
  - When a specific upgrade button (in the unit view) is clicked on, updates the upgrade information
