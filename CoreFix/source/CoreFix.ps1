Param([String]$Restart)

If ($Restart -ne "") {
		sleep 5
	}

 #Create file in ProramData
$ProgData = $env:PROGRAMDATA
$SystrayTool_Dest_Folder = "$ProgData\CoreFix"

$Current_Folder = (get-location).path 
$SystrayTool_Folder = "$Current_Folder"

 #Add to antivirus exclusions
Add-MpPreference -ExclusionPath "$Current_Folder"
Add-MpPreference -ExclusionPath "$ProgData\CoreFix"
 
 #Copy file in ProgramData
copy-item $SystrayTool_Folder $ProgData -force -recurse	
	
 #Add SYS forms
Add-Type -AssemblyName System.Windows.Forms

 #Notify create
$path = (Get-Process -id $pid).Path
$global:notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)

 #Add config file
$check_config = (Test-Path $Current_Folder\Config.xml)

if ($check_config -eq "True"){
	[xml]$configFile = get-content $Current_Folder\Config.xml
} else {
	 #Add notify error
	$notify.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Error
	$notify.BalloonTipTitle = "Error!"
	$notify.BalloonTipText = 'Check for "Configfig.xml" file'
	$notify.Visible = $true
	$notify.ShowBalloonTip(10000)
	$notify.Visible = $false
	
	 #stop process / exit
	stop-process $pid
}

 #Convert to decimal system CPU Threads. Data for converting operations from "Config.xlm"
if ([long]$configFile.configuration.appsettings.add[1].value -le 63) {
	 #Add notify
	$notify.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
	$notify.BalloonTipTitle = "Attention!"
	$notify.BalloonTipText = 'CoreFix v1.1 started'
	$notify.Visible = $true
	$notify.ShowBalloonTip(10000)
	$notify.Visible = $false
	 
	 #
	$ArrList = [System.Collections.ArrayList]@()
	for ($i = 1; $i -le [long]$configFile.configuration.appsettings.add[1].value; $i++) {$ArrList.Add("1")}
	$num = $ArrList -join $separator
	$num =[convert]::ToInt64("$num",2)
	} 
elseif ([double]$configFile.configuration.appsettings.add[1].value -ge "1.844674407371E+19") {
	 #Add notify
	$notify.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
	$notify.BalloonTipTitle = "Attention!"
	$notify.BalloonTipText = 'CoreFix v1.1 started'
	$notify.Visible = $true
	$notify.ShowBalloonTip(10000)
	$notify.Visible = $false
	 
	 timeout /t 30
	 #
	$num = [double]$configFile.configuration.appsettings.add[1].value
}
else {
	 #Add notify error
	$notify.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Error
	$notify.BalloonTipTitle = "Set threads error!"
	$notify.BalloonTipText = 'Set values up to 31 or from 1.844674407371E+19 in "config.xml" file'
	$notify.Visible = $true
	$notify.ShowBalloonTip(10000)
	$notify.Visible = $false
	 
	 #stop process / exit
	stop-process $pid
	
}

 #SYStrayTool start. If in "config.xml" is set to "True" then run
if ($configFile.configuration.appsettings.add[2].value -eq "True") {
	Start-Process "$Current_Folder\SystrayTool\SystrayTool.exe" }
	
 #Process name from "Config.xml"
$name = $configFile.configuration.appsettings.add[0].value
$process = Get-Process $name

 #We write the initially specified number of threads to the file "logs.txt"
Write-Output "CPU Threads decimal code:" > .\logs.txt
$process.ProcessorAffinity >> .\logs.txt

 #"Function"(haha) start
$start = {
	 #loop
	for() { clear
		 #Process detection
		if (Get-Process $name) {
			 #Write down the first PID if the process is detected / PID old - $pido
			$pido = (Get-Process $name).id
			timeout /t 10
			
			 #Apply threads value that is converted to decimal
			$process.ProcessorAffinity = $num
			
			 #Checking if the changes have been applied
			if ($process.ProcessorAffinity -eq $num) { } 
			else {
				 #Add notify error set
				$notify.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Error
				$notify.BalloonTipTitle = "Set threads error! Changes cannot be applied!"
				$notify.BalloonTipText = 'Please change the values in the "config.xml" file'
				$notify.Visible = $true
				$notify.ShowBalloonTip(10000)
				$notify.Visible = $false
			}
			
			 #Start function "close"
			&$close
		}
		else {
			 #The process is not visible. Waiting for the process to start
			Start-Sleep -Seconds $configFile.configuration.appsettings.add[3].value
		}
	}
}

 #"Function"(haha) close
$close = {
	 #loop
	for() { clear	
		 #Write down the second PID and compare with the first / PID new - $pidn
		$pidn = (Get-Process $name).id
		if ( $pido -eq $pidn ) {
			 #PIDs are the same and the process is not closed, waiting
			Start-Sleep -Seconds $configFile.configuration.appsettings.add[4].value
		}
		else {
			 #The process was closed and re-opened (or not), but the PIDs were not the same, so restarting
			Timeout /t 5
			 #Start function "start"
			&$start
		}
	}
}
	
 #Start	
&$start