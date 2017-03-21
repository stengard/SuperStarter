clear
Remove-Module *

# Import stuff 
Import-Module ./Modules/Tools

WriteHeader

$global:BaseConfig = "./config.json"
$activeProject = "";

try {
	$global:Config = Get-Content "$BaseDirectory$BaseConfig" -Raw -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue | ConvertFrom-Json -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
} catch {
	WriteErrorMessage "The Base configuration file is missing!"
}

# Check the configuration
if (!($Config)) {
	WriteErrorMessage "The Base configuration file is missing!"
}


#MENU
write-host "Choose the project you want to initialize" -ForegroundColor Blue
Write-host "-----------------------------------------------" -ForegroundColor Blue 
write-host ""
$index = 0
forEach($project in $Config.projects){
    WriteMessage -t $index -m $project.project._name
    $index++
}

while($selectedIndex -ge $Config.projects.length -or (-not $selectedIndex)){
    $selectedIndex = Read-Host -Prompt 'Please Select with project you want to start'
      
    if($selectedIndex -ge $Config.projects.length){
        WriteErrorMessage "Please select a valid number"
    }
}

try{
    $activeProject = $Config.projects[$selectedIndex].project
    WriteDelimiter -m $activeProject._name
    Write-Host "STARTING PROJECT " $activeProject._name -b DarkGreen -f white;
    Write-host     
    WriteDelimiter


}
catch{
    WriteErrorMessage -m "Error when starting script"
}

if($activeProject._useVpn){
    ConnectToVpn -n $activeProject._settings._vpnName
}
OpenFile -p $activeProject._settings._path
OpenChrome -p $activeProject._settings._webPages
StartApplications -p $activeProject._settings._autoStartPrograms

