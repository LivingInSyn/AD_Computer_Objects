#check the group membership and the password
param($user,$password)
import-module activedirectory

#first check group membership of the user
$list = Get-ADPrincipalGroupMembership $user
$is_member = "FALSE"
foreach($group in $list)
{
	if($group.SamAccountName -eq "ALLOW_CREATION")
	{
		$is_member = "TRUE"
	}
	else
	{
		#write-host "FALSE"
	}
}

#now check the username and password if they're a member of the correct group
if($is_member -eq "TRUE")
{
	Add-Type -AssemblyName System.DirectoryServices.AccountManagement
	$DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('domain')
	$valid = $DS.ValidateCredentials($user, $password)
}

#combine the outputs to a single output to make our lives easier
if(($valid -eq $true) -and ($is_member -eq "TRUE"))
{
	write-host "TRUE"
}
else
{
	write-host "FALSE"
}