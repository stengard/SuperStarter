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
    Param ([string]$t, [string]$m)
    Write-Host $t "     " -f yellow -nonewline; Write-Host $m "     " -f Cyan -nonewline; Write-Host "SKIPPING" -f Magenta
    Write-Host ""
}

function WriteDelimiter{
    Param ([string]$m)
    if($m){
        Write-host "-----------------------$m-----------------------"  -ForegroundColor Blue     
        Write-host "" 
    }
    else{
        Write-host "----------------------------------------------"  -ForegroundColor Blue     
        Write-host ""    
    }
    
}

function ConnectToVpn{
    Param([string]$n)
    WriteMessage -t "VPN" -m "Connecting to $n"
    try{
        rasdial $n
    }
    catch{
        WriteErrorMessage -m "Could not connect to. Please verify user credentials $n"
    }
}

function OpenFile{
    Param([string]$p)
    WriteDelimiter -m "AUTO FILE OPENER"
    if($p.length -gt 0){
        WriteMessage -t "FILE" -m "OPENING $p"
        try{
            ii $p
        }
        catch{
            WriteErrorMessage -m "Could not open $p"
        }
    }else{
        WriteSkippingMessage -t "FILE" -m "No file path has been provided in the config.js" 
    }
    WriteDelimiter

}

function OpenChrome{
    Param([string[]]$p)
    WriteDelimiter -m "AUTO CHROME STARTER"
    if($p.length -gt 0){
        try{
            WriteMessage -t "CHROME" -m "Trying to open following webpages: $p"
            start chrome "--new-window"
            start chrome $p
        }
        catch{
            WriteErrorMessage -m "Could not open chrome"
        }
        WriteMessage -t "CHROME" -m "Chrome has successfully started" 
    }else{
        WriteSkippingMessage -t "CHROME" -m "No webpages was specified in the config.js"   
    }
    WriteDelimiter

}

function StartApplications{
    Param([string[]]$p)
    WriteDelimiter -m "AUTO APP STARTER"
    if($p.length -gt 0){
        WriteMessage -t "AUTOSTART" -m "Starting applications $p"

        forEach($app in $p){
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
        WriteSkippingMessage -t "APP" -m "No applications has been provided in the config.js -b darkgreen"   
    }
    WriteDelimiter

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