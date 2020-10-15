Param(
    [Parameter(Mandatory=$True)]
    [String]$ResourceName=""
)

#Check if we specified a name.
if(!$ResourceName) 
{
    Write-Output "No name specified, use the 'bin/open <name>' to specify a name."
    Exit
}
#Write-Error "You do not have a resource called lw-$ResourceName installed (in the root directory of lw-devenv)."
#Exit

$matchedDirectories = (Get-ChildItem lw-$ResourceName -Directory -Force).Count
$matchedDirectoriesNames = Get-ChildItem lw-$ResourceName -Directory -Force | Select-Object Name
$names = $matchedDirectoriesNames.Name
$namesJoined = Join-String $names -Seperator ', '
Write-Output $namesJoined

#We only matched one, so it must be the correct one.
if($matchedDirectories -gt 0) 
{
    $a = Resolve-Path lw-$ResourceName
    Start-Process -WindowStyle Hidden code $a
}
elseif($matchedDirectories -eq 0) 
{
    Write-Error "No resource found matching lw-$ResourceName"
}
