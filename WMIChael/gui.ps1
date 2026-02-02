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

$(T "PC_Name"): $(Get-Pcname)
$(T "Workgroup"):  $(Get-Workgroup)
$(T "IsDomain"):        $(Get-Domain)
$(T "AV"):  $(Get-AVSoft)

CPU:

$(T "CPU"): $($(Get-Cpuinfo).Nombre)
$(T "Cores"): $($(Get-Cpuinfo).Nucleos)
$(T "Threads"): $($(Get-Cpuinfo).Hilos)
$(T "Speed"): $($(Get-Cpuinfo).Velocidad)
"@
    $flowPC.Controls.Add( (New-InfoLabel $text) )

    # Memory Tab
    $tabRam = New-Tab "RAM"
    $flowRam = New-FlowPanel
    $tabRam.Controls.Add($flowRam)
    foreach ($m in Get-Mem) {
        $text = @"
$(T "Bank"):      $($m.Banco)
$(T "Capacity"):  $($m.Capacidad)
$(T "Speed"):  $($m.Velocidad)
$(T "Voltage"):    $($m.Voltaje)
$(T "Model"):     $($m.Modelo)
$(T "Manufacturer"): $($m.Fabricante)
$(T "Serial"):    $($m.Serie)
"@
        $flowRam.Controls.Add( (New-InfoLabel $text) )
    }

    # Disks Tab
    $tabDisk = New-Tab "Disks"
    $listDisk = New-FlowPanel
    $tabDisk.Controls.Add($listDisk)
    foreach ($d in Get-Disks) {
        $text = @"
$(T "Model"):  $($d.Modelo)
$(T "Capacity"):  $($d.Capacidad)
$(T "Phys"):  $($d.ID)
"@
        $listDisk.Controls.Add( (New-InfoLabel $text) )
    }
    
    # Create Tab Sound
    $tabSound = New-Tab "Sound"
    $flowSound = New-FlowPanel
    # Sound Tab controls
$text = @"
Content
"@
    #Adding controls to tab
    $flowSound.Controls.Add( (New-InfoLabel $text) )


    # Create Tab Net
    $tabNet = New-Tab "Network"
    $flowNet = New-FlowPanel
    # Net Tab controls
$text = @"
Content
"@
    #Adding controls to tab
    $flowNet.Controls.Add( (New-InfoLabel $text) )


    # Create Tab Others
    $tabOthers = New-Tab "Others"
    $flowOthers = New-FlowPanel
    # Net Tab controls
$text = @"
Content
"@
    #Adding controls to tab
    $flowOthers.Controls.Add( (New-InfoLabel $text) )

    # Create Tab Options
    $tabOptions = New-Tab "Options"
    $flowOptions = New-FlowPanel
    # Net Tab controls
$text = @"
Content
"@
    #Adding controls to tab
    $flowOptions.Controls.Add( (New-InfoLabel $text) )

    # Adding tabs to TabControl
    $tabs.TabPages.Add($tabPC)
    $tabs.TabPages.Add($tabRam)
    $tabs.TabPages.Add($tabDisk)
    $tabs.TabPages.Add($tabSound)
    $tabs.TabPages.Add($tabNet)
    $tabs.TabPages.Add($tabOthers)
    $tabs.TabPages.Add($tabOptions)

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