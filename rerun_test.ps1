# rerun_random.ps1
$PyFile = "C:\path\to\04_resonator_spectroscopy_single.py"

$Min = 2
$Max = 7
$LogFile = ".\rerun_random.log"

$success = 0
$fail = 0
$total = 0

"===== Start $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') =====" | Tee-Object -FilePath $LogFile -Append
"Script: $PyFile" | Tee-Object -FilePath $LogFile -Append
"Random sleep: $Min-$Max sec" | Tee-Object -FilePath $LogFile -Append
"Log: $LogFile" | Tee-Object -FilePath $LogFile -Append
"===============================" | Tee-Object -FilePath $LogFile -Append

while ($true) {
    $s = Get-Random -Minimum $Min -Maximum ($Max + 1)
    "⏳ Sleep $s sec..." | Tee-Object -FilePath $LogFile -Append
    Start-Sleep -Seconds $s

    "▶ $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Running..." | Tee-Object -FilePath $LogFile -Append

    # 執行 python，stdout/stderr 都寫進 log
    & python $PyFile *>> $LogFile
    $code = $LASTEXITCODE

    $total++
    if ($code -eq 0) {
        $success++
        "✅ Success (exit=0)" | Tee-Object -FilePath $LogFile -Append
    } else {
        $fail++
        "❌ Fail (exit=$code)" | Tee-Object -FilePath $LogFile -Append
    }

    $rate = [math]::Floor(($success * 100) / $total)
    "📊 Total=$total | Success=$success | Fail=$fail | SuccessRate=${rate}%" | Tee-Object -FilePath $LogFile -Append
    "--------------------------------" | Tee-Object -FilePath $LogFile -Append
}