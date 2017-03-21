clear
Remove-Module *

# Import stuff 
Import-Module ./Modules/Tools
Import-Module ./Modules/CreateVirtualDesktopInWin10

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
    }else{
        clear
        WriteHeader
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


WriteMessage -t n -m "NO"
WriteMessage -t y -m "YES"

while($openNewWindow -ne "y" -And $openNewWindow -ne "n"){
    $openNewWindow = Read-Host -Prompt 'Open in virtual window?'

	if($openNewWindow -ne "y" -And $openNewWindow -ne "n"){
		WriteErrorMessage "Please select Y for Yes and N for No"
	}else{
        clear
        WriteHeader
    }
}



while($option -ne "q"){
    WriteMessage -t e -m "EVERYTHING!!!!!! :D"
    WriteMessage -t v -m "Start vpn"
    WriteMessage -t a -m "Start applications"
    WriteMessage -t c -m "Open web pages"
    WriteMessage -t s -m "Change project"
    WriteMessage -t q -m "quit"

    $option = Read-Host -Prompt 'What do you want to do?'

	if($option){
		WriteErrorMessage "Select on option you want to perform for the selected project"
        clear
        WriteHeader
        if($option -eq "q"){
            clear
            break
            exit
        }
        if($option -eq "s"){
            clear
            Clear-Variable -name selectedIndex 
            Clear-Variable -name option 
            Clear-Variable -name openNewWindow 
            .\SuperStarter.ps1
        }
        if($openNewWindow -eq "y" -and $option -eq "e"){
	        CreateVirtualDesktop
        }
        if($option -eq "v"){
            ConnectToVpn -vpnName $activeProject._settings._vpnName
        }
        if($option -eq "a"){
            #Start applications
            if($activeProject.__startAsAdmin){
                StartApplicationsAsAdministrator -applications $activeProject._settings._autoStartProgramsAsAdministrator
            }else{
                StartApplications -applications $activeProject._settings._autoStartPrograms
            }
        }
        if($option -eq "c"){
            #Open web pages in chrome
            OpenChrome -webPages $activeProject._settings._webPages -useNewWindow $activeProject._useNewChromeWindow    
        }
        if($option -eq "e"){
	        CreateVirtualDesktop
            #Start VPN
            ConnectToVpn -vpnName $activeProject._settings._vpnName
            #Open web pages in chrome
            OpenChrome -webPages $activeProject._settings._webPages -useNewWindow $activeProject._useNewChromeWindow         
            #Start applications
            if($activeProject.__startAsAdmin){
                StartApplicationsAsAdministrator -applications $activeProject._settings._autoStartProgramsAsAdministrator
            }else{
                StartApplications -applications $activeProject._settings._autoStartPrograms
            }
        }

    }
}









