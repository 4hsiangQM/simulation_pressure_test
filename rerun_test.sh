#!/usr/bin/env bash
set -euo pipefail

PY_FILE="/Users/jackchao/Desktop/Project/QM/AS_winter_school/simulation_pressure_test/04_resonator_spectroscopy_single.py"

MIN=2
MAX=7   # 隨機秒數範圍：MIN~MAX

while true; do
  s=$((RANDOM % (MAX - MIN + 1) + MIN))
  echo "Sleep $s sec..."
  sleep "$s"
  python "$PY_FILE"
done