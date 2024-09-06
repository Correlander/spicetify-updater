Write-Output 'Spicetify Auto-Update Installer - https://github.com/Correlander/spicetify-updater'
Write-Output "This installer will install a script to update spicetify to your computer, and add a shortcut to run it on launch to your startup folder."
Read-Host "Press any key to continue..."

# Define the directory and file paths
$directoryPath = "$env:LOCALAPPDATA\SpicetifyUpdater"
$fileName = "Updater.ps1"
$filePath = Join-Path -Path $directoryPath -ChildPath $fileName
$updaterFileUrl = "https://raw.githubusercontent.com/Correlander/spicetify-updater/main/Updater.ps1"
$licenseFileUrl = "https://raw.githubusercontent.com/Correlander/spicetify-updater/main/LICENSE"

# Check if the directory exists
if (-not (Test-Path -Path $directoryPath)) {
    # If not, create it -- and any non-existing parent directories
    New-Item -Path $directoryPath -ItemType Directory -ErrorAction SilentlyContinue
}

# Check if the file exists
if (-not (Test-Path -Path $filePath)) {
    # If not, download the file
    Invoke-WebRequest -Uri $updaterFileUrl -OutFile $filePath
    Invoke-WebRequest -Uri $licenseFileUrl -OutFile $filePath
    Write-Output "Downloaded $fileName to $directoryPath."
} else {
    Write-Output "$fileName already exists in $directoryPath."
}

# Create the shortcut
[string]$SHORTCUT_PATH = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\SpicetifyUpdater.lnk"
[string]$TARGET_PATH = "powershell.exe"
[string]$ARGUMENTS = "-NoProfile -WindowStyle Minimized -ExecutionPolicy Bypass -File $PSScriptRoot\Updater.ps1"
[string]$WORKING_DIRECTORY = $PSScriptRoot

Write-Output "The installer will now create a shortcut to powershell inside the following folder: $SHORTCUT_PATH which will run Updater.ps1 on login."
Read-Host "Press any key to continue..."

# Add it to startup
$SHELL = New-Object -ComObject WScript.Shell
$SHORTCUT = $SHELL.CreateShortcut($SHORTCUT_PATH)

$SHORTCUT.TargetPath = $TARGET_PATH
$SHORTCUT.Arguments = $ARGUMENTS
$SHORTCUT.WorkingDirectory = $WORKING_DIRECTORY
$SHORTCUT.Description = 'Shortcut that adds the updater script for spicetify to windows startup.'

$SHORTCUT.Save()