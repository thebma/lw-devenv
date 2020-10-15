# Lightweight Development Environment
This is a collection of scripts/tools aimed at frictionless development and deployment which seamlessly intergrate into FiveMs FX Server.

**NOTE (15 OCT 2020)**: This is still in early stages, assume everything is broken or missing.

## Prerequisites
- PowerShell
    > We depend on PowerShell to do most of the heavy lifting.  
    > These script were tested in a Windows environment, although you could use PowerShell Core on Linux. 
    > Feel free to make a PR to better support this.
- Visual Studio Code
    > Everything is revolved around Visual Studio code, any other code editor would need to be added manually (or make a pull request with support).
- .NET Core 2.0+
    > This is required to compile the CitizenFX.Templates.
    > I'm not sure about the version 2.0+ requirement, could work on older versions (depending how CitizenFX.Templates deals with it).

## Instructions
1) Clone this repository in a convient place.
2) Run commands from the root folder (see below which commands there are).

**NOTE** Do not run commands directly from the bin folder, some day we will not rely on absolute paths that break.

## Commands

You can run the following commands from the command line:

**bin/add** -- Adds a new resource into the development environment.  
**bin/remove** -- Removes a resource from the development environment.  
**bin/open** -- Open the project inside Visual Studio Code.

More commmands coming...

### About Lightweight
Lightweight is a collection of FiveM resources (or plugins) aimed at offering a rich feature set without touching the internals.
We aim at being a minimal, yet powerful layer between the RAGE engine and developers, delivering powerful interfaces which perform well in numerous use cases.
