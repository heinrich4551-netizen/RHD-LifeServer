#!/usr/bin/env python3
"""Minimal uncompressed Arma 3 PBO packer used when AddonBuilder is unavailable.

This is intentionally a build/deployment helper. It does not modify source files
and does not create signing keys.
"""
from __future__ import annotations

import argparse
import pathlib
import struct


def entry_header(name: str, size: int, method: int = 0, timestamp: int = 0) -> bytes:
    return (
        name.encode("utf-8") + b"\x00"
        + struct.pack("<I", method)
        + struct.pack("<I", size)
        + struct.pack("<I", 0)
        + struct.pack("<I", timestamp)
        + struct.pack("<I", size)
    )


def pack(source: pathlib.Path, output: pathlib.Path) -> None:
    files = sorted(p for p in source.rglob("*") if p.is_file())
    output.parent.mkdir(parents=True, exist_ok=True)

    with output.open("wb") as dst:
        # PBO prefix property. The prefix matches the addon PBO's logical root.
        prefix = source.name
        prefix_value = prefix.encode("utf-8") + b"\x00"
        dst.write(b"prefix\x00")
        dst.write(struct.pack("<I", 0))
        dst.write(struct.pack("<I", 0))
        dst.write(struct.pack("<I", 0))
        dst.write(struct.pack("<I", 0))
        dst.write(struct.pack("<I", len(prefix_value)))
        dst.write(prefix_value)

        payloads: list[tuple[str, bytes]] = []
        for path in files:
            rel = path.relative_to(source).as_posix()
            payloads.append((rel, path.read_bytes()))

        for name, data in payloads:
            dst.write(entry_header(name, len(data)))

        # End-of-header marker: empty filename plus five zero DWORDs.
        dst.write(b"\x00" + b"\x00" * 20)

        for _, data in payloads:
            dst.write(data)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=pathlib.Path)
    parser.add_argument("output", type=pathlib.Path)
    args = parser.parse_args()
    if not args.source.is_dir():
        raise SystemExit(f"Source directory not found: {args.source}")
    pack(args.source, args.output)
    print(f"Created PBO: {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
