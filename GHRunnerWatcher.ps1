# Path to the run.cmd file we're monitoring
$runnerPath = "C:\path\to\actions-runner\run.cmd"  # Update with actual path

function Is-RunnerRunning {
    Get-Process | Where-Object { $_.Path -eq $runnerPath }
}

while ($true) {
    if (-not (Is-RunnerRunning)) {
        Write-Output "$(Get-Date): Runner not detected. Starting run.cmd..."
        Start-Process -FilePath $runnerPath -WindowStyle Hidden
        Write-Output "$(Get-Date): run.cmd started."
    } else {
        Write-Output "$(Get-Date): Runner is already running."
    }
    Start-Sleep -Seconds 10
}
