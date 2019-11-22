param (
    [Parameter(Mandatory=$true)][string]$PluginsPath)


function Start-Sonarqube()
{
    try {

        $containerID =  $(docker ps -qf name=sonarqube)
        $runningID = docker ps -a -q --filter="name=my-sonarqube"

        if($containerID)
        {
            Write-Output "The  container sonarqube is already running with ID: $containerID";
        }
        elseif ($runningID) {
            docker start $runningID
        }
        else    {
            
            Write-Host "Pulling docker image"
            docker pull sonarqube
    
            Write-Host "Starting sonarqube"
            docker run --name my-sonarqube -p 9000:9000 -d sonarqube

            Write-Host "Adding plugins"
            Get-ChildItem $PluginsPath -Filter *.jar | ForEach-Object {
                docker cp  $_.FullName  vy-sonarqube:/opt/sonarqube/extensions/plugins      
            }

            Write-Host "Restart container"
            docker restart my-sonarqube
    
            $ie = New-Object -ComObject "InternetExplorer.Application"
            $ie.Navigate("http://localhost:9000")
            $ie.visible = $true
            $tag = $false
            $intents = 0
    
            while($tag -eq $false) {
                $ie.Refresh()
                Write-Host "Waiting 15 seconds for Sonarqube to load..."     
                start-sleep -milliseconds 15000
                $tag = $ie.document.body.outerHTML -Match "window.serverStatus = 'UP'"
                $intents = $intents + 1
                if($intents -gt 10)
                {
                    Throw "Timeout trying to bootup sonarqube container"
                }
            };
        }
    }
    catch {
        Throw "Error trying to bootup sonarqube container"
    }
}


function main()
{
    try {

        Start-Sonarqube
    }
    catch {
        Write-Error $_.Exception
    }
}

main

 