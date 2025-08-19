#!/usr/bin/env bash

# Patch the Civilization 6 executable to enable Lua.log

if [ -z "${1}" ]; then
    echo 'Error: please provide path to the Civ 6 binary to patch'
    echo "Usage: $0 BINARY_PATH"
    exit 1
fi

echo "Please wait, this may take a minute or two ..."

bin_path="${1}"

# Get the virtual address we need to patch
virtual_address=$(objdump -D "${bin_path}" | grep -A20 -B5 '_ZN9LuaSystem15LuaScriptSystemC1EPFPvS1_S1_mmEii' | grep 'movabs $0xffffffff00000000' | awk '{print $1}' | cut -d : -f 1)

if [[ -z "$virtual_address" ]]; then
    echo "Unable to find address to patch; has the file already been patched?"
    exit 1
fi

# Get the file offset corresponding to the virtual address of the search string
text_file_offset=$(objdump -h "${bin_path}" | grep .text | awk '{ print $6 }')
text_virtual_offset=$(objdump -h "${bin_path}" | grep .text | awk '{ print $4 }')

file_offset=$((0x$virtual_address + 0x$text_file_offset - 0x$text_virtual_offset))

bytes=$(xxd -p -l 10 --seek "${file_offset}" "${bin_path}" | tr -d '\n')

# Make sure bytes match what we expect
if [[ "${bytes}" != "48b800000000ffffffff" ]]; then
    echo "Unexpected bytes at offset ${file_offset}: ${bytes}"
    echo "This shouldn't happen; please check the binary file."
    exit 1
fi

# Apply the patch to the extracted bytes
patched_bytes=$(echo "${bytes}" | sed 's/48b800000000ffffffff/48b801000000ffffffff/')

# Write the patched bytes back to the binary file
echo "${patched_bytes}" | xxd -p -r | dd of="${bin_path}" bs=1 conv=notrunc seek="${file_offset}"
