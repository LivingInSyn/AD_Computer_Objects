#creates an AD computer account
param($name,$user,$pass,$enable)

import-module activedirectory
#echo $name
#echo $user
#echo $pass
$secure = ConvertTo-SecureString $pass -asplaintext -force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user,$secure
New-ADcomputer -Credential $cred -name $name -SamAccountName $name -Path "OU=WEB-ADD,OU=workstations,OU=TSS,OU=UITS,OU=UConn,DC=testgrove,DC=testad,DC=uconn,DC=edu" -Enabled $enable