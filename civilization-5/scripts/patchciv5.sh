#!/usr/bin/env bash

# NOTE: Much of this has been copied from https://github.com/bmaupin/civ-be-linux-fixes/blob/main/patchcivbe.sh

game_directory="/home/${USER}/.local/share/Steam/steamapps/common/Sid Meier's Civilization V"

# Allow game directory to be overridden as a command-line parameter
if [ -n "${1}" ]; then
    game_directory="$1"
fi

# Detect whether we're using native or Proton
if [[ -f "${game_directory}/Civ5XP" ]]; then
    VERSION=linux
    echo "Detected native Linux version of Civ 5"
fi
if [[ -f "${game_directory}/Civ5XP.exe" ]]; then
    VERSION=windows
    echo "Detected Proton version of Civ 5"
fi
if [[ -z "${VERSION}" ]]; then
    echo "Error: Civ 5 installation directory not found. Please provide the path to Civ 5, e.g."
    echo "    $0 \"/home/${USER}/.local/share/Steam/steamapps/common/Sid Meier's Civilization V\""
    exit 1
fi

apply_linux_fixes() {
    echo "Deleting intro videos"
    rm -f "${game_directory}/steamassets/assets/dlc/expansion/civ5xp_opening_movie*"
    rm -f "${game_directory}/steamassets/assets/dlc/expansion2/civ5xp2_opening_movie*"
    rm -f "${game_directory}/steamassets/civ5_opening_movie*"

    echo "Enabling achievements with mods"
    sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "${game_directory}/Civ5XP"

    echo "Skip legal screen"
    sed -i 's/        UIManager:QueuePopup( Controls.LegalScreen, PopupPriority.LegalScreen );/        -- UIManager:QueuePopup( Controls.LegalScreen, PopupPriority.LegalScreen );/' "${game_directory}/steamassets/assets/ui/frontend/frontend.lua"

    echo "Skip mods EULA dialogue"
    sed -i 's/^g_HasAcceptedEULA = false;/g_HasAcceptedEULA = true;/' "${game_directory}/steamassets/assets/ui/frontend/modding/eula.lua"
    sed -i '/--if not isHide and g_HasAcceptedEULA then/s/--//' "${game_directory}/steamassets/assets/ui/frontend/modding/eula.lua"
    sed -i '/--\s*NavigateForward();/s/--//' "${game_directory}/steamassets/assets/ui/frontend/modding/eula.lua"
    sed -i '/--end/s/--//' "${game_directory}/steamassets/assets/ui/frontend/modding/eula.lua"
    sed -i '/--if(not isHide and g_QueueEulaToHide) then/s/--//' "${game_directory}/steamassets/assets/ui/frontend/modding/eula.lua"
    sed -i '/--\s*NavigateBack();/s/--//' "${game_directory}/steamassets/assets/ui/frontend/modding/eula.lua"
    sed -i '/--end/s/--//' "${game_directory}/steamassets/assets/ui/frontend/modding/eula.lua"

    # Check to see if the system has more than 8 cores
    if [ "$(nproc --all)" -gt 8 ]; then
        echo "WARNING: System has more than 8 cores. See https://wiki.archlinux.org/title/Steam/Game-specific_troubleshooting#Civilization_V for details on how to fix potential crashes."
    fi
}

# TODO: All this needs to be tested
apply_windows_fixes() {
    echo "Deleting intro logo videos"
    rm -f "${game_directory}/Assets/DLC/Expansion/Civ5XP_Opening_Movie*"
    rm -f "${game_directory}/Assets/DLC/Expansion2/Civ5XP2_Opening_Movie*"
    rm -f "${game_directory}/Civ5_Opening_Movie*"

    # TODO: test whether the sed patch works in Proton
    # TODO: could we fetch and run the script?
    echo "See here to enable achievements with mods: https://github.com/bmaupin/civ5-cheevos-with-mods"

    echo "Skip legal screen"
    sed -i 's/        UIManager:QueuePopup( Controls.LegalScreen, PopupPriority.LegalScreen );/        -- UIManager:QueuePopup( Controls.LegalScreen, PopupPriority.LegalScreen );/' "${game_directory}/Assets/UI/FrontEnd/FrontEnd.lua"

    echo "Skip mods EULA dialogue"
    sed -i 's/^g_HasAcceptedEULA = false;/g_HasAcceptedEULA = true;/' "${game_directory}/Assets/UI/FrontEnd/Modding/EULA.lua"
    sed -i '/--if not isHide and g_HasAcceptedEULA then/s/--//' "${game_directory}/Assets/UI/FrontEnd/Modding/EULA.lua"
    sed -i '/--\s*NavigateForward();/s/--//' "${game_directory}/Assets/UI/FrontEnd/Modding/EULA.lua"
    sed -i '/--end/s/--//' "${game_directory}/Assets/UI/FrontEnd/Modding/EULA.lua"
    sed -i '/--if(not isHide and g_QueueEulaToHide) then/s/--//' "${game_directory}/Assets/UI/FrontEnd/Modding/EULA.lua"
    sed -i '/--\s*NavigateBack();/s/--//' "${game_directory}/Assets/UI/FrontEnd/Modding/EULA.lua"
    sed -i '/--end/s/--//' "${game_directory}/Assets/UI/FrontEnd/Modding/EULA.lua"
}

if [[ "${VERSION}" == "linux" ]]; then
    apply_linux_fixes
elif [[ "${VERSION}" == "windows" ]]; then
    apply_windows_fixes
fi