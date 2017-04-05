$configdir=$args[0]
$APIS=$args[1]
$APIK=$args[2]
$dldir=$args[3]
$cdsvr=$args[4]
$cdusr=$args[5]
$cdpw=$args[6]

$configfiles = Get-ChildItem $configdir\*.cdconfig -rec
foreach ($file in $configfiles)
{
  (get-content $file) |
  foreach-object {$_ -replace "IRSECRETREPLACEME", $APIS} |
  foreach-object {$_ -replace "IRKEYREPLACEME", $APIK} | 
  foreach-object {$_ -replace "IRCDDLDIRREPLACEME", $dldir} | 
  foreach-object {$_ -replace "IRCDSVRREPLACEME", $cdsvr} | 
  foreach-object {$_ -replace "IRCDSVRUSRREPLACEME", $cdusr} | 
  foreach-object {$_ -replace "IRCDSVRUSRPWREPLACEME", $cdpw} | 
  set-content $file
}