# GitHub Runner - RunasService "Ghetto Solution"

> **When you’re in a rush and just need it to work because, well… *ain’t nobody got time for that*.**

---

## Introduction

Alright, so here’s the deal: I was racing against the clock to get my GitHub Actions Runner up and running as a service. But then I hit the dreaded .NET error, and as much as I love debugging .NET Framework issues, I needed something that *just worked*. So, here’s the ghetto solution I pulled together – minimal setup, no frills, but it’ll keep that runner going. Let’s get it done.

---

### Prerequisites

1. **PowerShell Watcher Script** - A simple script to check if `run.cmd` (or whatever script you’re using) is running, and if it’s not, it restarts it. Low-tech but effective.
2. **`nssm` (Non-Sucking Service Manager)** - Download it from [https://nssm.cc/download](https://nssm.cc/download) because we’re making a service the quick and dirty way.

---

## Steps

### 1. Create the PowerShell Watcher Script

The whole idea is to have this script just sit there, watching `run.cmd` like a hawk. If `run.cmd` stops, the watcher kicks it back into action. Save the script as `GitHubRunnerWatcher.ps1`:

```powershell
# Path to the GitHub Actions Runner (adjust as needed)
$runnerPath = "C:\path\to\actions-runner\run.cmd"  # Update path

# Function to check if run.cmd is running
function Is-RunnerRunning {
    Get-Process | Where-Object { $_.Path -eq $runnerPath }
}

# Infinite loop to keep that runner going
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
```

> **Pro Tip**: Update `$runnerPath` to the actual path of `run.cmd` on your system. And yes, it’ll loop indefinitely. We’re here to get the job done, not finesse the details.

---

### 2. Use `nssm` to Turn the Watcher into a Service

Here’s where `nssm` comes in handy. We’ll use it to turn our watcher script into a service, ensuring that it keeps running, no matter what.

1. **Define Variables and Install the Service**:

   Open PowerShell and run these commands, adjusting paths as needed:

   ```powershell
   # Define service name, script path, and execution options
   $name = 'GitHubRunnerWatcher'  # Keeping the name straightforward
   $file = 'C:\path\to\GitHubRunnerWatcher.ps1' # Path to our watcher script
   $exe = 'powershell.exe'  # We’re using PowerShell to run the script
   $arg = "-ExecutionPolicy Bypass -NoProfile -File `"$($file)`""

   # Path to `nssm`
   $nssmPath = "C:\nssm\nssm.exe"  # Change if you installed nssm elsewhere

   # Install the service
   & $nssmPath install $name $exe $arg

   # Start the service right away
   & $nssmPath start $name
   ```

2. **Explanation of the “Ghetto” Setup**:
   - `$name`: Our service name, nice and to the point.
   - `$file`: Full path to our PowerShell watcher script.
   - `$exe`: Powers the script via `powershell.exe`.
   - `$arg`: Powers through with `-ExecutionPolicy Bypass` (we’re in a hurry here).
   - `nssm install`: Sets up the service using the provided settings.
   - `nssm start`: Starts the service right away, no questions asked.

---

### 3. Verify the Service

To make sure our “Ghetto Solution” is up and running:

1. **Check Windows Services**:
   - Press `Win + R`, type `services.msc`, and hit Enter.
   - Find `GitHubRunnerWatcher` in the list and ensure it’s running.

2. **Check Logs (Optional)**:
   - If you’ve got logging set up in the PowerShell script, you should see entries confirming that `run.cmd` is being monitored and restarted as needed.

---

## Conclusion

And that’s it! In just a few minutes, you’ve got a makeshift service for GitHub Actions Runner that keeps it running without diving into .NET error territory. 

### Parting Words

Next time, maybe we’ll get fancier, but for now?  
![no-time-busy](https://github.com/user-attachments/assets/0fb0517f-e304-4740-8335-373fd895606b)
Enjoy your rush-tested, down-and-dirty GitHub Actions Runner service setup.

