#!/usr/bin/env bash
set -u  # 不用 set -e，避免失敗就整個腳本退出

PY_FILE="/Users/jackchao/Desktop/Project/QM/AS_winter_school/simulation_pressure_test/04_resonator_spectroscopy_single.py"

MIN=2
MAX=7   # 隨機秒數範圍：MIN~MAX

LOG_FILE="./rerun_random.log"

success=0
fail=0
total=0

echo "===== Start $(date '+%F %T') =====" | tee -a "$LOG_FILE"
echo "Script: $PY_FILE" | tee -a "$LOG_FILE"
echo "Random sleep: ${MIN}-${MAX}s" | tee -a "$LOG_FILE"
echo "Log: $LOG_FILE" | tee -a "$LOG_FILE"
echo "===============================" | tee -a "$LOG_FILE"

while true; do
  s=$((RANDOM % (MAX - MIN + 1) + MIN))
  echo "⏳ Sleep $s sec..." | tee -a "$LOG_FILE"
  sleep "$s"

  echo "▶ $(date '+%F %T') Running..." | tee -a "$LOG_FILE"

  # 跑你的 python（如果要 conda env，改這行：conda run -n Qfort_QPU python "$PY_FILE"）
  python "$PY_FILE" >>"$LOG_FILE" 2>&1
  code=$?

  total=$((total + 1))
  if [ $code -eq 0 ]; then
    success=$((success + 1))
    echo "✅ Success (exit=0)" | tee -a "$LOG_FILE"
  else
    fail=$((fail + 1))
    echo "❌ Fail (exit=$code)" | tee -a "$LOG_FILE"
  fi

  echo "📊 Total=$total | Success=$success | Fail=$fail | SuccessRate=$((success*100/total))%" | tee -a "$LOG_FILE"
  echo "--------------------------------" | tee -a "$LOG_FILE"
done