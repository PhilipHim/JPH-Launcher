#!/bin/bash
set -e
cd "$(dirname "$0")"

APP="$PWD/JPH Launcher.app"
mkdir -p "$APP/Contents/MacOS"
cp mac/bundle/Info.plist "$APP/Contents/Info.plist"
rm -rf "$APP/Contents/Resources"
cp -R mac/bundle/Resources "$APP/Contents/Resources"

swiftc -O -framework AppKit -o "$APP/Contents/MacOS/JPHLauncher" mac/main.swift
codesign --force --sign - "$APP"

if [ ! -x .venv/bin/python ]; then
  python3 -m venv .venv
  .venv/bin/pip install -r requirements.txt
fi

open "$APP"
