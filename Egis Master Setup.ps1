
#Creating localadm local user.
Try{
    $SecurePassword = ConvertTo-SecureString "EGIS@2013" -AsPlainText -Force
    New-LocalUser -Name "localadm" -Password $SecurePassword -ErrorAction Stop -Verbose
    Add-LocalGroupMember -Group "Administrators" -Member "localadm" -Verbose
   
} Catch {
    Write-Host $_
}


#Creating egis.racine.local txt file.
Try {

    New-Item -Path "C:\Users\aa-sup\Desktop\egis.racine.local.txt" -ErrorAction Stop -Verbose
    Add-Content -Path "C:\Users\aa-sup\Desktop\egis.racine.local.txt" -Value "Domaine" -Verbose
} Catch {
    Write-Host $_
}

#Setting timezone to Arabian Standard Time
Set-TimeZone -Id "Arabian Standard Time" -Verbose



#Adding 192.168.192.4 FS01Az in hosts file
$HostsPath = "C:\Windows\System32\drivers\etc\hosts"
$HostsFileContent = Get-Content -Path $HostsPath
if($HostsFileContent -contains "192.168.192.4 FS01Az") {
    Write-Host "Hosts file already has 192.168.192.4 FS01Az."
} else {
    Add-Content -Path $HostsPath -Value "`n192.168.192.4 FS01Az" -Verbose
    Add-Content -Path $HostsPath -Value "`n192.168.192.5 wmedubai.local" -Verbose

}

#Adding wmefp01 credentials for installing printers.

cmdkey /add:"wmefp01" /user:"wmedubai\j.llave" /pass:"hopeful2609"

Add-Printer -ConnectionName "\\wmefp01\Main Office Black & White HP LaserJet flow MFP M830" -Verbose
Add-Printer -ConnectionName "\\wmefp01\Main Office Color-HP MFP M880" -Verbose
Add-Printer -ConnectionName "\\wmefp01\4Flr COLOR MFP M880" -Verbose
cmdkey /delete:wmefp01

#Install LENOVO VANTAGE

# $LenovoVantage = Get-AppxPackage -Name "*.LenovoCompanion"
# if($LenovoVantage) {
#     Write-Host "Lenovo Vantage is already installed."
# } else {
#     if(Test-Path -Path "E:\Egis Master\Lenovo Vanage offline installer\LenovoCompanion_10.2110.15.MsixBundle"){
#         Add-AppxPackage -Path "E:\Egis Master\Lenovo Vanage offline installer\LenovoCompanion_10.2110.15.MsixBundle" -Verbose
#     }

#     if(Test-Path -Path "F:\Egis Master\Lenovo Vanage offline installer\LenovoCompanion_10.2110.15.MsixBundle") {
#         Add-AppxPackage -Path "F:\Egis Master\Lenovo Vanage offline installer\LenovoCompanion_10.2110.15.MsixBundle" -Verbose
#     }

#     if(Test-Path -Path "G:\Egis Master\Lenovo Vanage offline installer\LenovoCompanion_10.2110.15.MsixBundle") {
#         Add-AppxPackage -Path "G:\Egis Master\Lenovo Vanage offline installer\LenovoCompanion_10.2110.15.MsixBundle" -Verbose
#     }
# }
#EDGE Startup
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\Recommended\RestoreOnStartupURLs" -Name "1" -Value "https://wmeconsultants.sharepoint.com" -Verbose
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\Recommended" -Name "NewTabPageLocation" -Value "https://wmeconsultants.sharepoint.com" -Verbose
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\Recommended" -Name "HomepageLocation" -Value "https://wmeconsultants.sharepoint.com" -Verbose

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "RegisteredOwner" -Value "EGIS SA" -Verbose
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "RegisteredOrganization" -Value "WME ENGINEERING CONSULTANTS" -Verbose



Read-Host -Prompt "Press Enter to exit"
