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
$gui.Text = "WMIChael a0.1"
$gui.Width = 720
$gui.Height = 560
$gui.StartPosition = "CenterScreen"

#Tab Control
$tabs = New-Object System.Windows.Forms.TabControl 
$tabs.Size = New-Object System.Drawing.Size(680,460) 
$tabs.Location = New-Object System.Drawing.Point(10,10)

    # Create Tabs

    # PC Tab
    $tabPC = New-Tab "PC"
    $flowPC = New-FlowPanel
    $tabPC.Controls.Add($flowPC)
    $text = @"
INFORMACION DEL SISTEMA:

 Nombre del equipo: $(Get-Pcname)
  Grupo de Trabajo: $(Get-Workgroup)
        Es Dominio: $(Get-Domain)
  Antivirus activo: $(Get-AVSoft)

CPU:

Procesador: $($(Get-Cpuinfo).Nombre)
   Nucleos: $($(Get-Cpuinfo).Nucleos)
     Hilos: $($(Get-Cpuinfo).Hilos)
 Velocidad: $($(Get-Cpuinfo).Velocidad)
"@
    $flowPC.Controls.Add( (New-InfoLabel $text) )

    # Memory Tab
    $tabRam = New-Tab "Memorias"
    $flowRam = New-FlowPanel
    $tabRam.Controls.Add($flowRam)
    foreach ($m in Get-Mem) {
        $text = @"
Banco:      $($m.Banco)
Capacidad:  $($m.Capacidad)
Velocidad:  $($m.Velocidad)
Voltaje:    $($m.Voltaje)
Modelo:     $($m.Modelo)
Fabricante: $($m.Fabricante)
NºSerie:    $($m.Serie)
"@
        $flowRam.Controls.Add( (New-InfoLabel $text) )
    }

    # Disks Tab
    $tabDisk = New-Tab "Discos"
    $listDisk = New-FlowPanel
    $tabDisk.Controls.Add($listDisk)
    foreach ($d in Get-Disks) {
        $text = @"
   Modelo:  $($d.Modelo)
Capacidad:  $($d.Capacidad)
       ID:  $($d.ID)
"@
        $listDisk.Controls.Add( (New-InfoLabel $text) )
    }

# Adding tabs to TabControl
$tabs.TabPages.Add($tabPC)
$tabs.TabPages.Add($tabRam)
$tabs.TabPages.Add($tabDisk)

#Exit button
    $exitButton = New-Object System.Windows.Forms.Button
    $exitButton.Text = "Cerrar"
    $exitButton.Dock = "Bottom"
    
    #Events
    $exitButton.Add_Click({$gui.Close()})

# Add controls to GUI
$gui.Controls.Add($tabs)
$gui.Controls.Add($exitButton)


#Load GUI
$gui.ShowDialog()

#Perform cleanup
$gui.Add_FormClosing({
    OnApplicationExit
})