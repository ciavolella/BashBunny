# Get Network Information
try
{
	$computerPubIP=(Invoke-WebRequest ipinfo.io/ip -UseBasicParsing).Content
} catch {
	$computerPubIP="Error Getting Public IP"
}
$computerIP = get-WmiObject Win32_NetworkAdapterConfiguration|where {$_.Ipaddress.length -gt 1}

# Get Network Interfaces
$Network = Get-WmiObject win32_NetworkAdapterConfiguration | where { $_.MacAddress -notlike $null } | select Index, Description, IPAddress, MACAddress | Format-Table Index, Description, IPAddress, MACAddress
# Get Wifi SSIDs and Passwords
$WLANProfileNames =@()
# Get all the WLAN profile names
$Output = netsh.exe wlan show profiles | Select-String -pattern " : "
# Trim the output to receive only the names
Foreach($WLANProfileName in $Output){
	$WLANProfileNames += (($WLANProfileName -split ":")[1]).Trim()
}
$WLANProfileObjects =@()
# Bind the WLAN profile names and also the passwords to a custom object
Foreach($WLANProfileName in $WLANProfileNames){
	# Get the output for the specified profile name and trim the output to receive the password if there is one
	try{
		$WLANProfilePassword = (((netsh.exe wlan show profiles name="$WLANProfileName" key=clear | select-string -pattern "Key Content") -split ":")[1]).Trim()
	} Catch {
		$WLANProfilePassword = "The password is not stored in this profile"
	}
	# Build the object and add this to an array
	$WLANProfileObject = New-Object PSCustomobject
	$WLANProfileObject | Add-Member -Type NoteProperty -Name "Profile Name" -Value $WLANProfileName
	$WLANProfileObject | Add-Member -Type NoteProperty -Name "Profile Password" -Value $WLANProfilePassword
	$WLANProfileObjects += $WLANProfileObject
	Remove-Variable WLANProfileObject
}

# Generate the output
Clear-Host
Write-Host

"Network Info:"
"==================================================="
"Public IP Address: " + $computerPubIP
($Network| out-string)

"WLAN SSIDs and Passwords:"
"==================================================="
($WLANProfileObjects| out-string)
