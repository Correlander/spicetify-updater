# Back up client settings
Write-Output "Backing up client settings..."
spicetify backup | Out-Null

# Run the built in spicetify updater
Write-Output "Checking if Spicetify is up to date..."
$updateOutput = spicetify update

# Check whether or not it was already up to date
[bool]$isUpdated = $updateOutput[5].Contains("Already up-to-date.")

# If it wasn't up to date, apply backup
if (-not $isUpdated) {
    Write-Output "Spicetify was updated, restoring last backup..."
    spicetify backup restore | Out-Null
}
else {
    Write-Output "Spicetify was already up to date."
}

# Launch spotify
& "$env:APPDATA\Spotify\Spotify.exe"