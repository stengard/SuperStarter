clear
Remove-Module *

# Import stuff 
Import-Module ./Modules/Tools

WriteHeader

$global:BaseConfig = "./configs/config.json"
$activeProject = "";

try {
	$global:Config = Get-Content "$BaseDirectory$BaseConfig" -Raw -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue | ConvertFrom-Json -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
} catch {
	WriteErrorMessage "The Base configuration file could not be read!"
	WriteErrorMessage $_.Exception.Message
    exit
}

# Check the configuration
if (!($Config)) {
	WriteErrorMessage "The Base configuration file is missing!"
	WriteErrorMessage "Aborting!"
    exit
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
    $selectedIndex = Read-Host -Prompt 'Start project'
      
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

#Start VPN
if($activeProject._useVpn){
    ConnectToVpn -vpnName $activeProject._settings._vpnName
}

#Open web pages in chrome
OpenChrome -webPages $activeProject._settings._webPages -useNewWindow $activeProject._useNewChromeWindow

#Start applications
if($activeProject.__startAsAdmin){
    StartApplicationsAsAdministrator -applications $activeProject._settings._autoStartProgramsAsAdministrator
}else{
    StartApplications -applications $activeProject._settings._autoStartPrograms
}

