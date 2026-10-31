# Check Local AI status
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       Local AI Environment Status        " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Ollama Process
$proc = Get-Process ollama -ErrorAction SilentlyContinue
if ($proc) {
    Write-Host "[Process] Ollama is RUNNING (PID: $($proc.Id))" -ForegroundColor Green
} else {
    Write-Host "[Process] Ollama is STOPPED" -ForegroundColor Red
}

# 2. Installed Models
$ollamaExe = "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe"
if (Test-Path $ollamaExe) {
    Write-Host "`n[Installed Models]" -ForegroundColor Yellow
    & $ollamaExe list
}

# 3. GPU VRAM & Usage
Write-Host "`n[GPU Status (NVIDIA GTX 1650)]" -ForegroundColor Yellow
if (Get-Command nvidia-smi -ErrorAction SilentlyContinue) {
    nvidia-smi --query-gpu=name,memory.total,memory.free,memory.used,utilization.gpu --format=csv,noheader
} else {
    Write-Host "nvidia-smi not available"
}

# 4. System Memory
Write-Host "`n[System RAM]" -ForegroundColor Yellow
$os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
if ($os) {
    $free = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $total = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    Write-Host "Free: $free GB / Total: $total GB"
}

