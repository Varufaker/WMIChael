#Plantilla para scripts con interfaz gráfica de usuario

Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = “GUI Title”
$form.Width = 300
$form.Height = 200
$form.StartPosition = “CenterScreen”

$label = New-Object System.Windows.Forms.Label
$label.Text = “Hello, World!”
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(10,20)
$button = New-Object System.Windows.Forms.Button
$button.Text = “Click Me”
$button.Location = New-Object System.Drawing.Point(10,50)

$button.Add_Click({
    $label.Text = “Button Clicked!”
})

$form.Controls.Add($label)
$form.Controls.Add($button)

$form.ShowDialog()