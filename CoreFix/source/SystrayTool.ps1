 #Add SYS form
[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  	            | out-null
[System.Windows.Forms.Application]::EnableVisualStyles()

 #SYStrayTool icon
$ProgData = $env:PROGRAMDATA 
$icon_check = (Test-Path $ProgData\CoreFix)
 
if ( $icon_check -eq "True" ){
	$icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$ProgData\CoreFix\CoreFix.exe")
	$FomIcon = New-Object system.drawing.icon ("$ProgData\CoreFix\SystrayTool\assembly\icon.ico")
} else { 
	$icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\mmc.exe")
}

$Main_Tool_Icon = New-Object System.Windows.Forms.NotifyIcon
$Main_Tool_Icon.Text = "CoreFix"
$Main_Tool_Icon.Icon = $icon
$Main_Tool_Icon.Visible = $true

 #Create button		
$Menu_Happy = New-Object System.Windows.Forms.MenuItem
$Menu_Happy.Text = "Be happy!"

$Menu_Support = New-Object System.Windows.Forms.MenuItem
$Menu_Support.Text = "Support"

$Menu_Restart = New-Object System.Windows.Forms.MenuItem
$Menu_Restart.Text = "Restart (in 5secs)"

$Menu_Exit = New-Object System.Windows.Forms.MenuItem
$Menu_Exit.Text = "Exit"

 #Adding Buttons to the Context Menu
$contextmenu = New-Object System.Windows.Forms.ContextMenu
$Main_Tool_Icon.ContextMenu = $contextmenu
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Happy)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Support)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Restart)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Exit)

#########// Support GUI

 #Create form
$main_form                      = New-Object System.Windows.Forms.Form
$main_form.Text                 = 'Support'
$main_form.BackColor            = "#ffffff"
$main_form.Width                = 500
$main_form.Height               = 198
$main_form.StartPosition        = "CenterScreen"
$main_form.AutoSize             = $true
$main_form.Icon = $FomIcon

 #Text, How to use
$HTU                         = New-Object System.Windows.Forms.Label
$HTU.Text                     = "How to use"
$HTU.Location                 = New-Object System.Drawing.Point(23,5)
$HTU.Font                     = 'Microsoft Sans Serif, 10, style=Bold'
$HTU.AutoSize                 = $true
$main_form.Controls.Add($HTU)

 #Text, use1
$use1                          = New-Object System.Windows.Forms.Label
$use1.Text                     = '1. To get started, open the file "Config.xml" and customize for yourself.'
$use1.Location                 = New-Object System.Drawing.Point(15,25)
$use1.Font                     = 'Microsoft Sans Serif, 8,'
$use1.AutoSize                 = $true
$main_form.Controls.Add($use1)

 #Text, use2
$use2                          = New-Object System.Windows.Forms.Label
$use2.Text                     = '2. Next, restart the application.'
$use2.Location                 = New-Object System.Drawing.Point(15,45)
$use2.Font                     = 'Microsoft Sans Serif, 8,'
$use2.AutoSize                 = $true
$main_form.Controls.Add($use2)

 #Text, use3
$use3                          = New-Object System.Windows.Forms.Label
$use3.Text                     = 'If you did everything right, then there should be no errors.'
$use3.Location                 = New-Object System.Drawing.Point(20,65)
$use3.Font                     = 'Microsoft Sans Serif, 8,'
$use3.AutoSize                 = $true
$main_form.Controls.Add($use3)

 #Text, use4
$use4                          = New-Object System.Windows.Forms.Label
$use4.Text                     = 'Valid values for the "CPU Threads" parameter are in the range'
$use4.Location                 = New-Object System.Drawing.Point(20,85)
$use4.Font                     = 'Microsoft Sans Serif, 8,'
$use4.AutoSize                 = $true
$main_form.Controls.Add($use4)

 #Text, use5
$use5                          = New-Object System.Windows.Forms.Label
$use5.Text                     = 'up to 63 and after 1.844674407371E+19 (64 without conversion)'
$use5.Location                 = New-Object System.Drawing.Point(20,105)
$use5.Font                     = 'Microsoft Sans Serif, 8,'
$use5.AutoSize                 = $true
$main_form.Controls.Add($use5)

 #Text, use6
$use6                          = New-Object System.Windows.Forms.Label
$use6.Text                     = "Please email me if you have any bugs that you can't resolve."
$use6.Location                 = New-Object System.Drawing.Point(15,130)
$use6.Font                     = 'Microsoft Sans Serif, 9'
$use6.AutoSize                 = $true
$main_form.Controls.Add($use6)


 #Text, Contacts
$Contacts                          = New-Object System.Windows.Forms.Label
$Contacts.Text                     = "Contacts"
$Contacts.Location                 = New-Object System.Drawing.Point(400,5)
$Contacts.Font                     = 'Microsoft Sans Serif, 10, style=Bold'
$Contacts.AutoSize                 = $true
$main_form.Controls.Add($Contacts)

 #Button "Discord"
$Button_Discord                 = New-Object System.Windows.Forms.Button
$Button_Discord.Location         = New-Object System.Drawing.Size(390,25)
$Button_Discord.Size             = New-Object System.Drawing.Size(85,23)
$Button_Discord.Add_Click({Start-Process "https://discordapp.com/users/412980274935103508/"})
$Button_Discord.Text             = "Discord"
$main_form.Controls.Add($Button_Discord)

 #Button "Telegram"
$Button_Telegram                  = New-Object System.Windows.Forms.Button
$Button_Telegram.Location         = New-Object System.Drawing.Size(390,50)
$Button_Telegram.Size             = New-Object System.Drawing.Size(85,23)
$Button_Telegram.Add_Click({Start-Process "https://t.me/C0RE2quad"})
$Button_Telegram.Text             = "Telegram"
$main_form.Controls.Add($Button_Telegram)

 #Button "VK"
$Button_VK                  = New-Object System.Windows.Forms.Button
$Button_Vk.Location         = New-Object System.Drawing.Size(390,75)
$Button_VK.Size             = New-Object System.Drawing.Size(85,23)
$Button_VK.Add_Click({Start-Process "https://vk.com/karus0n"})
$Button_VK.Text             = "VK"
$main_form.Controls.Add($Button_VK)

 #Button "cancel"
$Button_cancel                  = New-Object System.Windows.Forms.Button
$Button_cancel.Location         = New-Object System.Drawing.Size(390,125)
$Button_cancel.Size             = New-Object System.Drawing.Size(85,23)
$Button_cancel.DialogResult     = [System.Windows.Forms.DialogResult]::Cancel
$Button_cancel.Text             = "Cancel"
$main_form.Controls.Add($Button_cancel)

#########//

 #Click "Be happy!"
$Menu_Happy.Add_Click({
	 #Notify
	$Main_Tool_Icon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
	$Main_Tool_Icon.BalloonTipTitle = "Be happy!"
	$Main_Tool_Icon.BalloonTipText = 'You will succeed and you will have a wonderful day. I believe in you! :3'
	$Main_Tool_Icon.ShowBalloonTip(10000)
	
})

 #Click "Support"
$Menu_Support.Add_Click({
	$main_form.ShowDialog()
	
})


 #Click "Exit"
$Menu_Exit.add_Click({
	 #Write PID CoreFix
	$corefix = (get-process corefix).id
	
	 #Cleaning and shutdown
	$Main_Tool_Icon.Visible = $false
	$window.Close()
	Stop-Process $corefix, $pid
 })

 
 
 #Click "Restart"
$Menu_Restart.add_Click({
	 #Opening CoreFix with the $Restart parameter
	$Restart = "Yes"
	start-process -WindowStyle hidden powershell.exe "$ProgData\CoreFix\CoreFix.exe '$Restart'" 	
	
	 #Write PID CoreFix
	$corefix = (get-process corefix).id
	 
	 #Cleaning and shutdown
	$Main_Tool_Icon.Visible = $false
	$window.Close()
	Stop-Process $corefix, $pid	
 })

 #Garbage collector as far as I understand
[System.GC]::Collect()

#### The end
$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)