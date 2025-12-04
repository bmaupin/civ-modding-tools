# AI Flavours

#### Overview

Reference: https://forums.civfanatics.com/threads/when-will-the-ai-use-atomic-bombs.545859/#post-13765659

In Civ 5 and Beyond Earth, the AI has "flavours" that help the AI decide when there is a choice to make.

Within each leader configuration file in the game (e.g. `civbeleader_hutama.xml`) there are defined flavours, e.g.

```xml
		<Row>
			<LeaderType>LEADER_POLYSTRALIA</LeaderType>
			<FlavorType>FLAVOR_ESPIONAGE</FlavorType>
			<Flavor>5</Flavor>
		</Row>
```

Whenever the game is started (or is it during the game?), the flavour value is taken and then randomly modified plus or minus 2; a flavour of 5 in-game can be 3-7. This maxes out at 10, so a flavour value of 10 in game can be 8-10, and 12 will always be 10.

Each of the different systems in the game also has one or more flavour values, e.g.

```xml
		<Row>
			<TechType>TECH_CHEMISTRY</TechType>
			<FlavorType>FLAVOR_GROWTH</FlavorType>
			<Flavor>8</Flavor>
		</Row>
		<Row>
			<TechType>TECH_CHEMISTRY</TechType>
			<FlavorType>FLAVOR_SCIENCE</FlavorType>
			<Flavor>8</Flavor>
		</Row>
		<Row>
			<TechType>TECH_CHEMISTRY</TechType>
			<FlavorType>FLAVOR_TILE_IMPROVEMENT</FlavorType>
			<Flavor>20</Flavor>
		</Row>
		<Row>
			<TechType>TECH_CHEMISTRY</TechType>
			<FlavorType>FLAVOR_OFFENSE</FlavorType>
			<Flavor>20</Flavor>
		</Row>
		<Row>
			<TechType>TECH_CHEMISTRY</TechType>
			<FlavorType>FLAVOR_PRODUCTION</FlavorType>
			<Flavor>8</Flavor>
		</Row>
```

So the AI seems to take a leader's flavour values to decide what to prioritise and it applies that to the flavour values of the options available when it has a decision to make (e.g. research a tech).

I'm pretty sure there are other factors at play as well because setting a leader flavour to 12 does not seem to guarantee that particular flavour will be picked to the exclusion of other flavours.
