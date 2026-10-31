# Start Ollama service if not running
$ollamaProc = Get-Process ollama -ErrorAction SilentlyContinue
if ($ollamaProc) {
    Write-Host "[OK] Ollama is already running (PID: $($ollamaProc.Id))." -ForegroundColor Green
} else {
    $ollamaExe = "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe"
    if (Test-Path $ollamaExe) {
        Write-Host "[INFO] Starting Ollama serve..." -ForegroundColor Cyan
        Start-Process -FilePath $ollamaExe -ArgumentList "serve" -WindowStyle Hidden
        Start-Sleep -Seconds 2
        Write-Host "[OK] Ollama started successfully." -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Ollama executable not found at $ollamaExe" -ForegroundColor Red
    }
}

