#!/usr/bin/env python3

from os import path, mkdir, makedirs, fstat
from sys import argv, stderr
import json, binascii
from struct import pack, unpack

encodebin = lambda s: binascii.b2a_hex(s).decode("ascii")
decodebin = lambda s: binascii.a2b_hex(s)

check_path_safe = lambda p: p == path.normpath(p) and ("/" not in p) and ("\\" not in p)
PADDINGS = [b'', b'\x01', b'\x02\0', b'\x03\0\0']

def read_asset():
    # read filename
    filename_length = unpack("<I", fpk.read(4))[0]
    filename_blocks = (filename_length + 3) // 4
    filename = fpk.read(filename_blocks * 4)
    assert len(filename) == filename_blocks * 4

    # check padding and 'dechiper' filename
    padding = filename[filename_length:]
    assert padding == PADDINGS[len(padding)]
    filename = bytes((x - 1) % 256 for x in filename[:filename_length]).decode("utf-8")
    assert check_path_safe(filename)  # FIXME: windows support? slashes?

    # read rest of entry
    checksum, tag, length, offset = unpack("<IIII", fpk.read(16))
    return {"filename": filename, "checksum": checksum, "tag": tag, "length": length, "offset": offset}

def extract(fpk, folder, db):
    fpk_size = fstat(fpk.fileno()).st_size

    # Read asset table
    version, assets = unpack("<II", fpk.read(8))
    assert version == 2
    assets = [read_asset() for _ in range(assets)]

    # Start reading through file as we extract assets,
    # while checking that asset table is ordered and assets
    # don't overlap and keeping care of padding
    position = fpk.tell()
    parts = []
    for asset in assets:
        # Check for ordering / overlapping and create padding entry if needed
        assert asset["offset"] >= position and asset["offset"] + asset["length"] <= fpk_size
        if asset["offset"] > position:
            length = asset["offset"] - position
            contents = fpk.read(length)
            assert len(contents) == length
            parts.append({"padding": True, "contents": encodebin(contents)})

        # Check that file is not in DB
        for fpk_name, fpk_db in db["fpks"].items():
            filenames = [part["filename"] for part in fpk_db["parts"] if "filename" in part]
            if asset["filename"] in filenames:
                raise Exception("Filename {} already belongs to FPK '{}'".format(asset["filename"], fpk_name))

        # Read the asset contents from FPK
        contents = fpk.read(asset["length"])
        assert len(contents) == asset["length"]
        position = asset["offset"] + asset["length"]

        # Write to disk
        print("Extracting file: {}".format(asset["filename"]))
        file_to_write = path.join(folder, asset["filename"])  # FIXME: replace with path.sep
        makedirs(path.dirname(file_to_write), exist_ok=True)
        with open(file_to_write, "wb") as f:
            f.write(contents)

        # Push part to table
        del asset["length"]
        del asset["offset"]
        parts.append(asset)

    # Produce final padding entry if needed
    assert fpk_size >= position
    if fpk_size > position:
        contents = fpk.read(fpk_size - position)
        assert len(contents) == (fpk_size - position)
        parts.append({"padding": True, "contents": encodebin(contents)})

    return {"version": version, "parts": parts}

def assemble(fpk, folder, fpk_db):
    # Calculate file header size, seek to end of it
    get_part_length = lambda part: 4 + (len(part["filename"]) + 3) // 4 + 16
    header_size = 8 + sum(get_part_length(part) for part in fpk_db["parts"] if "padding" not in part)
    fpk.seek(header_size)
    header = pack("<II", fpk_db["version"], sum(int("padding" not in part) for part in fpk_db["parts"]))

    # Write out entries while building the header
    position = header_size
    for part in fpk_db["parts"]:
        if "padding" in part and part["padding"]:
            fpk.write(decodebin(part["contents"]))
            position = fpk.tell()
            continue

        print("Assembling file: {}".format(part["filename"]))
        file_to_read = path.join(folder, part["filename"])  # FIXME: replace with path.sep
        with open(file_to_read, "rb") as f:
            fpk.write(f.read())

        filename = bytes((x + 1) % 256 for x in section["filename"].encode("utf-8"))
        if len(filename) % 4 != 0:
            filename += PADDINGS[len(filename) % 4]
        offset, position = position, fpk.tell()
        header += pack("<I", len(filename)) + filename + pack("<IIII", part["checksum"], part["tag"], position - offset, offset)

    # Write out header
    fpk.seek(0)
    assert len(header) == header_size
    fpk.write(header)
    print("Header written.")

DB_VERSION = 1

if len(argv) < 3 or argv[1] not in ["d", "a"]:
    print("Usage:\n\n(Re)extract FPKs into directory:\nfpkextract d <extraction dir> <fpk file>...\n\nThen, to reassemble some FPKs:\nfpkextract a <extraction dir> <fpk file>...\n", file=stderr)
    exit(1)

folder, fpks = argv[2], argv[3:]
db_file = path.normpath(folder) + "_db.json"

# FIXME: proper file locking

if argv[1] == "d":
    # Read DB, create DB / folder if they don't exist
    if not path.exists(db_file):
        db = {"version": DB_VERSION, "fpks": {}}
    else:
        with open(db_file, "r") as f:
            db = json.loads(f.read())
        assert db["version"] == DB_VERSION
    if not path.exists(folder):
        mkdir(folder)

    # Process FPKs
    for fpk_file in fpks:
        fpk_name = path.normpath(path.relpath(fpk_file, start=path.dirname(folder)))
        if fpk_name in db["fpks"]:
            del db["fpks"][fpk_name]
        with open(fpk_file, "rb") as fpk:
            print("Processing FPK: {}".format(fpk_name))
            db["fpks"][fpk_name] = extract(fpk, folder, db)

    # Write out DB
    with open(db_file, "w") as f:
        f.write(json.dumps(db, indent=4, sort_keys=True, ensure_ascii=False) + "\n")
else:
    # Read DB
    with open(db_file, "r") as f:
        db = json.loads(f.read())
    assert db["version"] == DB_VERSION

    # Process FPKs
    for fpk_file in fpks:
        fpk_name = path.normpath(path.relpath(fpk_file, start=path.dirname(folder)))
        if fpk_name not in db["fpks"]:
            raise Exception("FPK not found in DB: {}".format(fpk_name))
        with open(fpk_file, "wb") as fpk:
            print("Processing FPK: {}".format(fpk_name))
            assemble(fpk, folder, db["fpks"][fpk_name])
