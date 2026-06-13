#!/usr/bin/env python3
import os
import shutil
import sys
from pathlib import Path

REPO_ROOT = Path.cwd()
SHARED = REPO_ROOT.joinpath("Shared config")
WM = REPO_ROOT.joinpath("WM")
HOME = Path.home()
CONFIG_DIR = os.getenv("XDG_CONFIG_DIR", HOME.joinpath(".config"))

def list_shared_entries():
    # return relative paths under Shared config
    entries = []
    for p in SHARED.rglob("*"):
        if p == SHARED:
            continue
        rel = p.relative_to(SHARED)
        # only top-level entries (files/dirs directly under Shared config) and their subtree
        entries.append(rel)
    return sorted(set([p.parts[0] for p in entries]), key=str)

def list_wm_entries():
    # collect WM top-level directories (hyprland, i3wm, etc.) and their subtree
    wm_entries = {}
    for wm_dir in WM.iterdir():
        if not wm_dir.is_dir():
            continue
        top = []
        for p in wm_dir.rglob("*"):
            if p == wm_dir:
                continue
            rel = p.relative_to(wm_dir)
            top.append(rel)
        wm_entries[wm_dir.name] = sorted(set([p.parts[0] for p in top]), key=str)
    return wm_entries

def copy_item(src: Path, dest: Path):
    dest_parent = dest.parent
    dest_parent.mkdir(parents=True, exist_ok=True)
    if src.is_dir():
        if dest.exists():
            print(f"Destination exists, skipping directory copy: {dest}")
            return
        shutil.copytree(src, dest)
        print(f"Copied directory {src} -> {dest}")
    else:
        if dest.exists():
            print(f"Destination exists, skipping file copy: {dest}")
            return
        shutil.copy2(src, dest)
        print(f"Copied file {src} -> {dest}")

def find_in_shared(name):
    p = SHARED / name
    return p if p.exists() else None

def find_in_wm(wm_name, name):
    p = WM / wm_name / name
    return p if p.exists() else None

def prompt_choice(rel):
    # minimal prompt: 1 skip, 2 shared, 3 wm (if available)
    while True:
        resp = input(f"Choose for '{rel}': [s]kip, [S]hared config, [W]M-specific: ").strip().lower()
        if resp in ("s","skip"):
            return "skip"
        if resp in ("s","shared","sh"):
            return "shared"
        if resp in ("w","wm"):
            return "wm"
        print("Invalid, enter s / S / W.")

def main():
    # 1) determine wm from XDG_SESSION_DESKTOP
    xdg = os.environ.get("XDG_SESSION_DESKTOP", "").strip()
    wm_name = xdg if xdg else None
    if wm_name:
        print(f"Detected XDG_SESSION_DESKTOP='{wm_name}'")
    else:
        print("XDG_SESSION_DESKTOP not set; WM-specific copying will be skipped unless chosen manually.")

    shared_tops = list_shared_entries()
    wm_entries = list_wm_entries()  # dict: wm -> [tops]

    # build set of candidate top-level names (union of shared tops and all wm tops)
    candidate_names = set(shared_tops)
    for lst in wm_entries.values():
        candidate_names.update(lst)
    candidate_names = sorted(candidate_names)

    for name in candidate_names:
        target = CONFIG_DIR / name
        exists_in_config = target.exists()
        exists_in_shared = (SHARED / name).exists()
        exists_in_wm = False
        wm_path = None
        if wm_name and (WM / wm_name / name).exists():
            exists_in_wm = True
            wm_path = WM / wm_name / name

        # If exists in ~/.config already, skip
        if exists_in_config:
            print(f"Already in ~/.config: {name} — skipping")
            continue

        # If present in shared (or wm) and not present in config, auto-copy: prefer WM-specific if XDG matches and entry exists there
        if wm_name and exists_in_wm:
            src = wm_path
            print(f"Copying WM-specific '{name}' -> {target}")
            copy_item(src, target)
            continue
        if exists_in_shared:
            src = SHARED / name
            print(f"Copying Shared config '{name}' -> {target}")
            copy_item(src, target)
            continue

        # Not in config, not in shared for this name. Offer choice only if there is source available in either shared or any WM
        # Collect available sources
        available_sources = []
        if (SHARED / name).exists():
            available_sources.append(("shared", SHARED / name))
        # if any wm has it, add first match
        wm_found = None
        for wn, lst in wm_entries.items():
            if name in lst:
                wm_found = WM / wn / name
                break
        if wm_found:
            available_sources.append(("wm", wm_found))

        if not available_sources:
            print(f"No source found for '{name}' in Shared config or WM directories — skipping.")
            continue

        # prompt user
        print(f"Missing in ~/.config: '{name}'. Sources available: {', '.join(k for k,_ in available_sources)}")
        choice = prompt_choice(name)
        if choice == "skip":
            print(f"Skipped '{name}'")
            continue
        if choice == "shared":
            src = next((p for k,p in available_sources if k=="shared"), None)
            if src:
                copy_item(src, CONFIG_DIR / name)
            else:
                print("Shared source not available; skipped.")
            continue
        if choice == "wm":
            src = next((p for k,p in available_sources if k=="wm"), None)
            if src:
                copy_item(src, CONFIG_DIR / name)
            else:
                print("WM source not available; skipped.")
            continue

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nInterrupted by user.")

