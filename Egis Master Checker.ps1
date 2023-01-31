$BasicApps = @("Sophos",
            "Symprex Email Signature",
            "Mail Manager",
            "Autodesk Navisworks Freedom",
            "Autodesk DWG TrueView",
            "Autodesk Design Review",
            "Autodesk Desktop Connector"
            "Bluebeam Revu"
            )

#Lenovo Vantage
$LenovoVantage = Get-AppxPackage -Name "*.LenovoCompanion" | Select Name
if($LenovoVantage.Name) {
    Write-Host "Lenovo Vantage is installed, check for driver updates." -BackgroundColor DarkGreen
} else {
    Write-Host "Lenovo Vantage not found, please install to update lenovo drivers" -BackgroundColor Red
}


#Check for localadm user
$localadmUser = Get-LocalUser | Where-Object {$_.Name -eq "localadm"}

if($localadmUser.Name) {
    Write-Host "localadm user created." -BackgroundColor DarkGreen
} else {
    Write-Host "localadm user not found!." -BackgroundColor Red
}

#Check if hosts file has 192.168.192.4 FS01Az
$hostsFile = Get-Content -Path "C:\Windows\System32\drivers\etc\hosts"

if($hostsFile | Where-Object {$_ -match "192.168.192.4*"}){
    Write-Host "Hosts file has 192.168.192.4 FS01Az" -BackgroundColor DarkGreen
} else {
    Write-Host "Hosts file 192.168.192.4 FS01Az not found" -BackgroundColor Red
}

#Getting computer system information
$Domain = Get-WMIObject Win32_ComputerSystem | Select Domain
$Owner = Get-WMIObject Win32_ComputerSystem | Select PrimaryOwnerName
$Hostname = Get-WMIObject Win32_ComputerSystem | Select Name
$computerDescription = Get-WmiObject -Class Win32_OperatingSystem | Select Description

#$registeredOwner = Get-ItemProperty -Path ”HKLM:\Software\Microsoft\Windows NT\CurrentVersion”
$registeredOrg = Get-ItemProperty -Path ”HKLM:\Software\Microsoft\Windows NT\CurrentVersion”

#Querying installed softwares
$InstalledApps = Get-ItemProperty -Path $(
		'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*';
		'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*';
		'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*';
		'HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*';
	) -ErrorAction 'SilentlyContinue'
#foreach($InstalledApp in $InstalledApps | Where-Object {$_.DisplayName -match "AutoCAD"}) {Write-Host $InstalledApp.DisplayName }

echo ""
if($Domain.Domain -eq "egis.racine.local"){
    Write-Host "Domain`t`t: $($Domain.Domain)" -BackgroundColor DarkGreen
} else {
    Write-Host "Domain`t`t: $($Domain.Domain)" -BackgroundColor Red
}
if($Hostname.Name -match "POR800*") {
    Write-Host "Hostname`t: $($Hostname.Name)" -BackgroundColor DarkGreen 
} else {
    Write-Host "Hostname`t: $($Hostname.Name)"-BackgroundColor Red
}
if($registeredOrg.RegisteredOrganization -eq "WME ENGINEERING CONSULTANTS"){

    Write-Host "Registered Org`t: $($registeredOrg.RegisteredOrganization)" -BackgroundColor DarkGreen
} else {
    Write-Host "Registered Org`t: $($registeredOrg.RegisteredOrganization)" -BackgroundColor Red
}
if($Owner.PrimaryOwnerName -eq "EGIS SA"){
    Write-Host "Owner`t: $($Owner.PrimaryOwnerName)" -BackgroundColor DarkGreen
} else {
    Write-Host "Owner`t: $($Owner.PrimaryOwnerName)" -BackgroundColor Red

}
Write-Host "Computer Desc`t: $($computerDescription.Description)"

echo ""
$TimeZone = Get-TimeZone | Select Id
if($TimeZone.Id -eq "Arabian Standard Time") {
    Write-Host "Timezone`t:$($TimeZone.Id)" -BackgroundColor DarkGreen
} else {
    Write-Host "Time zone`t: Not set to Arabian Standard Time" -BackgroundColor Red
}

#Check for printers installed
$OfficePrinters = Get-Printer | Where-Object {$_.Name -match "\\wmefp01"}

if($OfficePrinters.count -gt 0) {
    echo ""
    foreach($Printer in $OfficePrinters){
        Write-Host $Printer.Name
    }
} else {
    echo ""
    Write-Host "No office printer installed on this system" -BackgroundColor Red
}

echo ""
$EdgeStartupPage = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\Recommended\RestoreOnStartupURLs" -Name "1"
if($EdgeStartupPage -match "https://wmeconsultants.sharepoint.com"){
    Write-Host "Edge startup page`t`t: $($EdgeStartupPage)"
} else {
    Write-Host "Edge startup page`t`t: $($EdgeStartupPage)" -BackgroundColor Red
}

$EdgeNewTabPage = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\Recommended" -Name "NewTabPageLocation"
if($EdgeNewTabPage -match "https://wmeconsultants.sharepoint.com"){
    Write-Host "Edge new tab page`t`t: $($EdgeNewTabPage)"
} else {
    Write-Host "Edge new tab page`t`t: $($EdgeNewTabPage)" -BackgroundColor Red
}

$EdgeHomepageLocation = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\Recommended" -Name "HomepageLocation"
if($EdgeHomepageLocation -match "https://wmeconsultants.sharepoint.com"){
    Write-Host "Edge homepage location`t`t: $($EdgeHomepageLocation)"
} else {
    Write-Host "Edge homepage location`t`t: $($EdgeHomepageLocation)" -BackgroundColor Red
}

echo ""
echo "----- SOFTWARES -----" 
echo ""

foreach($BasicApp in $BasicApps){
    if ($InstalledApps -match $BasicApp) {
        $found = $InstalledApps | Where-Object { $_.DisplayName -like "$($BasicApp)*" }
        
        Write-Host "$($BasicApp) installed...." -ForegroundColor DarkYellow

        #for($i = 0;$i -lt $Found.count; $i++){
        #    Write-Host "-- $($Found[$i].DisplayName)" -BackgroundColor DarkGreen
        #
        #}

        foreach($fou in $found) {
            Write-Host "-- $($fou.DisplayName)" -BackgroundColor DarkGreen
            if($fou.DisplayName -match "Sophos SSL VPN Client"){
                $SophosConfig = Get-ChildItem -Path "C:\Program Files (x86)\Sophos\Sophos SSL VPN Client\config" -Name
                echo ""
                if($SophosConfig.count -gt 0){
                    Write-Host "`t$($SophosConfig)" -BackgroundColor Blue
                } else {
                    Write-Host "`tNo SSL VPN config found." -BackgroundColor Red
                }
                
                echo ""
            }

            if($found.count -gt 1) { break }
        }

        Write-Host "--------------------------"
    } else {
        Write-Host "$($BasicApp) not installed" -BackgroundColor Red
        Write-Host "--------------------------"

    }
}

Read-Host -Prompt "Press Enter to exit"

