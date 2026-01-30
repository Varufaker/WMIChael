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
$gui.Height = 440
$gui.StartPosition = “CenterScreen”

#Tab Control
$tabs = New-Object System.Windows.Forms.TabControl 
$tabs.Size = New-Object System.Drawing.Size(680,360) 
$tabs.Location = New-Object System.Drawing.Point(10,10)

    # Create Tab PC
    $tabPC = New-Object System.Windows.Forms.TabPage 
    $tabPC.Text = "PC"
    # PC Tab controls
    #PCBlock
    $labelPC = New-Object System.Windows.Forms.Label 
    $labelPC.Text = "EQUIPO`nNombre del equipo: $(Get-Pcname)`nGrupo de Trabajo: $(Get-Workgroup) | Dominio: $(Get-Domain)`n`nAntivirus: $(Get-AVSoft)"
    $labelPC.AutoSize = $true
    $labelPC.Location = New-Object System.Drawing.Point(20,20)
    #CPUBlock
    $cpu = Get-Cpuinfo
    $labelCPU = New-Object System.Windows.Forms.Label
    $labelCPU.Text = "CPU`nNombre: $($cpu.Nombre)`nNucleos: $($cpu.Nucleos)`nHilos: $($cpu.Hilos)`nVelocidad: $($cpu.Velocidad)`nFabricante: $($cpu.Fabricante)"
    $labelCPU.Autosize = $true
    $labelCPU.Location = New-Object System.Drawing.Point(20,120)
    #Adding controls to tab
    $tabPC.Controls.Add($labelPC)
    $tabPC.Controls.Add($labelCPU)

    # Create Tab RAM 
    $tabRAM = New-Object System.Windows.Forms.TabPage 
    $tabRAM.Text = "Memorias" 
    # RAM Tab controls 
    $labelRAM = New-Object System.Windows.Forms.Label  
    $labelRAM.Text = "Contenido de la pestaña Memorias"
    $labelRAM.Autosize = $true
    $labelRAM.Location = New-Object System.Drawing.Point(20,20)
    #Adding controls to tab
    $tabRAM.Controls.Add($labelRAM)

    # Create Tab Disks
    $tabDisks = New-Object System.Windows.Forms.TabPage
    $tabDisks.Text = "Discos"
    # Disks Tab controls
    $labelDisks = New-Object System.Windows.Forms.Label
    $labelDisks.Text = "Contenido de la pestaña Discos"
    $labelDisks.Autosize = $true
    $labelDisks.Location = New-Object System.Drawing.Point(20,20)
    #Adding controls to tab
    $tabDisks.Controls.Add($labelDisks)

    # Create Tab Sound
    $tabSound = New-Object System.Windows.Forms.TabPage
    $tabSound.Text = "Sonido"
    # Sound Tab controls
    $labelSound = New-Object System.Windows.Forms.Label
    $labelSound.Text = "Contenido de la pestaña Sonido"
    $labelSound.Autosize = $true
    $labelSound.Location = New-Object System.Drawing.Point(20,20)
    #Adding controls to tab
    $tabSound.Controls.Add($labelSound)

    # Create Tab Net
    $tabNet = New-Object System.Windows.Forms.TabPage
    $tabNet.Text = "Red"
    # Net Tab controls
    $labelNet = New-Object System.Windows.Forms.Label
    $labelNet.Text = "Contenido de la pestaña Red"
    $labelNet.Autosize = $true
    $labelNet.Location = New-Object System.Drawing.Point(20,20)
    #Adding controls to tab
    $tabNet.Controls.Add($labelNet)

    # Create Tab Others
    $tabOthers = New-Object System.Windows.Forms.TabPage
    $tabOthers.Text = "Otros"
    # Others Tab controls
    $labelOthers = New-Object System.Windows.Forms.Label
    $labelOthers.Text = "Contenido de la pestaña Otros"
    $labelOthers.Autosize = $true
    $labelOthers.Location = New-Object System.Drawing.Point(20,20)
    #Adding controls to tab
    $tabOthers.Controls.Add($labelOthers)

    # Create Tab Options
    $tabOptions = New-Object System.Windows.Forms.TabPage
    $tabOptions.Text = "Opciones"
    # Options Tab controls
    $labelOptions = New-Object System.Windows.Forms.Label
    $labelOptions.Text = "Contenido de la pestaña Opciones"
    $labelOptions.Autosize = $true
    $labelOptions.Location = New-Object System.Drawing.Point(20,20)
    #Adding controls to tab
    $tabOptions.Controls.Add($labelOptions)

    # Adding tabs to TabControl
    $tabs.TabPages.Add($tabPC)
    $tabs.TabPages.Add($tabRAM)
    $tabs.TabPages.Add($tabDisks)
    $tabs.TabPages.Add($tabSound)
    $tabs.TabPages.Add($tabNet)
    $tabs.TabPages.Add($tabOthers)
    $tabs.TabPages.Add($tabOptions)

    #Exit button
    $exitButton = New-Object System.Windows.Forms.Button
    $exitButton.Text = “Cerrar”
    $exitButton.Dock = "Bottom"
    
    #Events
    $exitButton.Add_Click({$gui.Close()})

$gui.Controls.Add($tabs)
$gui.Controls.Add($cpu_block)
$gui.Controls.Add($mem_block)
$gui.Controls.Add($exitButton)


#Load GUI
$gui.ShowDialog()