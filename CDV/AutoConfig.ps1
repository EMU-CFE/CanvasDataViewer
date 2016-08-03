$configdir=$args[0]
$APIS=$args[1]
$APIK=$args[2]
$cdsvr=$args[3]
$cdusr=$args[4]
$cdpw=$args[5]

$configfiles = Get-ChildItem $configdir\*.cdconfig -rec
foreach ($file in $configfiles)
{
  (get-content $file) |
  foreach-object {$_ -replace "IRSECRETREPLACEME", $APIS} |
  foreach-object {$_ -replace "IRKEYREPLACEME", $APIK} | 
  foreach-object {$_ -replace "IRCDSVRREPLACEME", $cdsvr} | 
  foreach-object {$_ -replace "IRCDSVRUSRREPLACEME", $cdusr} | 
  foreach-object {$_ -replace "IRCDSVRUSRPWREPLACEME", $cdpw} | 
  set-content $file
}

New-Item -type directory -path C:\CanvasData
$Acl = Get-Acl "C:\CanvasData"
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("NT SERVICE\MSSQLSERVER","FullControl","Allow")
$Acl.SetAccessRule($Ar)
Set-Acl "C:\CanvasData" $Acl

New-Item -type directory -path C:\CanvasDataFiles
$Acl = Get-Acl "C:\CanvasDataFiles"
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("NT SERVICE\MSSQLSERVER","FullControl","Allow")
$Acl.SetAccessRule($Ar)
Set-Acl "C:\CanvasDataFiles" $Acl