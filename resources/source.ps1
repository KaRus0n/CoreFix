[System.Reflection.Assembly]::LoadFrom("assembly\System.Windows.Forms.dll")    			| out-null
[System.Reflection.Assembly]::LoadFrom("assembly\PresentationFramework.dll")    		| out-null  
[System.Reflection.Assembly]::LoadFrom("assembly\MahApps.Metro.dll")       				| out-null
[System.Reflection.Assembly]::LoadFrom("assembly\MahApps.Metro.IconPacks.dll")     		| out-null  
[System.Reflection.Assembly]::LoadFrom("assembly\ControlzEx.dll")      					| out-null  
[System.Reflection.Assembly]::LoadFrom("assembly\Microsoft.Xaml.Behaviors.dll")    		| out-null  

function LoadXml ($global:filename) {
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader 
}	

$Current_Folder = (get-location).path
$XamlMainWindow=LoadXml("$Current_Folder\main.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

if ((get-process corefix).count -ne 1) { stop-process $pid }

 ########################### Theme Manager Part 1 #################################### 
 
$Choose_Theme = $Form.Findname("Choose_Theme")
$Choose_Accent = $Form.Findname("Choose_Accent")
$Theme_Light = $Form.Findname("Theme_Light")
$Theme_Dark = $Form.Findname("Theme_Dark")
$Theme_Custom = $Form.Findname("Theme_Custom")
$Image_Custom = $Form.Findname("Image_Custom")

 ############################# Form & Tray ########################################
 
[System.Windows.Forms.Application]::EnableVisualStyles()

$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Text = "CoreFix"
$icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$Current_Folder\resources\icon.ico")
$notify.Icon = $icon
$notify.Visible = $true

$contextmenu = New-Object System.Windows.Forms.ContextMenuStrip

$Menu_Happy = $contextmenu.Items.Add("Be happy!")
$Menu_Happy.BackColor = "white"
$Menu_Happy.Image = [System.Drawing.Bitmap]::FromFile("$Current_Folder\resources\happy.png")

$Menu_Settings = $contextmenu.Items.Add("Settings")
$Menu_Settings.BackColor = "white"
$Menu_Settings.Image = [System.Drawing.Bitmap]::FromFile("$Current_Folder\resources\settings.png")

$Menu_Activity = $contextmenu.Items.Add("Not activated")
$Menu_Activity.BackColor = "white"
$Menu_Activity.ForeColor = "red"
$Menu_Activity.Image = [System.Drawing.Bitmap]::FromFile("$Current_Folder\resources\red.png")

$Menu_About = $contextmenu.Items.Add("About")
$Menu_About.BackColor = "white"
$Menu_About.Image = [System.Drawing.Bitmap]::FromFile("$Current_Folder\resources\about.png")

$Menu_Exit = $contextmenu.Items.Add("Exit")
$Menu_Exit.BackColor = "white"
$Menu_Exit.Image = [System.Drawing.Bitmap]::FromFile("$Current_Folder\resources\exit.png")

$notify.ContextMenuStrip = $contextmenu
 
$Settings = $Form.Findname("Settings")
$About = $Form.Findname("About")

$bt_youtube = $Form.Findname("bt_youtube")
$bt_telegram = $Form.Findname("bt_telegram")
$bt_vk = $Form.Findname("bt_vk")
$bt_discord = $Form.Findname("bt_discord")

$bt_youtube.Add_Click({Start-Process "https://www.youtube.com/channel/UCvS-7IZnotjeFsvOaTmmCAg"})
$bt_telegram.Add_Click({Start-Process "https://t.me/C0RE2quad"})
$bt_vk.Add_Click({Start-Process "https://vk.com/karus0n"})
$bt_discord.Add_Click({Start-Process "https://discordapp.com/users/412980274935103508/"})

$Menu_Happy.Add_Click({
	$notify.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
	$notify.BalloonTipTitle = "Be happy!"
	$notify.BalloonTipText = 'You will succeed and you will have a wonderful day. I believe in you! :3'
	$notify.ShowBalloonTip(10000)
	
})

$Menu_Settings.Add_Click({
	try {
		$global:ret = {
			$Settings.IsSelected = $true
			$global:timer1.stop() }
		$global:timer1 = New-Object System.Windows.Forms.Timer
		$global:timer1.Interval = 500
		$global:timer1.add_tick({ &$ret })
		$global:timer1.start()	
		$Form.ShowDialog()
	} catch { 
		if ($Settings.IsSelected -ne $true) {
			$Settings.IsSelected = $true
		} else { 
			$Theme = [ControlzEx.Theming.ThemeManager]::Current.DetectTheme($form)
			$my_theme_scheme = ($Theme.ColorScheme)	
			$configFile.configuration.theme.colorscheme.value = $my_theme_scheme	
			if ($Theme_Light.isselected -eq $true) {
				$configFile.configuration.theme.basecolor.value = "Light"
			} elseif ($Theme_Dark.isselected -eq $true) {
				$configFile.configuration.theme.basecolor.value = "Dark"	
			} elseif ($Theme_Custom.isselected -eq $true) {
				$configFile.configuration.theme.basecolor.value = "Custom"	}
			$configFile.Save("$Current_Folder\Config.xml")					
			$Form.Hide() 
		}
	}
})

$Menu_About.Add_Click({
	try {
		$global:ret = {
			$About.IsSelected = $true
			$global:timer1.stop() }		
		$global:timer1 = New-Object System.Windows.Forms.Timer
		$global:timer1.Interval = 500
		$global:timer1.add_tick({ &$ret })
		$global:timer1.start()	
		$Form.ShowDialog()
	} catch { 
		if ($About.IsSelected -ne $true) {
			$About.IsSelected = $true
		} else { 
			$Theme = [ControlzEx.Theming.ThemeManager]::Current.DetectTheme($form)
			$my_theme_scheme = ($Theme.ColorScheme)	
			$configFile.configuration.theme.colorscheme.value = $my_theme_scheme	
			if ($Theme_Light.isselected -eq $true) {
				$configFile.configuration.theme.basecolor.value = "Light"
			} elseif ($Theme_Dark.isselected -eq $true) {
				$configFile.configuration.theme.basecolor.value = "Dark"	
			} elseif ($Theme_Custom.isselected -eq $true) {
				$configFile.configuration.theme.basecolor.value = "Custom"	}
			$configFile.Save("$Current_Folder\Config.xml")	
			$Form.Hide()
		}	
	}
})

$notify.add_DoubleClick({
	try { 
		$Form.ShowDialog() 
	} catch {
		$Theme = [ControlzEx.Theming.ThemeManager]::Current.DetectTheme($form)
		$my_theme_scheme = ($Theme.ColorScheme)	
		$configFile.configuration.theme.colorscheme.value = $my_theme_scheme
		if ($Theme_Light.isselected -eq $true) {
			$configFile.configuration.theme.basecolor.value = "Light"
		} elseif ($Theme_Dark.isselected -eq $true) {
			$configFile.configuration.theme.basecolor.value = "Dark"	
		} elseif ($Theme_Custom.isselected -eq $true) {
			$configFile.configuration.theme.basecolor.value = "Custom"	}
		$configFile.Save("$Current_Folder\Config.xml")	 
		$Form.Hide() 
	}
})

$Form.Add_Closing({
	$_.Cancel = $true
	$Theme = [ControlzEx.Theming.ThemeManager]::Current.DetectTheme($form)
	$my_theme_scheme = ($Theme.ColorScheme)	
	$configFile.configuration.theme.colorscheme.value = $my_theme_scheme	
	if ($Theme_Light.isselected -eq $true) {
		$configFile.configuration.theme.basecolor.value = "Light"
	} elseif ($Theme_Dark.isselected -eq $true) {
		$configFile.configuration.theme.basecolor.value = "Dark"	
	} elseif ($Theme_Custom.isselected -eq $true) {
		$configFile.configuration.theme.basecolor.value = "Custom"	}
	$configFile.Save("$Current_Folder\Config.xml")	
    $Form.Hide() 
})

$Menu_Exit.add_Click({ 
	$Theme = [ControlzEx.Theming.ThemeManager]::Current.DetectTheme($form)
	$my_theme_scheme = ($Theme.ColorScheme)	
	$configFile.configuration.theme.colorscheme.value = $my_theme_scheme	
	if ($Theme_Light.isselected -eq $true) {
		$configFile.configuration.theme.basecolor.value = "Light"
	} elseif ($Theme_Dark.isselected -eq $true) {
		$configFile.configuration.theme.basecolor.value = "Dark"	
	} elseif ($Theme_Custom.isselected -eq $true) {
		$configFile.configuration.theme.basecolor.value = "Custom"	}
	$configFile.Save("$Current_Folder\Config.xml")	
	$notify.Visible = $false
	stop-process $pid 
})

 ########################## SetAffinity & Settings #####################################
 
if (Test-Path $Current_Folder\Config.xml) { 
	[xml]$configFile = get-content $Current_Folder\Config.xml 
} else {
	$notify.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Error
	$notify.BalloonTipTitle = "Error!"
	$notify.BalloonTipText = 'Check for "Configfig.xml" file'
	$notify.ShowBalloonTip(10000)
	$notify.Visible = $false
	stop-process $pid
}

$nameset = {
	$global:name = $configFile.configuration.name.value
} ; &$nameset

$conversion = {
	if ([long]$configFile.configuration.threads.value -le 63) {	
		$convert = [System.Collections.ArrayList]@()
		for ($i = 1; $i -le [long]$configFile.configuration.threads.value; $i++) {$convert.Add("1")}
		$convert = $convert -join $separator
		$global:num =[convert]::ToInt64("$convert",2)
	} elseif ([double]$configFile.configuration.threads.value -ge "1.844674407371E+19") {	
		$global:num = [double]$configFile.configuration.threads.value
	} else {	
		$global:num = "Error 404"	
		$configFile.configuration.threads.value = "Error 404"
		$configFile.Save("$Current_Folder\Config.xml")
		[xml]$configFile = get-content $Current_Folder\Config.xml	
		$global:num = $configFile.configuration.threads.value
	}
} ; &$conversion | out-null

$timer = New-Object System.Windows.Forms.Timer
$timeset = {
	$global:time = [int]$configFile.configuration.time.value * 1000
	$timer.Interval = $time
} ; &$timeset
$timer.add_tick({ open })
$timer.start()

$process_name_txt = $Form.Findname("process_name_txt")
$threads_value_txt = $Form.Findname("threads_value_txt")
$time_value_txt = $Form.Findname("time_value_txt")
$activity = $Form.Findname("activity")

$activity.content = "Not activated"
$activity.foreground = "#808080"

$process_name_txt.content = $name
$threads_value_txt.content = $configFile.configuration.threads.value
$time_value_txt.content = $time

function open {
	if (Get-Process $name) {
		$process = Get-Process $name		
		if ($process.ProcessorAffinity -ne $num) {
			try {
				$process.ProcessorAffinity = $num
			} catch { }	
			if ($process.ProcessorAffinity -ne $num) {
				$notify.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Error
				$notify.BalloonTipTitle = "Set threads error! Changes cannot be applied!"
				$notify.BalloonTipText = 'Please change the values in the "config.xml" file'
				$notify.ShowBalloonTip(10000)
				if ($Menu_Activity.Text -ne "Not activated" ) {
					$activity.content = "Not activated"
					$activity.foreground = "#808080"				
					$Menu_Activity.Text = "Not activated" 
					$Menu_Activity.ForeColor = "red"
					$Menu_Activity.Image = [System.Drawing.Bitmap]::FromFile("$Current_Folder\resources\red.png")
				}
			} else { 
				if ($Menu_Activity.Text -ne "Activated") {
					$activity.content = "   Activated"
					$activity.foreground = "#9ACD32"				
					$Menu_Activity.Text = "Activated" 
					$Menu_Activity.ForeColor = "Green"
					$Menu_Activity.Image = [System.Drawing.Bitmap]::FromFile("$Current_Folder\resources\green.png")
				}
			}	
		} else {
			if ($Menu_Activity.Text -ne "Activated") {
				$activity.content = "   Activated"
				$activity.foreground = "#9ACD32"		
				$Menu_Activity.Text = "Activated" 
				$Menu_Activity.ForeColor = "Green"
				$Menu_Activity.Image = [System.Drawing.Bitmap]::FromFile("$Current_Folder\resources\green.png")
			}
		}
	} else {
		if ($Menu_Activity.Text -ne "Not activated" ) {
			$activity.content = "Not activated"
			$activity.foreground = "#808080"		
			$Menu_Activity.Text = "Not activated" 
			$Menu_Activity.ForeColor = "red"
			$Menu_Activity.Image = [System.Drawing.Bitmap]::FromFile("$Current_Folder\resources\red.png")
		}
	}
}

$process_name = $Form.Findname("process_name")
$threads_value = $Form.Findname("threads_value")
$time_value = $Form.Findname("time_value")
$BTsettingsDone = $Form.Findname("BTsettingsDone")

$threads_value.Add_DropDownClosed({
	if ($threads_value.text -ne "") {
		if ([int]$threads_value.text -eq 0) {
			$threads_value.text = ""
		}
	}
})

$BTsettingsDone.Add_Click({
	[xml]$configFile = get-content $Current_Folder\Config.xml	
	if ($process_name.text -ne "") {
		$configFile.configuration.name.value = ($process_name.text).trim()
		$configFile.Save("$Current_Folder\Config.xml")
		[xml]$configFile = get-content $Current_Folder\Config.xml	
		&$nameset
		$process_name.text = ""
	}
	if ($threads_value.text -ne "") {
		if ([int]$threads_value.text -eq 0) {
			$threads_value.text = ""
		} else {
			if ([int]$threads_value.text -le 63) {
				if ([Int32]::TryParse([string]$threads_value.text,[ref]([Int32]$null))){ 
					$configFile.configuration.threads.value = $threads_value.text
					$configFile.Save("$Current_Folder\Config.xml")
					[xml]$configFile = get-content $Current_Folder\Config.xml				
					&$conversion
					$threads_value.text = ""
				}
			}
		}
	}
	if ($time_value.text -ne "") {
		if ([Int32]::TryParse([string]$time_value.text,[ref]([Int32]$null))){
			$configFile.configuration.time.value = ($time_value.text).trim()
			$configFile.Save("$Current_Folder\Config.xml")
			[xml]$configFile = get-content $Current_Folder\Config.xml		
			&$timeset
			$time_value.text = ""
		}
	}
	$process_name_txt.content = $name
	$threads_value_txt.content = $configFile.configuration.threads.value
	$time_value_txt.content = $configFile.configuration.time.value
})


$process = get-process -id $pid
$max_threads = $process.ProcessorAffinity
$max_threads = [convert]::ToString("$max_threads",2)
$max_threads = ($max_threads.ToCharArray()).Count

while ($i -ne $max_threads) {
	$i++
	$threads_value.Items.Add($i) | out-null
}

$process_name_txt.content = $name
$threads_value_txt.content = $configFile.configuration.threads.value
$time_value_txt.content = $configFile.configuration.time.value

 ########################### Theme Manager Part 2 ####################################

$Choose_Theme.Add_DropDownClosed({
	$Theme = [ControlzEx.Theming.ThemeManager]::Current.DetectTheme($form)
	$my_theme = ($Theme.BaseColorScheme)
	if ($Theme_Dark.isselected -eq $true) { 
		[ControlzEx.Theming.ThemeManager]::Current.ChangeThemeBaseColor($form,"Dark") 
		$Image_Custom.ImageSource = $null
	} elseif ($Theme_Light.isselected -eq $true) {		
		[ControlzEx.Theming.ThemeManager]::Current.ChangeThemeBaseColor($form,"Light")
		$Image_Custom.ImageSource = $null		
	} elseif ($Theme_Custom.isselected -eq $true) {
		[ControlzEx.Theming.ThemeManager]::Current.ChangeThemeBaseColor($form,"Dark")
		$formatlist = @("png", "jpg", "jpeg")
		foreach ($format in $formatlist) {
			if (Test-Path "$Current_Folder\resources\background.$format"){
				$Image_Custom.ImageSource = "$Current_Folder\resources\background.$format"
				break
			} else { $Image_Custom.ImageSource = $null }
		}
	}
})

$Choose_Accent.Add_SelectionChanged({	
	$Theme = [ControlzEx.Theming.ThemeManager]::Current.DetectTheme($form)
	$my_theme = ($Theme.ColorScheme)
    $Value = $Choose_Accent.SelectedValue
    [ControlzEx.Theming.ThemeManager]::Current.ChangeThemeColorScheme($form ,$Value)
})	

$Colors=@()
$Accent = [ControlzEx.Theming.ThemeManager]::Current.ColorSchemes
foreach($item in $Accent) { 
	$Choose_Accent.Items.Add($item)| Out-Null
}

if ($configFile.configuration.theme.colorscheme.value -ne "") {
	$Choose_Accent.SelectedValue = $configFile.configuration.theme.colorscheme.value
	[ControlzEx.Theming.ThemeManager]::Current.ChangeThemeColorScheme($form , $configFile.configuration.theme.colorscheme.value) | Out-Null 
}

$nep = {
	$random = ("Light", "Dark", "Custom" | Get-Random)
	$configFile.configuration.theme.basecolor.value = $random
	$configFile.Save("$Current_Folder\Config.xml")
	[xml]$configFile = get-content $Current_Folder\Config.xml 
	&$checktheme 
}

$checktheme = {
	if ($configFile.configuration.theme.basecolor.value -ne "") {
		if ($configFile.configuration.theme.basecolor.value -eq "Light") {
			[ControlzEx.Theming.ThemeManager]::Current.ChangeThemeBaseColor($form,"Light") | out-null
			$Image_Custom.ImageSource = $null
			$Theme_Light.IsSelected = $true 
		} elseif ($configFile.configuration.theme.basecolor.value -eq "Dark") {
			[ControlzEx.Theming.ThemeManager]::Current.ChangeThemeBaseColor($form,"Dark")  | out-null
			$Image_Custom.ImageSource = $null
			$Theme_Dark.IsSelected = $true	
		}  elseif ($configFile.configuration.theme.basecolor.value -eq "Custom") {
			[ControlzEx.Theming.ThemeManager]::Current.ChangeThemeBaseColor($form,"Dark")  | out-null
			$formatlist = @("png", "jpg", "jpeg")
			foreach ($format in $formatlist) {
				if (Test-Path "$Current_Folder\resources\background.$format") {
					$Image_Custom.ImageSource = "$Current_Folder\resources\background.$format"
					$format = $true
					break
				} else { $Image_Custom.ImageSource = $null }
			}
			$Theme_Custom.IsSelected = $true
		} else { &$nep }
	} else { &$nep }
} ; &$checktheme

 ######################################################################

$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)