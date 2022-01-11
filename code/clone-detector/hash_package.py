#! /usr/bin/env python

import hashlib
import json
import os
import sys


def hash_package(root):
    """
    Compute an md5 hash of all files under root, visiting them in deterministic order.
    `package.json` files are stripped of their `name` and `version` fields.
    """
    m = hashlib.md5()
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames.sort()
        for filename in sorted(filenames):
            path = os.path.join(dirpath, filename)
            m.update(f"{os.path.relpath(path, root)}\n".encode("utf-8"))
            if filename == "package.json":
                pkg = json.load(open(path))
                pkg["name"] = ""
                pkg["version"] = ""
                m.update(json.dumps(pkg, sort_keys=True).encode("utf-8"))
            else:
                with open(path, "rb") as f:
                    m.update(f.read())
    return m.hexdigest()


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <package directory>", file=sys.stderr)
        print(f"  Prints an md5 hash of all files in the given package directory, ignoring package name and version.", file=sys.stderr)
        sys.exit(1)
    print(hash_package(sys.argv[1]))
