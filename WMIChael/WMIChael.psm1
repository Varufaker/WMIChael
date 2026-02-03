# =====================
# Constantes del modulo
# =====================

#De formato de datos
$Global:GiB = 1GB

#De idiomas
$Global:CurrentLang = "English"
$Global:Lang = @{
    "Español" = @{
        "PC_Name"      = "Nombre del equipo"
        "Workgroup"    = "Grupo de trabajo"
        "IsDomain"     = "Es dominio"
        "AV"           = "Antivirus activo"
        "Bank"         = "Banco"
        "Capacity"     = "Capacidad"
        "Speed"        = "Velocidad"
        "Voltage"      = "Voltaje"
        "Model"        = "Modelo"
        "Manufacturer" = "Fabricante"
        "Serial"       = "Nº Serie"
        "CPU"          = "Procesador"
        "Cores"        = "Nucleos"
        "Threads"      = "Hilos"
        "Phys"         = "Direccion logica"
        "Disks"        = "Discos"
        "Sound"        = "Sonido"
        "Network"      = "Red"
        "Others"       = "Otros"
        "Options"      = "Opciones"
        "Memory"       = "Memorias"
        "PC"           = "Ordenador"
        "sys_info"     = "Informacion del sistema"
        "Language"     = "Idioma"
    }
    "English" = @{
        "PC_Name"      = "Computer name"
        "Workgroup"    = "Workgroup"
        "IsDomain"     = "Domain joined"
        "AV"           = "Active antivirus"
        "Bank"         = "Bank"
        "Capacity"     = "Capacity"
        "Speed"        = "Speed"
        "Voltage"      = "Voltage"
        "Model"        = "Model"
        "Manufacturer" = "Manufacturer"
        "Serial"       = "Serial number"
        "CPU"          = "Processor"
        "Cores"        = "Cores"
        "Threads"      = "Threads"
        "Phys"         = "Logical Address"
        "Disks"        = "Disks"
        "Sound"        = "Sound"
        "Network"      = "Network"
        "Memory"       = "Memory"
        "Others"       = "Others"
        "Options"      = "Options"
        "PC"           = "Computer"
        "sysinfo"      = "System Information"
        "Language"     = "Language" 
    }
}

# =====================
# Funciones del modulo
# =====================

#Función de idiomas#
#------------------#

function T {
    param([string]$Key)
    return $Lang[$CurrentLang][$Key]
}

function Update-LanguageUI {
    foreach ($text in $form.Controls) {
        Update-ControlLanguage $text
    }
}

function Update-ControlLanguage($text) {
    # Si el control tiene una propiedad Text, la actualizamos
    if ($text.PC) {
        $text.PC = T $text.PC
    }
    # Si el control contiene otros controles, los recorremos
    if ($text.Controls.Count -gt 0) {
        foreach ($child in $ctrl.Controls) {
            Update-ControlLanguage $child
        }
    }
}



#Funciones de GUI#
#----------------#

function New-InfoLabel {
    param(
        [string]$Text
    )

    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Text
    $label.AutoSize = $true
    $label.Margin = "0,0,0,10"
    $label.MaximumSize = New-Object System.Drawing.Size(600, 0)
    $label.Font = New-Object System.Drawing.Font("Consolas", 10)
    return $label
}

function New-ListView {
    param(
        [array]$Data,
        [string[]]$Columns
    )

    $list = New-Object System.Windows.Forms.ListView
    $list.View = "Details"
    $list.FullRowSelect = $true
    $list.GridLines = $true
    $list.Dock = "Fill"

    foreach ($col in $Columns) {
        $list.Columns.Add($col, 150)
    }

    foreach ($item in $Data) {
        $first = $item | Select-Object -ExpandProperty $Columns[0] -ErrorAction SilentlyContinue
        $row = New-Object System.Windows.Forms.ListViewItem($first)
        foreach ($col in $Columns[1..($Columns.Count-1)]) {
            $row.SubItems.Add($item.$col)
        }
        $list.Items.Add($row)
    }
    return $list
}

function New-Tab {
    param(
        [string]$Title
    )
    $tab = New-Object System.Windows.Forms.TabPage
    $tab.Text = $Title
    return $tab
}

function New-FlowPanel {
    $flow = New-Object System.Windows.Forms.FlowLayoutPanel
    $flow.FlowDirection = "TopDown"
    $flow.WrapContents = $false
    $flow.AutoScroll = $true
    $flow.Dock = "Fill"
    return $flow
}

function OnApplicationExit {	
	$script:ExitCode = 0 #Set the exit code for the Packager
}


#Funciones de APP#
#----------------#

#Nombre del PC, Grupo de trabajo, etc
function Get-Pcname {
    (Get-CimInstance Win32_ComputerSystem).Name
}

function Get-Workgroup {
    (Get-CimInstance Win32_ComputerSystem).Domain
}

function Get-Domain {
    (Get-CimInstance Win32_ComputerSystem).PartOfDomain
}

#Software Anti Virus
function Get-AVSoft {
    try {
        $av = Get-CimInstance -Namespace root\SecurityCenter2 -Class AntiVirusProduct -ErrorAction Stop
        if ($av) { $av.displayName -join ", " }
        else { "No detectado" }
    } catch {
        "No disponible"
    }
}

# CPU
function Get-Cpuinfo {
    $cpu = Get-CimInstance Win32_Processor
    [PSCustomObject]@{
        Nombre     = $cpu.Name
        Nucleos    = $cpu.NumberOfCores
        Hilos      = $cpu.NumberOfLogicalProcessors
        Velocidad  = "$($cpu.MaxClockSpeed) MHz"
        Fabricante = $cpu.Manufacturer
        }
}

# Memorias
function Get-Mem {
    $memories = Get-CimInstance Win32_PhysicalMemory
    foreach ($m in $memories) {
        $sizeGB = [math]::Round($m.Capacity / $GiB, 2)
        [PSCustomObject]@{
            Banco = $m.BankLabel
            Capacidad = "$sizeGB GiB"
            Velocidad = "$($m.Speed) MHz"
            Voltaje = $m.MaxVoltage
            Modelo = $m.PartNumber
            Fabricante = $m.Manufacturer
            Serie = $m.SerialNumber
        }
    }
}

# Discos
function Get-Disks {
    $disk = Get-CimInstance Win32_DiskDrive
    foreach ($d in $disk) {
        $sizeGB = [math]::Round($d.Size / $GiB, 2)
        [PSCustomObject]@{
            Nombre = $d.Caption
            Capacidad = "$sizeGB GiB"
            Modelo = $d.Model
            ID = $d.DeviceID
        }
    }
}

function Get-Audio {
    $audio = Get-CimInstance Win32_SoundDevice
    foreach ($a in $audio) {
        [PSCustomObject]@{
            Nombre = $a.Name
            Fabricante = $a.Manufacturer
            Status = $a.Status
            StatusI = $a.StatusInfo
        }
        $audio
    }
}

function Get-Net {
    $net = "Content"
    foreach ($n in $net) {
        [PSCustomObject]@{
          X = $n.X
        }
    $net
    }
}

Export-ModuleMember -Function T, OnApplicationExit, Get-*, New-*, Update-*