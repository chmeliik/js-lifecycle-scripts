#!/usr/bin/env python
import argparse
import itertools
import json
import subprocess
import sys
from collections.abc import Iterator
from pathlib import Path
from typing import Any

DOCUMENTED_SCRIPTS = [
    "install",
    "preinstall",
    "postinstall",
    "prepublish",
    "prepublishOnly",
    "prepare",
    "preprepare",
    "postprepare",
    "prepack",
    "postpack",
    "dependencies",
]


def get_all_variants(base_scripts: list[str]) -> list[str]:
    def get_variants(script_name: str) -> Iterator[str]:
        if script_name.startswith("pre"):
            if script_name != "prepare":
                yield from get_variants(script_name.removeprefix("pre"))
        elif script_name.startswith("post"):
            yield from get_variants(script_name.removeprefix("post"))

        yield script_name
        yield f"pre{script_name}"
        yield f"post{script_name}"

    all_scripts = itertools.chain.from_iterable(map(get_variants, base_scripts))
    return list(dict.fromkeys(all_scripts).keys())


def update_packjson(
    packjson: dict[str, Any], scripts: dict[str, str]
) -> dict[str, Any]:
    original_scripts = packjson.get("scripts") or {}
    keep_scripts = {
        scriptname: script
        for scriptname, script in original_scripts.items()
        if scriptname not in scripts
    }
    return packjson | {"scripts": keep_scripts | scripts}


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("package_json")
    ap.add_argument("-n", "--name")
    ap.add_argument("-i", "--in-place", action="store_true")
    args = ap.parse_args()

    name = args.name
    if not name:
        git_branch = subprocess.run(
            ["git", "rev-parse", "--abbrev-ref", "HEAD"],
            check=True,
            capture_output=True,
            text=True,
        ).stdout.strip()
        name = git_branch

    packjson_path = Path(args.package_json)

    with packjson_path.open() as f:
        packjson = json.load(f)

    scriptdir = Path("/tmp", "js-lifecycle", name).as_posix()
    scripts = {
        script: f"mkdir -p {scriptdir} && touch {scriptdir}/{script}.txt"
        for script in get_all_variants(DOCUMENTED_SCRIPTS)
    }

    if args.in_place:
        outfile = packjson_path.open("w")
    else:
        outfile = sys.stdout

    with outfile as f:
        json.dump(update_packjson(packjson, scripts), f, indent=2)
        f.write("\n")


if __name__ == "__main__":
    main()
