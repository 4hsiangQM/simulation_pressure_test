#!/usr/bin/env bash
set -u  # 不用 set -e，避免失敗就整個腳本退出

# ✅ 把你要隨機跑的 .py 檔放在這裡（至少兩個）
PY_FILES=(
  "/Users/jackchao/Desktop/Project/QM/AS_winter_school/simulation_pressure_test/02_raw_adc_traces_mw_fem.py"
  "/Users/jackchao/Desktop/Project/QM/AS_winter_school/simulation_pressure_test/03_time_of_flight_mw_fem.py"
  "/Users/jackchao/Desktop/Project/QM/AS_winter_school/simulation_pressure_test/04_resonator_spectroscopy_single.py"
  
)

MIN=2
MAX=7   # 隨機秒數範圍：MIN~MAX

LOG_FILE="./simulation_and_TOF.log"

success=0
fail=0
total=0

# per-script counter（用 associative array，macOS 內建 bash 3.x 不支援，所以用兩個普通陣列）
n=${#PY_FILES[@]}
succ_by_idx=()
fail_by_idx=()
for ((i=0; i<n; i++)); do
  succ_by_idx[i]=0
  fail_by_idx[i]=0
done

echo "===== Start $(date '+%F %T') =====" | tee -a "$LOG_FILE"
echo "Scripts:" | tee -a "$LOG_FILE"
for ((i=0; i<n; i++)); do
  echo "  [$i] ${PY_FILES[i]}" | tee -a "$LOG_FILE"
done
echo "Random sleep: ${MIN}-${MAX}s" | tee -a "$LOG_FILE"
echo "Log: $LOG_FILE" | tee -a "$LOG_FILE"
echo "===============================" | tee -a "$LOG_FILE"

while true; do
  s=$((RANDOM % (MAX - MIN + 1) + MIN))
  echo "⏳ Sleep $s sec..." | tee -a "$LOG_FILE"
  sleep "$s"

  idx=$((RANDOM % n))
  py="${PY_FILES[idx]}"

  echo "▶ $(date '+%F %T') Running [${idx}] $py" | tee -a "$LOG_FILE"

  # 跑你的 python（如果要 conda env：conda run -n Qfort_QPU python "$py" >>"$LOG_FILE" 2>&1）
  python "$py" >>"$LOG_FILE" 2>&1
  code=$?

  total=$((total + 1))
  if [ $code -eq 0 ]; then
    success=$((success + 1))
    succ_by_idx[idx]=$((succ_by_idx[idx] + 1))
    echo "✅ Success (exit=0)" | tee -a "$LOG_FILE"
  else
    fail=$((fail + 1))
    fail_by_idx[idx]=$((fail_by_idx[idx] + 1))
    echo "❌ Fail (exit=$code)" | tee -a "$LOG_FILE"
  fi

  echo "📊 Total=$total | Success=$success | Fail=$fail | SuccessRate=$((success*100/total))%" | tee -a "$LOG_FILE"
  echo "Per-script stats:" | tee -a "$LOG_FILE"
  for ((i=0; i<n; i++)); do
    echo "  [$i] S=${succ_by_idx[i]} F=${fail_by_idx[i]}  ${PY_FILES[i]}" | tee -a "$LOG_FILE"
  done
  echo "--------------------------------" | tee -a "$LOG_FILE"
done