#-------------#
#Import Module#
#-------------#

function Get-ScriptFolder {
        if ($PSScriptRoot) {
        return $PSScriptRoot
    } else {
        # Fallback si se ejecuta en consola
        return (Get-Location).Path
    }
}
$ModulePath = Get-ScriptFolder
Import-Module (Join-Path $ModulePath 'WMIChael.psd1') -Force


#-------------#
#GUI Structure#
#-------------#

Add-Type -AssemblyName System.Windows.Forms

#Main Window
$gui = New-Object System.Windows.Forms.Form
$gui.Text = “WMIChael a0.1”
$gui.Width = 720
$gui.Height = 380
$gui.StartPosition = “CenterScreen”

#Tab Control
$tabs = New-Object System.Windows.Forms.TabControl 
$tabs.Size = New-Object System.Drawing.Size(580,360) 
$tabs.Location = New-Object System.Drawing.Point(10,10)
# Crear pestaña 1 
$tab1 = New-Object System.Windows.Forms.TabPage 
$tab1.Text = "General" 
# Añadir un control a la pestaña 1 
$label1 = New-Object System.Windows.Forms.Label 
$label1.Text = "Contenido de la pestaña General" 
$label1.Location = New-Object System.Drawing.Point(20,20) 
$tab1.Controls.Add($label1) 
# Crear pestaña 2 
$tab2 = New-Object System.Windows.Forms.TabPage 
$tab2.Text = "Opciones" 
# Añadir un control a la pestaña 2 
$button1 = New-Object System.Windows.Forms.Button 
$button1.Text = "Pulsar" 
$button1.Location = New-Object System.Drawing.Point(20,20) 
$tab2.Controls.Add($button1) 
# Añadir pestañas al TabControl 
$tabs.TabPages.Add($tab1) 
$tabs.TabPages.Add($tab2)

    #Window Content
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "EQUIPO`nNombre del equipo: $(Get-Pcname)`nGrupo de Trabajo: $(Get-Workgroup) | Dominio: $(Get-Domain)`n`nAntivirus: $(Get-AVSoft)`n`n"
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(10,20)

    #CPU Block
    $cpu = Get-Cpuinfo
    $cpu_block = New-Object System.Windows.Forms.Label
    $cpu_block.Text = "CPU`nNombre: $($cpu.Nombre)`nNucleos: $($cpu.Nucleos)`nHilos: $($cpu.Hilos)`nVelocidad: $($cpu.Velocidad)`nFabricante: $($cpu.Fabricante)"
    $cpu_block.AutoSize = $true
    $cpu_block.Location = New-Object System.Drawing.Point(10,120)
	
	#Memory Block
	$mem_block = New-Object System.Windows.Forms.label
	$mem_block.Text = "Memory block"
	$mem_block.AutoSize = $true
	$mem_block.Location = New-Object System.Drawing.Point(10,230)

    #Exit button
    $exitButton = New-Object System.Windows.Forms.Button
    $exitButton.Text = “Cerrar”
    $exitButton.Dock = "Bottom"
    
    #Events
    $exitButton.Add_Click({$gui.Close()})

$gui.Controls.Add($tabs)
$gui.Controls.Add($label)
$gui.Controls.Add($cpu_block)
$gui.Controls.Add($mem_block)
$gui.Controls.Add($exitButton)


#Load GUI
$gui.ShowDialog()