#creates an AD computer account
#param($name,$user,$pass,$enable)
param($name,$enable=$true)

import-module activedirectory

#####################
#THIS IS THE OLD WAY#
#####################
#$secure = ConvertTo-SecureString $pass -asplaintext -force
#$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user,$secure

#####################
#READ PW FROM A FILE#
#####################
$password = get-content C:\web_AD\AD_Computer_Objects\cred.txt | convertto-securestring
#create the credential
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist testwebadd,$password

New-ADcomputer -Credential $cred -name $name -SamAccountName $name -Path "OU=WEB-ADD,OU=workstations,OU=TSS,OU=UITS,OU=UConn,DC=testgrove,DC=testad,DC=uconn,DC=edu" -Enabled $enable