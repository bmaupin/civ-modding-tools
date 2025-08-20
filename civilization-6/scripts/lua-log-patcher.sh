#!/usr/bin/env bash

# Patch the Civilization 6 executable to enable Lua.log

if [ -z "${1}" ]; then
    echo 'Error: please provide path to the Civ 6 binary to patch'
    echo "Usage: $0 BINARY_PATH"
    exit 1
fi

if ! file "${1}" | grep -q 'ELF 64-bit LSB executable'; then
    echo "Error: ${1} is not a Linux binary"
    exit 1
fi

echo "Please wait ..."

bin_path="${1}"

# Get the virtual address we need to patch
virtual_addresses=$(objdump --demangle --disassemble "${bin_path}" | grep -A20 -B5 'LuaSystem::LuaScriptSystem::LuaScriptSystem' | grep 'movabs $0xffffffff00000000' | awk '{print $1}' | cut -d : -f 1)

if [[ -z "$virtual_addresses" ]]; then
    echo "Unable to find addresses to patch; has the file already been patched?"
    exit 1
fi

# Get the file offset corresponding to the virtual address of the search string
text_file_offset=$(objdump -h "${bin_path}" | grep .text | awk '{ print $6 }')
text_virtual_offset=$(objdump -h "${bin_path}" | grep .text | awk '{ print $4 }')

# Patch each virtual address found
for virtual_address in ${virtual_addresses}; do
    file_offset=$((0x$virtual_address + 0x$text_file_offset - 0x$text_virtual_offset))

    bytes=$(xxd -p -l 10 --seek "${file_offset}" "${bin_path}" | tr -d '\n')

    # Make sure bytes match what we expect
    if [[ "${bytes}" != "48b800000000ffffffff" ]]; then
        echo "Unexpected bytes at offset ${file_offset}: ${bytes}"
        echo "This shouldn't happen; please check the binary file."
        exit 1
    fi

    patched_bytes='48b801000000ffffffff'

    echo "Patching bytes at offset ${file_offset} from ${bytes} to ${patched_bytes}"

    # Write the patched bytes back to the binary file
    echo "${patched_bytes}" | xxd -p -r | dd of="${bin_path}" bs=1 conv=notrunc seek="${file_offset}"
done