param($user)
$list = Get-ADPrincipalGroupMembership $user
foreach($group in $list)
{
	if($group.SamAccountName -eq "ALLOW_CREATION")
	{
		write-host "TRUE"
	}
}