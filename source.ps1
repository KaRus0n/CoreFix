$Current_Folder = (get-location).path

regsvr32 /s $Current_Folder\assembly\System.Windows.Forms.dll
regsvr32 /s $Current_Folder\assembly\MahApps.Metro.dll
regsvr32 /s $Current_Folder\assembly\MahApps.Metro.IconPacks.dll
regsvr32 /s $Current_Folder\assembly\Microsoft.Xaml.Behaviors.dll
regsvr32 /s $Current_Folder\assembly\PresentationFramework.dll
regsvr32 /s $Current_Folder\assembly\System.Windows.Forms.dll

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

$XamlMainWindow=LoadXml("$Current_Folder\main.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

#if ((get-process corefix).count -gt 1) { stop-process $pid }

 ######################### Current version number #################################### 
 
$version = $Form.Findname("version")
$version.Content = "Current version: 2.03"

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

$Form.Add_KeyDown({
	if($_.Key -eq "ESC"){
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
 
 
$profile_name = $Form.Findname("profile_name")
$time_value = $Form.Findname("time_value")

$AddProfile = $Form.Findname("AddProfile")
$EditProfile = $Form.Findname("EditProfile")
$RemoveProfile = $Form.Findname("RemoveProfile")

$process_name_txt = $Form.Findname("process_name_txt")
$threads_value_txt = $Form.Findname("threads_value_txt")
$time_value_txt = $Form.Findname("time_value_txt")
$activity = $Form.Findname("activity")

$activity.content = "Not activated"
$activity.foreground = "#808080"

$process_name_txt.content = "asdsa"
$threads_value_txt.content = "12"
$time_value_txt.content = "213"

if (Test-Path $Current_Folder\Config.xml) { 
	[xml]$global:configFile = get-content $Current_Folder\Config.xml 
} else {
	$notify.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Error
	$notify.BalloonTipTitle = "Error!"
	$notify.BalloonTipText = 'Check for "Configfig.xml" file'
	$notify.ShowBalloonTip(10000)
	$notify.Visible = $false
	stop-process $pid
}

$num = New-Object System.Collections.Generic.List[System.Object]
function conversion {
	$num.clear()
	foreach ($item in $configFile.configuration.process.process.threads) {
		if ($item -eq "Error 404") {
		} elseif ([long]$item -le 63) {	
			$convert = [System.Collections.ArrayList]@()
			$convert = (1..[long]$item | foreach { 1 }) -join ''
			$num.add([convert]::ToInt64("$convert",2))
		} elseif ([double]$item -ge "1.844674407371E+19") {	
			$num.add([double]$item)
		} else {
			$configFile.configuration.process.process[1].threads = "Error 404"
			$configFile.Save(".\Config.xml")
			[xml]$global:configFile = get-content $Current_Folder\Config.xml

		}	
	}
} ; conversion

$name = New-Object System.Collections.Generic.List[System.Object]
function nameset {
	$name.clear()
	$i = 0
	foreach ($item in $configFile.configuration.process.process.threads) {
		if ( $item -eq "Error 404" ) { 
			$i++
		} elseif ([long]$item -le 63) {
			$name.add($configFile.configuration.process.process.name[$i])	
			$i++
		} elseif ([double]$item -ge "1.844674407371E+19") {
			$name.add($configFile.configuration.process.process.name[$i])
			$i++			
		} else { $i++ }
	}
} ; nameset

write-host "Process: " ($name.toarray() -join ', ')
write-host "Affinity: " ($num.toarray() -join ', ')
write-host ""
write-host ""
write-host ""
write-host ""

$timer = New-Object System.Windows.Forms.Timer
function timeset {
	$global:time = [int]$configFile.configuration.time.value * 1000
	$timer.Interval = $time
} ; timeset
$timer.add_tick({ open })
$timer.start()

$time_value.Add_KeyDown({
	if($_.Key -eq "Enter"){
		if ([Int32]::TryParse([string]$time_value.text,[ref]([Int32]$null))){
			$configFile.configuration.time.value = ($time_value.text).trim()
			$configFile.Save("$Current_Folder\Config.xml")
			[xml]$global:configFile = get-content $Current_Folder\Config.xml		
			timeset
			$time_value.text = ""
			write-host $configFile.configuration.time.value
		}
	}
})

$RemoveProfile.Add_Click({ 
	$node = $configFile.configuration.process.process[$for_edit]
	$node.ParentNode.RemoveChild($node)
	$configFile.Save("$Current_Folder\Config.xml")
	[xml]$global:configFile = get-content $Current_Folder\Config.xml
	ProfileRead
	nameset
	conversion
	if ($for_edit -ne 0) {
		$global:for_edit = $for_edit - 1
	}
	$profile_name.SelectedIndex = $for_edit
	write-host "Process: " ($name.toarray() -join ', ')
	write-host "Affinity: " ($num.toarray() -join ', ')	
	write-host $for_edit 
})


function ProfileRead {
	$profile_name.Items.clear()
	foreach ($item in $configFile.configuration.process.process.name) {
		$profile_name.Items.Add($item) | out-null 
	}
	if ([Int32]::TryParse([string]$for_edit,[ref]([Int32]$null))) { 
		$profile_name.SelectedIndex = $for_edit 
		$process_name_txt.content = $configFile.configuration.process.process[$for_edit].name
		$threads_value_txt.content = $configFile.configuration.process.process[$for_edit].threads
	} else { 
		$global:for_edit = 0
		$profile_name.SelectedIndex = $for_edit 
		$process_name_txt.content = $configFile.configuration.process.process[$for_edit].name
		$threads_value_txt.content = $configFile.configuration.process.process[$for_edit].threads
		
	}
} ; ProfileRead

$profile_name.Add_DropDownClosed({
	switch($profile_name.Text) {
		$profile_name.Text {
			$i = 0
			foreach ($item in $configFile.configuration.process.process.name) {
				if ($profile_name.Text -eq $configFile.configuration.process.process[$i].name) {
					$global:for_edit = $i
					$process_name_txt.content = $configFile.configuration.process.process[$i].name
					$threads_value_txt.content = $configFile.configuration.process.process[$i].threads
					break
				} ; $i++
			}
		}
	}
})

function open {
	$i = 0
	foreach ($item in $num.toarray()) {
		$process = Get-Process $name.toarray()[$i]
		if ($process.ProcessorAffinity -ne $num.toarray()[$i]) {
			try {
				$process.ProcessorAffinity = $num.toarray()[$i]
			} catch { }
			if ($process.ProcessorAffinity -ne $num.toarray()[$i]) {
				write-host "Error!" $name.toarray()[$i] ":" $num.toarray()[$i]
			}
		}	
		$i++
	}
}

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
    $Value = $Choose_Accent.SelectedValue
    [ControlzEx.Theming.ThemeManager]::Current.ChangeThemeColorScheme($form, $Value)
})	

$Colors=@()
$Accent = [ControlzEx.Theming.ThemeManager]::Current.ColorSchemes
foreach($item in $Accent) { 
	$Choose_Accent.Items.Add($item)| Out-Null 
}

if ($configFile.configuration.theme.colorscheme.value -ne "") {
	$Choose_Accent.SelectedValue = $configFile.configuration.theme.colorscheme.value
	[ControlzEx.Theming.ThemeManager]::Current.ChangeThemeColorScheme($form, $configFile.configuration.theme.colorscheme.value) | Out-Null 
}

$nep = {
	$random = ("Light", "Dark", "Custom" | Get-Random)
	$configFile.configuration.theme.basecolor.value = $random
	$configFile.Save("$Current_Folder\Config.xml")
	[xml]$global:configFile = get-content $Current_Folder\Config.xml 
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


 ########################### Edit & Add ########
 
$grid_setvalue_1 = $Form.Findname("grid_setvalue_1")
$grid_setvalue_2 = $Form.Findname("grid_setvalue_2")
$header_setvalue_1 = $Form.Findname("header_setvalue_1")
$header_setvalue_2 = $Form.Findname("header_setvalue_2")
 
$process_name = $Form.Findname("process_name")
$threads_value = $Form.Findname("threads_value")
$ProfileSave = $Form.Findname("ProfileSave")
$ProfileBack = $Form.Findname("ProfileBack")

$process = get-process -id $pid
$max_threads = $process.ProcessorAffinity
$max_threads = [convert]::ToString("$max_threads",2)
$max_threads = ($max_threads.ToCharArray()).Count

while ($i -ne $max_threads) {
	$i++
	$threads_value.Items.Add($i) | out-null
}

$AddProfile.Add_Click({
	$global:edit_or_add = "add"
	$ProfileSave.content = "Create"
	$grid_setvalue_1.Visibility = "Hidden"
	$grid_setvalue_2.Visibility = "Visible" 
	$header_setvalue_1.Visibility = "Hidden"
	$header_setvalue_2.Visibility = "Visible" 
})

$EditProfile.Add_Click({
	$global:edit_or_add = "edit"
	$ProfileSave.content = "Save"
	$grid_setvalue_1.Visibility = "Hidden"
	$grid_setvalue_2.Visibility = "Visible"
	$header_setvalue_1.Visibility = "Hidden"
	$header_setvalue_2.Visibility = "Visible"
})

$ProfileBack.Add_Click({
	$grid_setvalue_2.Visibility = "Hidden"
	$grid_setvalue_1.Visibility = "Visible" 
	$header_setvalue_2.Visibility = "Hidden"
	$header_setvalue_1.Visibility = "Visible" 
})

$Form.Add_KeyDown({
	if($_.Key -eq "Enter"){

	}
})

$threads_value.Add_DropDownClosed({
	if ($threads_value.text -ne "") {
		if ([int]$threads_value.text -eq 0) {
			$threads_value.text = ""
		} 
	}
})

$ProfileSave.Add_Click({
	ProfileEdit_Add 	
})

function ProfileEdit_Add {
	if ($edit_or_add -eq "edit") {
		if ($process_name.text -ne "") { 
			$configFile.configuration.process.process[$for_edit].name = ($process_name.text).trim()
			$configFile.Save("$Current_Folder\Config.xml")
			[xml]$global:configFile = get-content $Current_Folder\Config.xml
			nameset
			$process_name.text = ""
		}
		if ($threads_value.text -ne "") {
			if ([int]$threads_value.text -le 63) {
				if ([Int32]::TryParse([string]$threads_value.text,[ref]([Int32]$null))) { 
					$configFile.configuration.process.process[$for_edit].threads = $threads_value.text
					$configFile.Save("$Current_Folder\Config.xml")
					[xml]$global:configFile = get-content $Current_Folder\Config.xml	
					conversion ; nameset
					$process_name.text = ""
					$threads_value.text = ""
				}
			}
		}
		ProfileRead
		write-host "Process: " ($name.toarray() -join ', ')
		write-host "Affinity: " ($num.toarray() -join ', ')
	} elseif ($edit_or_add -eq "add") { 
		if ($process_name.text -ne "") { 
			if ($threads_value.text -ne "") {
				if ([int]$threads_value.text -le 63) {
					if ([Int32]::TryParse([string]$threads_value.text,[ref]([Int32]$null))) { 
						write-host "add"
						$newelement = $configFile.CreateElement("process")
						$newelementadd = $configFile.configuration.process.AppendChild($newelement)
						$newattribute = $newelementadd.SetAttribute("name", $process_name.text)
						$newattribute = $newelementadd.SetAttribute("threads", $threads_value.text)
						$configFile.Save("$Current_Folder\Config.xml")
						[xml]$global:configFile = get-content $Current_Folder\Config.xml
						conversion ; nameset ; ProfileRead
						$process_name.text = ""
						$threads_value.text = ""
						write-host "Process: " ($name.toarray() -join ', ')
						write-host "Affinity: " ($num.toarray() -join ', ')
					}
				}
			}
		}
	}
}

 ######################################################################

$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)