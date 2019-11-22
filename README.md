# sonarqube-local-testing

These repository contains some tools for local testing sonarqube with custom roslyn plugins

- **Start-SonarqubeLocal.ps1** : 
  - Gets latest official sonarqube docker image from public repository
  - Runs container 
  - Install plugins on /opt/sonarqube/extensions/plugins on running container
  - Reboots container
  - Waits until sonarqube is fully loaded and opens sonarqube webpage
  
- **Start-SonarScannerLocal.ps1**:
  - Install dotnet sonarscanner global tool
  - builds the project
  - Executes the sonar scanner
  - Report results to local sonarqube
  
- **SonarqubeWithPlugins.dockerfile**:
  - Dockerfile for creating a custom docker image that contains your custom Roslyn plugins
  
- **RoslynSonarQubePluginGenerator.rar**:
  - Latest version of sonarqube-roslyn-sdk
  - Already compiled and ready to use
  - More info about the project here: https://github.com/SonarSource/sonarqube-roslyn-sdk

