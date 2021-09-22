# use docker_provider:  "ee", "ce", "master" or ""
$docker_provider = "ee"
$docker_version = "18.09.9"
if (Test-Path env:docker_provider) {
  $docker_provider = $env:docker_provider  
}
if (Test-Path env:docker_version) {
  $docker_version = $env:docker_version  
}

$ProgressPreference = 'SilentlyContinue'
if ($docker_provider -eq "ce") {
  $zip_url = $("https://download.docker.com/win/static/edge/x86_64/docker-{0}-ce.zip" -f $docker_version)
} elseif ($docker_provider -eq "master") {
  $docker_version = "master"
  $zip_url = "https://master.dockerproject.com/windows/x86_64/docker.zip"
}

if ($zip_url) {
  Set-ExecutionPolicy Bypass -scope Process
  New-Item -Type Directory -Path "$($env:ProgramFiles)\docker"
  Write-Output "Downloading docker $docker_version ..."
  wget -outfile $env:TEMP\docker.zip $zip_url
  Expand-Archive -Path $env:TEMP\docker.zip -DestinationPath $env:TEMP -Force
  copy $env:TEMP\docker\*.* $env:ProgramFiles\docker
  Remove-Item $env:TEMP\docker.zip
  Remove-Item -Recurse $env:TEMP\docker
  [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$($env:ProgramFiles)\docker", [EnvironmentVariableTarget]::Machine)
  $env:Path = $env:Path + ";$($env:ProgramFiles)\docker"
  Write-Output "Registering docker service ..."
  . dockerd --register-service
} else {
  Write-Output "Use get.mirantis.com/install.ps1 ..."
  iwr -useb https://get.mirantis.com/install.ps1 | iex
}

$ErrorActionPreference = 'Stop'
Write-Output "Starting docker ..."
Start-Service docker
