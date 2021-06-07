set Args=%*
set Args=%Args:"=\"%

@powershell -NoProfile -ExecutionPolicy Unrestricted "&([scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 7})-join\"`n\"))" '%Args%'
goto:eof

[void]([System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic"))
$path = [string]$args;

Add-type -AssemblyName System.Web
Add-Type -AssemblyName Microsoft.VisualBasic
$defaultPassword = [System.Web.Security.Membership]::GeneratePassword(20,3)

$privatekeypath=$env:QIICIPHER_GITHUB_PRIVATE_KEY
if([string]::IsNullOrEmpty($privatekeypath)) {
    $privatekeypath = [Microsoft.VisualBasic.Interaction]::InputBox('Enter the path of your primary private key of Github.', 'private key path')
}

$wslpath=wsl --exec wslpath -u $path
$filename=[System.IO.Path]::GetFileName($path)
$parentpath=Split-Path -Path $path
$wslppath=wsl --exec wslpath -u $parentpath
$inputpath= $wslppath + "/" + $filename
$cryptedpasswordpath= $wslppath + "/" + $filename + ".passwd.enc"
$passwordpath= $wslppath + "/" + $filename + ".passwd"
$outputpath= $wslppath + "/"


#Write-Host $wslppath
#Write-Host $githubId

$dearchivePath = $env:QIICIPHER_BIN + "dearchive"
$decPath = $env:QIICIPHER_BIN + "dec"

# Decrypt share key password
$decCmd=$decPath + " " + $privatekeypath + " " + $cryptedpasswordpath + " " + $passwordpath
Write-Host $decCmd
wsl bash -c $decCmd

# Dearchive
$dearchiveCmd=$dearchivePath + " " + $inputpath + " " + $outputpath + " " + $passwordpath
Write-Host $dearchiveCmd
wsl bash -c $dearchiveCmd

pause
