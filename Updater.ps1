# ANSI code variables for ease of use
$bold = "`e[1m"
$green = "`e[32m"
$blue = "`e[34m"
$reset = "`e[0m"

# Reset log file
Set-Content -Path ".\log.txt" -Value ""

# Function to both print and log something
function Write-Log {
    param (
        [string]$message
    )

    # Write to console
    Write-Host $message

    # Write to log
    $message | Out-File -FilePath ".\log.txt" -Append
}

# This print message is because I have the window to start as minimized. If someone clicks on it, I want it to say what it's doing.
# A non-descript powershell window running on startup is scary, even if you know you installed a script that runs on startup
# It also is just fancy and fun ;p
Write-Log("${bold}${green}Spicetify Updater Script${reset}")
Write-Log("Copyright (c) 2024 Correlander - MIT License")
Write-Log("https://github.com/Correlander/spicetify-updater]")

# Back up client settings
Write-Log("${blue}Backing up client settings...")
spicetify backup | Out-Null
Write-Log("${bold}${green}OK${reset}")

# Run the built in spicetify updater
Write-Log("${blue}Checking if Spicetify is up to date...${reset}")
$updateOutput = spicetify update

# Check whether or not it was already up to date
[bool]$isUpdated = $updateOutput[5].Contains("Already up-to-date.")

# If it wasn't up to date, apply backup
if (-not $isUpdated) {
    Write-Log("${blue}Spicetify was updated, restoring last backup...${reset}")
    spicetify backup restore | Out-Null
    Write-Log("${bold}${green}OK${reset}")
}
else {
    Write-Log("${bold}${green}Spicetify was already up to date.${reset}")
}

# Launch spotify
Write-Log("${bold}${green}Launching Spotify and exiting updater... Goodbye.${reset}")
& "$env:APPDATA\Spotify\Spotify.exe"
# Wait for three seconds, so it's not just a flash
Start-Sleep -Seconds 3