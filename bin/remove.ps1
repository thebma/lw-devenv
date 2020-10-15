Param(
    [Parameter(Mandatory=$True)]
    [String]$ResourceName=""
)

#Check if we specified a name.
if(!$ResourceName) 
{
    Write-Output "No name specified, use the 'bin/remove <name>' to specify a name."
    Exit
}

#Check if we already have such a resource installed.
if(-not (Test-Path lw-$ResourceName))
{
    Write-Error "You do not have a resource called lw-$ResourceName installed (in the root directory of lw-devenv)."
    Exit
}

Write-Host "Are you sure you want to remove the resource lw-$ResourceName Y/N: " -ForegroundColor RED; 
$confirm = Read-Host

if($confirm -eq "y" -or $confirm -eq "yes")
{
    Remove-Item lw-$ResourceName -Force -Recurse
    Write-Output "Removed resource lw-$ResourceName from development environment."
}
else 
{
    Write-Output "Aborted removal."
}