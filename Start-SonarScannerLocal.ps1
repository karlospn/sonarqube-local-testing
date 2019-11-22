param (
    [Parameter(Mandatory=$true)][string]$Token,
    [Parameter(Mandatory=$true)][string]$ProjectKey,
    [Parameter(Mandatory=$true)][string]$ProjectName)

function Start-SonarScanner()
{

    if (-NOT (Test-Path 'env:JAVA_HOME')) { 
        Write-Error "The environment variable called JAVA_HOME does not exist. Make sure the JAVA SDK is installed and the environment variable has been set."
        exit
    }

    Write-Host "Make sure the dotnet sonarscanner tooling is installed"
    dotnet tool install --global dotnet-sonarscanner

    Write-Host "Start the scanner"
    dotnet sonarscanner begin /d:sonar.login=$Token /k:$ProjectKey

    Write-Host "Build the solution"
    dotnet build

    Write-Host "Stop the scanner"
    dotnet sonarscanner end /d:sonar.login=$Token

    Write-Host "Open the page in the browser"
    Start-Process http://localhost:9000/dashboard/index/$ProjectName

}

function main()
{
    try {
        Start-SonarScanner  
    }
    catch {
        Write-Error $_.Exception
    }
}

main

 