$OutputDir = "C:\Users\Owner\Documents\dev\local-ai-benchmark"
$ResultsJsonPath = Join-Path $OutputDir "benchmark_results.json"

if (-not (Test-Path $ResultsJsonPath)) {
    Write-Host "Results JSON not found."
    exit 1
}

$Results = Get-Content -Path $ResultsJsonPath -Raw -Encoding UTF8 | ConvertFrom-Json

$Grouped = $Results | Group-Object -Property Model

Write-Host "=== BENCHMARK SUMMARY ==="
foreach ($g in $Grouped) {
    Write-Host "`nModel: $($g.Name)"
    $AvgSpeed = [math]::Round(($g.Group | Measure-Object -Property EvalTokensPerSec -Average).Average, 2)
    $TotalTokens = ($g.Group | Measure-Object -Property EvalTokens -Sum).Sum
    Write-Host "  Average Eval Speed: $AvgSpeed tok/s"
    Write-Host "  Total Generated Tokens: $TotalTokens"
    foreach ($item in $g.Group) {
        Write-Host "    $($item.TestId): $($item.TotalSec)s ($($item.EvalTokensPerSec) tok/s, $($item.EvalTokens) tokens)"
    }
}

