 #Add form and styles
Add-Type -assembly System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

 #Create form
$main_form                      = New-Object System.Windows.Forms.Form
$main_form.Text                 = 'CoreFix stop-process'
$main_form.BackColor            = "#ffffff"
$main_form.Width                = 401
$main_form.Height               = 148
$main_form.StartPosition        = "CenterScreen"
$main_form.AutoSize             = $true

 #Form icon
$Current_Folder = (get-location).path 
$objIcon = New-Object system.drawing.icon ("$Current_Folder\icon\cls.ico")
$main_form.Icon = $objIcon
	
	#Background Image
  #$objImage = [system.drawing.image]::FromFile(".\name.png")
  #$main_form.BackgroundImage = $objImage
  #$main_form.BackgroundImageLayout = "None"

 #Text 1, process pid
$Label                          = New-Object System.Windows.Forms.Label
$Label.Text                     = "Process id: not found"
$Label.Location                 = New-Object System.Drawing.Point(27,15)
$Label.Font                     = 'Microsoft Sans Serif,8'
$Label.ForeColor                = "Red"
$Label.AutoSize                 = $true
$main_form.Controls.Add($Label)

 #Text 2, question
$text                           = New-Object System.Windows.Forms.Label
$text.Text                      = "Scan CoreFix ID please."
$text.Location                  = New-Object System.Drawing.Point(17,45)
$text.Font                      = 'Microsoft Sans Serif,9.7'
$text.AutoSize                  = $true
$main_form.Controls.Add($text)

 #Button "scan"
$Button_scan                    = New-Object system.Windows.Forms.Button
$Button_scan.Location           = New-Object System.Drawing.Size(190,75)
$Button_scan.Size               = New-Object System.Drawing.Size(85,23)
$Button_scan.Text               = "Scan"
$Button_scan.Add_Click({ scan })
$main_form.Controls.Add($Button_scan)

 #Button "cancel"
$Button_cancel                  = New-Object System.Windows.Forms.Button
$Button_cancel.Location         = New-Object System.Drawing.Size(290,75)
$Button_cancel.Size             = New-Object System.Drawing.Size(85,23)
$Button_cancel.DialogResult     = [System.Windows.Forms.DialogResult]::Cancel
$Button_cancel.Text             = "Cancel"
$main_form.Controls.Add($Button_cancel)

 #Button "yes"
$Button_yes                     = New-Object system.Windows.Forms.Button
$Button_yes.Location            = New-Object System.Drawing.Size(190,75)
$Button_yes.Size                = New-Object System.Drawing.Size(85,23)
$Button_yes.Text                = "Yes"
$main_form.Controls.Add($Button_yes)
$Button_yes.Add_Click({ btyes })

 #Button "done"
$Button_done                    = New-Object system.Windows.Forms.Button
$Button_done.Location           = New-Object System.Drawing.Size(190,75)
$Button_done.Size               = New-Object System.Drawing.Size(85,23)
$Button_done.Text               = "Done"
$Button_done.DialogResult       = [System.Windows.Forms.DialogResult]::Cancel
$main_form.Controls.Add($Button_done)
 
 #No comments...
$sleep = {Start-Sleep -Seconds 1}

 #Function button "scan"
function scan() {
	 #Progress bar :3
    $ProgressBar                = New-Object System.Windows.Forms.ProgressBar
    $ProgressBar.Location       = New-Object System.Drawing.Point(29, 35)
    $ProgressBar.Size           = New-Object System.Drawing.Size(330, 25)
    $ProgressBar.Style          = "Marquee"
    $ProgressBar.MarqueeAnimationSpeed = 20
    $main_form.Controls.Add($ProgressBar);
	
	 #PID status scan message
    $Label.Text                 = "Checking PID status... "
	$Label.ForeColor            = "orange"
	$text.Text                  = " "
    $ProgressBar.visible
	 
	 #Sleep
    $job = Start-Job -ScriptBlock $sleep
    do { [System.Windows.Forms.Application]::DoEvents() } until ($job.State -eq "Completed")
    Remove-Job -Job $job -Force
	
	 #Hide progress bar
    $ProgressBar.Hide()
	
	 #Scanning a process for closure
    if (get-process CoreFix) {
		 #Process presence message
		$process_id             = (get-process CoreFix).id
		$text.Text              = "Are you sure you want to clear background CoreFix?"
		$Label.Text             = "Process id: " + $process_id
		$Label.ForeColor        = "green"
		
		 #Button "scan" hide
		$Button_scan.Hide()
		
		 #Button "yes" add
		$Button_yes.visible
	} else {
		 #No process message
		$Label.Text             = "Process id: not found."
		$text.Text              = "Nothing was found so you can leave."
		$Label.ForeColor        = "red"	
	}
}

 #Function button "yes"
function btyes() {
	 #Null message
	$text.Text                  = " "
	$Label.Text                 = " "
	
	 #Scan and stop process
	$bgi = (Get-Process SystrayTool).id
	$cf = (Get-Process CoreFix).id
	Stop-Process $cf, $bgi
	
	 #Progress bar :3
    $ProgressBar = New-Object System.Windows.Forms.ProgressBar
    $ProgressBar.Location = New-Object System.Drawing.Point(29, 35)
    $ProgressBar.Size = New-Object System.Drawing.Size(330, 25)
    $ProgressBar.Style          = "Marquee"
    $ProgressBar.MarqueeAnimationSpeed = 20
    $main_form.Controls.Add($ProgressBar);

	 #Message: stop/close process
    $Label.Text                 = "Stop process CoreFix "
	$Label.ForeColor            = "orange"
	$text.Text                  = " "
    $ProgressBar.visible

	 #Sleep
    $job = Start-Job -ScriptBlock $sleep
    do { [System.Windows.Forms.Application]::DoEvents() } until ($job.State -eq "Completed")
    Remove-Job -Job $job -Force
	
	 #Null
	$Label.Text = " "
    $ProgressBar.Hide()
	
	 #Scan if the application is closed and if there are administrator rights to close
    if ( get-process CoreFix ) {
		 #Message about the lack of administrator rights. Need to open as administrator
		$text.Text              = "Error, access denied. Run as administrator please."
		$text.Location          = New-Object System.Drawing.Point(50,35)
		
		 #Button "yes" hide
		$Button_yes.Hide()
	
		 #Button "done/okey" add
		$Button_done.Text       = "OK"
		$Button_done.visible
		
	} else {
		 #Message successful exit
		$text.Text              = "Ready! You can close."
		$text.Location = New-Object System.Drawing.Point(50,35)
	
		 #Button "yes" hide
		$Button_yes.Hide()
	
		 #Button "done" add
		$Button_done.visible
	}
}

 #### The end
$main_form.ShowDialog()