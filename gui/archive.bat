set Args=%*
set Args=%Args:"=\"%

@powershell -NoProfile -ExecutionPolicy Unrestricted "&([scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 7})-join\"`n\"))" '%Args%'
goto:eof

[void]([System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic"))
$path = [string]$args;

Add-type -AssemblyName System.Web
Add-Type -AssemblyName Microsoft.VisualBasic
$defaultPassword = [System.Web.Security.Membership]::GeneratePassword(20,3)
$githubId = [Microsoft.VisualBasic.Interaction]::InputBox('Enter the Github userid who you want to send a file', 'Github user id')

$wslpath=wsl --exec wslpath -u $path
$filename=[System.IO.Path]::GetFileName($path)
$parentpath=Split-Path -Path $path
$wslppath=wsl --exec wslpath -u $parentpath
$passwordpath= $parentpath + "/" + $filename + "-archive/" + $filename + ".tar.gz.aes.passwd"
$wslpasspath=wsl --exec wslpath -u $passwordpath


#Write-Host $wslppath
#Write-Host $githubId
#Write-Host $wslpasspath

$encPath = $env:QIICIPHER_BIN + "enc"
$archivePath = $env:QIICIPHER_BIN + "archive"


# Archive
$archiveCmd="cd "+ $wslppath + " & " + $archivePath + " " + $filename
#Write-Host $archiveCmd
wsl bash -c $archiveCmd


# Encrypt shared key password
$encCmd=$encPath + " " + $githubId + " " + $wslpasspath
#Write-Host $encCmd
wsl bash -c $encCmd
Remove-Item -Path $passwordpath

pause
