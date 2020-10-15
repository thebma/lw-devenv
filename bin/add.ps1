
Param(
    [String]$ResourceName = $(Read-Host -Prompt "What is the name of your resource?"),
    [String]$AuthorName=$(Read-Host -Prompt "Who is you? Consider using format such as Human <human@mail.com>")
)

$executionPath = Get-Location

#Don't allow it to run directly from the /bin folder.
if($executionPath -like "*lw-devenv*bin*")
{
    Write-Error "Please do not run scripts directly from the bin folder, use the root folder and execute using 'bin/<command>'"
    Exit;
}
elseif($executionPath -like "*bin*")
{
    Write-Warning "You're running it from some kind of bin folder, please note that runnign directly from bin can cause issues with relative paths."
}

#Check if we specified a name.
if(!$ResourceName) 
{
    Write-Output "No name specified, please provide a resource name when prompted."
    Exit
}

#Check if we have an Author.
if(!$AuthorName) 
{
    Write-Output "No author specified, author is now anonymous."
    $AuthorName = "Anonymous <anonymous@mail.com>"
}

#Check if we already have such a resource installed.
if(Test-Path projects/lw-$ResourceName) 
{
    Write-Error "You already have a resource called lw-$ResourceName, please remove the folder manually if you want to overwrite it."
    Exit
}

$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

Write-Output "Create resource files for lw-$ResourceName, this can take up to 30 seconds..."

#Initialize the cfx template stuff.
dotnet new -i CitizenFX.Templates | Out-Null

#Create resource folder structure.
New-Item projects/lw-$ResourceName -ItemType "directory" | Out-Null
Set-Location projects/lw-$ResourceName | Out-Null

#Apply the template we've installed.
dotnet new cfx-resource | Out-Null

Set-Location ../../

Write-Output "Writing entry for Visual Studio Code workspace..."

#Touch the "code-workspace" file if we don't have one already.
#Write entry into workspace json.
if(-not (Test-Path "projects/lw.code-workspace"))
{
    $defaultWorkspaceContent = @"
    {
        "folders": [

        ]
    }
"@

    Set-Content "projects/lw.code-workspace" -Value $defaultWorkspaceContent
    Write-Output "Created a new wworkspace file."
}

$cleanName = $ResourceName.substring(0,1).toupper()+$ResourceName.substring(1).tolower() 
$defaultWorkspaceEntry2 = @{ "name"=$cleanName; "path"="lw-$ResourceName" }
$workspaceObj = Get-Content projects/lw.code-workspace | ConvertFrom-Json
$workspaceObj.folders += $defaultWorkspaceEntry2
$newWorkspaceObj = $workspaceObj | ConvertTo-Json -Compress
Set-Content "projects/lw.code-workspace" -Value $newWorkspaceObj

Write-Output "Setting up the freshly created resource template..."

#Clean up the default CitizenFX templates.
Remove-Item projects/lw-$ResourceName/fxmanifest.lua         # Replace for our custom manifest.
Remove-Item projects/lw-$ResourceName/build.cmd              # Remove, we build from a general file.
Remove-Item projects/lw-$ResourceName/lw-$ResourceName.sln   # We don't use visual studio (luckily).
Remove-Item projects/lw-$ResourceName/README.md              # Reading? What is this? early 2000's?

#Write our own manifest.
$newManifest = Get-Content "templates/fxmanifest.lua" -Raw | Out-String
$newManifest = $newManifest -replace "~0", $cleanName
$newManifest = $newManifest -replace "~1", $AuthorName
Set-Content "projects/lw-$ResourceName/fxmanifest.lua" -Value $newManifest

#Wrap up and inform the user.
$timer.Stop()
$timerMS = [Math]::Round($timer.Elapsed.TotalSeconds, 2)
Write-Output "Generated a new resource called lw-$ResourceName in $timerMS seconds."


