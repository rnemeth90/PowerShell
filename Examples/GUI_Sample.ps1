Add-Type -AssemblyName System.Windows.Forms

$TestForm = New-Object system.Windows.Forms.Form
$TestForm.Text = "Test Form"
$TestForm.BackColor = "#723535"
$TestForm.TopMost = $true
$TestForm.Width = 640
$TestForm.Height = 432

$button2 = New-Object system.windows.Forms.Button
$button2.Text = "button"
$button2.Width = 60
$button2.Height = 30
$button2.location = new-object system.drawing.point(265,263)
$button2.Font = "Microsoft Sans Serif,10"
$TestForm.controls.Add($button2)

$button2 = New-Object system.windows.Forms.Button
$button2.Text = "button"
$button2.Width = 60
$button2.Height = 30
$button2.location = new-object system.drawing.point(265,263)
$button2.Font = "Microsoft Sans Serif,10"
$TestForm.controls.Add($button2)

$textBox4 = New-Object system.windows.Forms.TextBox
$textBox4.Width = 303
$textBox4.Height = 20
$textBox4.location = new-object system.drawing.point(142,95)
$textBox4.Font = "Microsoft Sans Serif,10"
$TestForm.controls.Add($textBox4)

$textBox4 = New-Object system.windows.Forms.TextBox
$textBox4.Width = 303
$textBox4.Height = 20
$textBox4.location = new-object system.drawing.point(142,95)
$textBox4.Font = "Microsoft Sans Serif,10"
$TestForm.controls.Add($textBox4)

$checkBox6 = New-Object system.windows.Forms.CheckBox
$checkBox6.Text = "checkBox"
$checkBox6.AutoSize = $true
$checkBox6.Width = 95
$checkBox6.Height = 20
$checkBox6.location = new-object system.drawing.point(10,20)
$checkBox6.Font = "Microsoft Sans Serif,10"
$TestForm.controls.Add($checkBox6)

$checkBox6 = New-Object system.windows.Forms.CheckBox
$checkBox6.Text = "checkBox"
$checkBox6.AutoSize = $true
$checkBox6.Width = 95
$checkBox6.Height = 20
$checkBox6.location = new-object system.drawing.point(10,20)
$checkBox6.Font = "Microsoft Sans Serif,10"
$TestForm.controls.Add($checkBox6)

$comboBox8 = New-Object system.windows.Forms.ComboBox
$comboBox8.Text = "comboBox"
$comboBox8.Width = 50
$comboBox8.Height = 20
$comboBox8.location = new-object system.drawing.point(25,129)
$comboBox8.Font = "Microsoft Sans Serif,10"
$TestForm.controls.Add($comboBox8)

$comboBox8 = New-Object system.windows.Forms.ComboBox
$comboBox8.Text = "comboBox"
$comboBox8.Width = 50
$comboBox8.Height = 20
$comboBox8.location = new-object system.drawing.point(25,129)
$comboBox8.Font = "Microsoft Sans Serif,10"
$TestForm.controls.Add($comboBox8)

$radioButton10 = New-Object system.windows.Forms.RadioButton
$radioButton10.Text = "radioButton"
$radioButton10.AutoSize = $true
$radioButton10.Width = 104
$radioButton10.Height = 20
$radioButton10.location = new-object system.drawing.point(17,73)
$radioButton10.Font = "Microsoft Sans Serif,10"
$TestForm.controls.Add($radioButton10)

$radioButton10 = New-Object system.windows.Forms.RadioButton
$radioButton10.Text = "radioButton"
$radioButton10.AutoSize = $true
$radioButton10.Width = 104
$radioButton10.Height = 20
$radioButton10.location = new-object system.drawing.point(17,73)
$radioButton10.Font = "Microsoft Sans Serif,10"
$TestForm.controls.Add($radioButton10)

[void]$TestForm.ShowDialog()
$TestForm.Dispose()