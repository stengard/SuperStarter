function WriteErrorMessage {
    Param ([string]$m)
    Write-Host ""
    Write-Host "ERROR: " $m -BackgroundColor Red
    Write-Host ""
}

function WriteMessage {
    Param ([string]$t, [string]$m)
    Write-Host $t "     " -f yellow -nonewline; Write-Host $m -f green;
    Write-Host ""
}

function WriteSkippingMessage {
    Param ([string]$t, [string]$m, [string]$i)
    Write-Host $t "     " -f yellow -nonewline; Write-Host $m "     " -f Cyan -nonewline; Write-Host $i -f Magenta
    Write-Host ""
}

function WriteDelimiter{
    Param ([string]$m)
    if($m){
        Write-host "-----------------------$m-----------------------"  -ForegroundColor Blue
        Write-host ""
    }
    else{
        Write-host "---------------------------------------------------------"  -ForegroundColor Blue
        Write-host ""
    }

}

function ConnectToVpn{
    Param([string]$vpnName)
    WriteDelimiter -m "AUTO VPN"
    if($vpnName){
        WriteMessage -t "VPN" -m "Connecting to $vpnName"
        try{
            rasdial $vpnName
        }
        catch{
            WriteErrorMessage -m "Could not connect to. Please verify user credentials $vpnName"
        }
    }else{
        WriteSkippingMessage -t "VPN" -m "No vpn name was specified in the config.js" -i "SKIPPING"
    }
    WriteDelimiter
}

function OpenChrome{
    Param([string[]]$webPages, [boolean]$useNewWindow)

    WriteDelimiter -m "AUTO CHROME STARTER"
    if($webPages.length -gt 0){
        try{
            WriteMessage -t "CHROME" -m "Trying to open following webpages: $webPages"
            if($useNewWindow){
                sleep 0.5
                start chrome "--new-window"
            }
            start chrome $webPages
        }
        catch{
            WriteErrorMessage -m "Could not open chrome"
        }
        WriteMessage -t "CHROME" -m "Chrome has successfully started"
    }else{
        WriteSkippingMessage -t "CHROME" -m "No webpages was specified in the config.js" -i "SKIPPING"
    }
    WriteDelimiter

}

function StartApplications{
    Param([string[]]$applications)
    WriteDelimiter -m "AUTO APP STARTER"
    if($applications.length -gt 0){
		sleep 0.5
        WriteMessage -t "AUTOSTART" -m "Starting applications $applications"
        forEach($app in $applications){
            WriteMessage -t "Starting" -m "$app"
            #kolla om den körs innan
            try{
                ii $app
            }
            catch{
                WriteErrorMessage -m "Could not open $app"
            }
            WriteMessage -t "APP" "Sucessfully started $app"
        }
    }else{
        WriteSkippingMessage -t "APP" -m "No applications has been provided in the config.js" -i "SKIPPING"
    }
    WriteDelimiter
}

function StartApplicationsAsAdministrator{
    Param([string]$applications)
    WriteDelimiter -m "AUTO APP STARTER ADMIN"
	if($applications){
	 WriteMessage -t "AUTOSTART AS ADMINISTRATOR" -m "OPENING $applications"
	 forEach($app in $applications){
			WriteMessage -t "Starting " -m "$app"
            sleep 0.5
			#kolla om den körs innan
			try{
				ii $app
			}
			catch{
				WriteErrorMessage -m "Could not open $app"
			}
		}
	}else{
        WriteSkippingMessage -t "AUTOSTART" -m "No applications has been provided in the config.js" -i "SKIPPING"

    }
    WriteDelimiter
}

function CreateVirtualDesktop
{
    WriteDelimiter -m "AUTO APP STARTER ADMIN"
    WriteMessage -t "DESKTOP" -m "OPENING New virtual window"
    try{
        CreateVirtualDesktopInWin10
        sleep 1.5

    }catch{
        WriteErrorMessage -m "Could not open new virtual window start"
        WriteErrorMessage $_.Exception.Message
        exit
    }
    WriteDelimiter
}


function PerformIISReset{
      WriteDelimiter -m "IIS SETTINGS"    
      WriteMessage -t "IIS" -m "Performing IISReset"
      WriteDelimiter
    try{
        iisreset 
        WriteDelimiter           
        WriteMessage -t "IIS Reset" -m "Done"
        $d = Read-Host -Prompt 'Press any key to continue'
        clear
        .\SuperStarter.ps1

    }
    catch{
        WriteErrorMessage -m "Could not perform IISReset"
        WriteErrorMessage $_.Exception.Message
    }
}

function ChangeIISsitePhysicalPath{
    Param([string]$iisPhysicalPath, [string]$siteName)
      WriteDelimiter -m "IIS SETTINGS"
      if($iisPhysicalPath){
        try{
            WriteMessage -t "IIS" -m "Changing physical path for $siteName" 
            $site = Get-Item "IIS:\sites\$siteName"
            if(!$site){
                WriteErrorMessage -m "Could not get site $siteName"
                $continue = Read-Host -Prompt 'Press any key to start over'
                clear
                .\SuperStarter.ps1    
            }
            
            Set-ItemProperty "IIS:\sites\$siteName" -Name physicalPath -Value $iisPhysicalPath

            sleep 0.3
            WriteSkippingMessage -t "IIS" -m "The physical path to project $siteName is now changed to" -i $iisPhysicalPath
            WriteMessage -t "IIS" -m "Performing IISReset..."  
            iisreset
            WriteDelimiter                
        }catch{
            WriteErrorMessage -m "Could change the physical address for site $siteName"
            WriteErrorMessage $_.Exception.Message
        }
      }else{
        WriteSkippingMessage -t "IIS" -m "No iis settings has been provided in the config.js" -i "SKIPPING"
      }
}

function WriteHeader {
    write-host      ""
    write-host      "                            _                                         " -ForegroundColor Red
    write-host      "    /\         _           | |  _               _                      " -ForegroundColor Red
    write-host      "   /  \  _   _| |_  ___    \ \ | |_  ____  ____| |_  ____  ____        " -ForegroundColor Red
    write-host      "  / /\ \| | | |  _)/ _ \    \ \|  _)/ _  |/ ___)  _)/ _  )/ ___)       " -ForegroundColor Red
    write-host      " | |__| | |_| | |_| |_| |____) ) |_( ( | | |   | |_( (/ /| |           " -ForegroundColor Red
    write-host      " |______|\____|\___)___(______/ \___)_||_|_|    \___)____)_|           " -ForegroundColor Red
    write-host      ""
    write-host      ""
}
