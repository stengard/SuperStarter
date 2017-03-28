clear
Remove-Module *

# Import stuff
Import-Module ./Modules/Tools
Import-Module ./Modules/CreateVirtualDesktopInWin10
  
if(!(Get-Module -Name WebAdministration)){
    WriteErrorMessage -m "Could not find Module WebAdministration"
    WriteMessage -t "INSTALL" -m "Trying to install WebAdministration"
    WriteSkippingMessage -t "INSTALL" -m "If it fails. install manually" 
    Enable-WindowsOptionalFeature -online -FeatureName IIS-WebServerManagementTools
    Enable-WindowsOptionalFeature -online -FeatureName IIS-ManagementScriptingTools
    Enable-WindowsOptionalFeature -online -FeatureName IIS-ManagementService
    Import-Module WebAdministration;    
}else{
    Import-Module WebAdministration;
}

if($selectedIndex){
    Clear-Variable -name selectedIndex
}
if($option){
            Clear-Variable -name option
}
if($openNewWindow){
    Clear-Variable -name openNewWindow
}

WriteHeader

$isAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")              
if($isAdmin -eq "True"){
    WriteMessage -t "ADMIN" -m  $isAdmin
}else{
    WriteErrorMessage -m "You will need to run powershell as admin for some features"
}

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

while($option -ne "q"){
    WriteMessage -t 0 -m "EVERYTHING!!!!!! :D"
    WriteMessage -t 1 -m "Start vpn"
    WriteMessage -t 2 -m "Change iis settings"
    WriteMessage -t 3 -m "Start applications"
    WriteMessage -t 4 -m "Open web pages"
    WriteMessage -t 5 -m "Change project"
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
        if($option -eq "5"){
            clear
            .\SuperStarter.ps1
        }
        if($option -eq "1"){
            ConnectToVpn -vpnName $activeProject._settings._vpnName
        }
        if($option -eq "3"){
            #Start applications
            if($activeProject.__startAsAdmin){
                StartApplicationsAsAdministrator -applications $activeProject._settings._autoStartProgramsAsAdministrator
            }else{
                StartApplications -applications $activeProject._settings._autoStartPrograms
            }
        }
        if ($option -eq "2"){
                WriteMessage -t 0 -m "Perform IIS-reset"
                WriteMessage -t 1 -m "Change Physical path"

                $subOption = Read-Host -Prompt 'Select option'
                
                if($subOption -eq 0){
                    PerformIISReset
                } 
                if($subOption -eq 1){
                    $isAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")              
                    if($isAdmin -eq "True"){
                        for($i=0; $i -lt $activeProject._settings._iisPhysicalPath.length; $i++){
                            WriteMessage -t $i -m $activeProject._settings._iisPhysicalPath[$i]
                        }

                        $p = Read-Host -Prompt 'Select path'
                        
                        ChangeIISsitePhysicalPath -iisPhysicalPath $activeProject._settings._iisPhysicalPath[$p] -siteName $activeProject._settings._iisSiteName
                    
                        $continue = Read-Host -Prompt 'Press any key to continue'
                        clear
                        .\SuperStarter.ps1
                    }else{        
                        WriteErrorMessage -t "ADMIN" -m  "You need to start powershell as administrator to use this feature"
                        $continue = Read-Host -Prompt 'Press any key to continue'
                        clear
                        .\SuperStarter.ps1      
                    }

                }             
        }
        if($option -eq "4"){
            #Open web pages in chrome
            OpenChrome -webPages $activeProject._settings._webPages -useNewWindow $activeProject._useNewChromeWindow
        }
        if($option -eq "0"){

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
