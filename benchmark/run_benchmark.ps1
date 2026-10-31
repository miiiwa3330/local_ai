param (
    [string[]]$Models = @("qwen2.5:3b")
)

$OllamaUrl = "http://127.0.0.1:11434"
$OutputDir = "C:\Users\Owner\Documents\dev\local-ai-benchmark"
$PromptsFile = Join-Path $OutputDir "prompts.json"

$Prompts = Get-Content -Path $PromptsFile -Raw -Encoding UTF8 | ConvertFrom-Json

$Results = @()
$ResultsJsonPath = Join-Path $OutputDir "benchmark_results.json"
if (Test-Path $ResultsJsonPath) {
    try {
        $Existing = Get-Content -Path $ResultsJsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($Existing) {
            $Results = @($Existing)
        }
    } catch {
        Write-Host "Warning: Could not parse existing results JSON: $_"
    }
}

foreach ($Model in $Models) {
    Write-Host "========================================================"
    Write-Host "Target Model: $Model"
    Write-Host "========================================================"

    foreach ($p in $Prompts) {
        Write-Host "Running Test: $($p.id) - $($p.category)..."

        $ReqObj = @{
            model = $Model
            prompt = $p.prompt
            stream = $false
            options = @{
                temperature = 0.6
                num_predict = 2048
            }
        }
        $ReqBody = $ReqObj | ConvertTo-Json -Depth 5

        $StartTime = Get-Date
        try {
            $Response = Invoke-RestMethod -Uri "$OllamaUrl/api/generate" -Method Post -Body $ReqBody -ContentType "application/json; charset=utf-8" -TimeoutSec 600
            $EndTime = Get-Date

            $TotalSec = [math]::Round(($EndTime - $StartTime).TotalSeconds, 2)
            $EvalTokens = $Response.eval_count
            $EvalDurationNs = $Response.eval_duration
            $EvalTokensPerSec = 0
            if ($EvalDurationNs -gt 0) {
                $EvalTokensPerSec = [math]::Round($EvalTokens / ($EvalDurationNs / 1e9), 2)
            }

            $PromptEvalTokens = $Response.prompt_eval_count
            $PromptEvalNs = $Response.prompt_eval_duration
            $PromptTokensPerSec = 0
            if ($PromptEvalNs -gt 0) {
                $PromptTokensPerSec = [math]::Round($PromptEvalTokens / ($PromptEvalNs / 1e9), 2)
            }

            Write-Host "  -> Done in ${TotalSec}s | Gen: $EvalTokens tokens ($EvalTokensPerSec tok/s) | Prompt: $PromptEvalTokens tokens"

            $TestResult = [PSCustomObject]@{
                Model = $Model
                TestId = $p.id
                Category = $p.category
                TotalSec = $TotalSec
                EvalTokens = $EvalTokens
                EvalTokensPerSec = $EvalTokensPerSec
                PromptTokens = $PromptEvalTokens
                PromptTokensPerSec = $PromptTokensPerSec
                Response = $Response.response
            }
            $Results += $TestResult

            $SafeModelName = $Model -replace '[:/]', '_'
            $RespFile = Join-Path $OutputDir "$($SafeModelName)_$($p.id).txt"
            [System.IO.File]::WriteAllText($RespFile, $Response.response, [System.Text.Encoding]::UTF8)

        } catch {
            Write-Host "Error running test $($p.id): $_"
        }
    }
}

$ResultsJsonPath = Join-Path $OutputDir "benchmark_results.json"
$Results | ConvertTo-Json -Depth 10 | Set-Content -Path $ResultsJsonPath -Encoding UTF8
Write-Host "All benchmark tests finished! Results saved to $ResultsJsonPath"
