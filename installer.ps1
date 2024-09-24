# Fluff
Write-Host "Spicetify Updater Install Script v1.1$"
Write-Host "Copyright (c) 2024 Correlander - MIT License"
Write-Host "https://github.com/Correlander/spicetify-updater"
Write-Host "`n"

# Variables
[String]$directoryPath = "$env:LOCALAPPDATA\SpicetifyUpdater"

# Function for prompts to handle startup. Add or remove Updater.ps1 to startup.
function Startup-Manager {

    # Give prompts
    Write-Host "Enter a number to select one of the following options:"
    Write-Host "[0] Add to startup."
    Write-Host "[1] Remove from startup."
    Write-Host "[2] Back."

    [bool]$choosing = $true
    while ($choosing) {
        # Get user's input
        $input = Read-Host -Prompt "Type a number then press Enter"
        
        switch ($input) {
            '0' {
                # Create the shortcut and save it in the startup folder
                [String]$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\SpicetifyUpdater.lnk"
                [String]$targetPath = "powershell.exe"
                [String]$arguments = "-NoProfile -WindowStyle Minimized -ExecutionPolicy Bypass -File $env:LOCALAPPDATA\SpicetifyUpdater\Updater.ps1"

                $shell = New-Object -ComObject WScript.Shell
                $shortcut = $shell.CreateShortcut($shortcutPath)

                $shortcut.TargetPath = $targetPath
                $shortcut.Arguments = $arguments
                $shortcut.Description = 'Shortcut that adds the updater script for spicetify to windows startup.'
                $shortcut.WorkingDirectory = $script:directoryPath
                $shortcut.WindowStyle = '7'

                $shortcut.Save()

                Write-Host "The shortcut was created! If you haven't installed the script yet, this will NOT WORK. Make sure to go through the install for the script as well!" -ForegroundColor Green -BackgroundColor Black
            }
            '1' {
                # remove the startup shortcut, if it exists
                if (Test-Path -Path $shortcutPath) {
                    Remove-Item -Path $shortcutPath
                    Write-Host "Removed the shortcut from startup!" -ForegroundColor Green -BackgroundColor Black
                } else {
                    Write-Host "There was no shortcut to remove! You're already good to go." -ForegroundColor Green -BackgroundColor Black
                }
            }
            '2' {
                $choosing = $false
            }
            default {
                Write-Host "That is not a valid input... try again." -ForegroundColor Red -BackgroundColor Black
            }
        }
    }
}

# Function to install the updater script
function Run-Installer {
    
    # Variables
    [String]$fileName = "Updater.ps1"
    [String]$updaterFilePath = Join-Path -Path $directoryPath -ChildPath "Updater.ps1"
    [String]$licenseFilePath = Join-Path -Path $directoryPath -ChildPath "LICENSE.txt"
    [String]$updaterFileUrl = 'https://raw.githubusercontent.com/Correlander/spicetify-updater/main/Updater.ps1'
    [String]$licenseFileUrl = 'https://raw.githubusercontent.com/Correlander/spicetify-updater/main/LICENSE'

    # Check if the directory exists
    if (-not (Test-Path -Path $script:directoryPath)) {
        # If not, create it -- and any non-existing parent directories
        Write-Host "Directory didn't exist, creating it..." -ForegroundColor Blue -BackgroundColor Black
        New-Item -Path $directoryPath -ItemType Directory
    } else {
        Write-Host "Directory already exists..." -ForegroundColor Blue -BackgroundColor Black
    }
    # Download the file. If it already exists, it is simply overwrote
    Invoke-WebRequest -Uri $updaterFileUrl -OutFile $updaterFilePath
    Write-Host "Downloaded Updater.ps1" -ForegroundColor Blue -BackgroundColor Black
    Invoke-WebRequest -Uri $licenseFileUrl -OutFile $licenseFilePath
    Write-Host "Downloaded LICENSE.txt" -ForegroundColor Blue -BackgroundColor Black
}

# Main logic for the UI
while ($true) {
    
    # Give prompts
    Write-Host "Enter a number to select one of the following options:"
    Write-Host "[0] Install the Spicetify updater script."
    Write-Host "[1] Add or remove the Spicetify updater script from startup."
    Write-Host "[2] Exit."

    [bool]$choosing = $true
    while ($choosing) {
        # Get user's input
        $input = Read-Host -Prompt "Type a number then press Enter"

        switch ($input) {
            '0' {
                Write-Host "Running installer..." -ForegroundColor Blue -BackgroundColor Black
                Run-Installer
                $choosing = $false
            }
            '1' {
                Write-Host "Going to startup menu...`n`n" -ForegroundColor Blue -BackgroundColor Black
                Startup-Manager
                Write-Host "`n`n"
                $choosing = $false
            }
            '2'{
                Write-Host 'Exiting. Goodbye...' -ForegroundColor Yellow -BackgroundColor Black
                Exit
            }
            default {
                Write-Host 'That is not a valid input... try again.' -ForegroundColor Red -BackgroundColor Black
            }
        }
    }  
}