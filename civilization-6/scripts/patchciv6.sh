#!/usr/bin/env bash

# Exit right away if there are any errors (e.g. yq or another tool isn't installed)
set -e

# NOTE: Much of this has been copied from patchciv5.sh

game_directory="/home/${USER}/.local/share/Steam/steamapps/common/Sid Meier's Civilization VI"

# Allow game directory to be overridden as a command-line parameter
if [ -n "${1}" ]; then
    game_directory="$1"
fi

# Detect whether we're using native or Proton
if [[ -f "${game_directory}/Civ6" ]]; then
    VERSION=linux
    echo "Detected native Linux version of Civ 6"
fi
if [[ -f "${game_directory}/Civ5XP.exe" ]]; then
    VERSION=windows
    echo "Detected Proton version of Civ 6"
		echo "Error: Windows/Proton version of Civ 6 not supported" >2
		exit 1
fi
if [[ -z "${VERSION}" ]]; then
    echo "Error: Civ 6 installation directory not found. Please provide the path to Civ 6, e.g."
    echo "    $0 \"/home/${USER}/.local/share/Steam/steamapps/common/Sid Meier's Civilization VI\""
    exit 1
fi

# https://www.pcgamingwiki.com/wiki/Sid_Meier%27s_Civilization_VI
echo "Skip intro logo videos"
movie_directory="${game_directory}/steamassets/base/platforms/windows/movies"
mv "${movie_directory}/bink2_aspyr_logo_black_white_1080p_30fps.bk2" "${movie_directory}/bink2_aspyr_logo_black_white_1080p_30fps.bk2.bak" 2>/dev/null || true
cp blank.bk2 "${movie_directory}/logo_2kfiraxis.bk2"



echo "Allow multiplayer scenarios in singleplayer"
base_scenario_directory="${game_directory}/steamassets/base/assets/scenarios"
sed -i 's/<SupportsSinglePlayer>0<\/SupportsSinglePlayer>/<SupportsSinglePlayer>1<\/SupportsSinglePlayer>/' "${base_scenario_directory}/ancientrivalsscenario/ancientrivalsscenario_config.xml"
sed -i 's/<SupportsSinglePlayer>0<\/SupportsSinglePlayer>/<SupportsSinglePlayer>1<\/SupportsSinglePlayer>/' "${base_scenario_directory}/ancientrivalsscenario/ancientrivalsscenario.modinfo"
sed -i 's/<SupportsSinglePlayer>0<\/SupportsSinglePlayer>/<SupportsSinglePlayer>1<\/SupportsSinglePlayer>/' "${base_scenario_directory}/coldwarscenario/coldwarscenario_config.xml"
sed -i 's/<SupportsSinglePlayer>0<\/SupportsSinglePlayer>/<SupportsSinglePlayer>1<\/SupportsSinglePlayer>/' "${base_scenario_directory}/coldwarscenario/coldwarscenario.modinfo"
sed -i 's/<SupportsSinglePlayer>0<\/SupportsSinglePlayer>/<SupportsSinglePlayer>1<\/SupportsSinglePlayer>/' "${base_scenario_directory}/napoleonscenario/napoleonscenario_config.xml"
sed -i 's/<SupportsSinglePlayer>0<\/SupportsSinglePlayer>/<SupportsSinglePlayer>1<\/SupportsSinglePlayer>/' "${base_scenario_directory}/napoleonscenario/napoleonscenario.modinfo"
sed -i 's/<SupportsSinglePlayer>0<\/SupportsSinglePlayer>/<SupportsSinglePlayer>1<\/SupportsSinglePlayer>/' "${base_scenario_directory}/religiouscombatscenario/religiouscombatscenario_config.xml"
sed -i 's/<SupportsSinglePlayer>0<\/SupportsSinglePlayer>/<SupportsSinglePlayer>1<\/SupportsSinglePlayer>/' "${base_scenario_directory}/religiouscombatscenario/religiouscombatscenario.modinfo"

dlc_scenario_directory="${game_directory}/steamassets/dlc"
sed -i 's/<SupportsSinglePlayer>0<\/SupportsSinglePlayer>/<SupportsSinglePlayer>1<\/SupportsSinglePlayer>/' "${dlc_scenario_directory}/civroyalescenario/civroyalescenario.modinfo"
sed -i 's/<SupportsSinglePlayer>0<\/SupportsSinglePlayer>/<SupportsSinglePlayer>1<\/SupportsSinglePlayer>/' "${dlc_scenario_directory}/civroyalescenario/data/civroyalescenario_config.xml"
sed -i 's/<SupportsSinglePlayer>0<\/SupportsSinglePlayer>/<SupportsSinglePlayer>1<\/SupportsSinglePlayer>/' "${dlc_scenario_directory}/piratesscenario/data/piratesscenario_config.xml"
sed -i 's/<SupportsSinglePlayer>0<\/SupportsSinglePlayer>/<SupportsSinglePlayer>1<\/SupportsSinglePlayer>/' "${dlc_scenario_directory}/piratesscenario/piratesscenario.modinfo"
sed -i 's/<SupportsSinglePlayer>0<\/SupportsSinglePlayer>/<SupportsSinglePlayer>1<\/SupportsSinglePlayer>/' "${dlc_scenario_directory}/warmachinescenario/data/warmachinescenario_config.xml"
sed -i 's/<SupportsSinglePlayer>0<\/SupportsSinglePlayer>/<SupportsSinglePlayer>1<\/SupportsSinglePlayer>/' "${dlc_scenario_directory}/warmachinescenario/warmachinescenario.modinfo"




exit

# TODO
# Increased zoom in
# Change this file: /home/${USER}/.local/share/Steam/steamapps/common/Sid Meier's Civilization VI/steamassets/base/artdefs/camera.artdef

'
						<Element>
							<m_Fields>
								<m_Values>
									<Element class="AssetObjects..FloatValue">
										<m_fValue>0.000000</m_fValue>
										<m_ParamName text="Time"/>
									</Element>
									<Element class="AssetObjects..FloatValue">
                    <!-- change this next line for the first instance of HeightCurve1 -->
										<!-- <m_fValue>120.000000</m_fValue> -->
										<m_fValue>30.000000</m_fValue>
										<m_ParamName text="Height"/>
									</Element>
								</m_Values>
							</m_Fields>
							<m_ChildCollections/>
							<m_Name text="HeightCurve1"/>
							<m_AppendMergedParameterCollections>false</m_AppendMergedParameterCollections>
						</Element>
'