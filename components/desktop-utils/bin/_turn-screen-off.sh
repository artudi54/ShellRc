#!/usr/bin/env bash
set -euo pipefail

if [ "${XDG_SESSION_TYPE:-}" = "wayland" ]; then
  kscreen-doctor --dpms off
else
  xset -display "${DISPLAY:-:0}" dpms force off
fi

