# =====================
# Constantes del modulo
# =====================

$Global:GiB = 1GB
$Global:CurrentLang = "es"

# =====================
# Funciones del modulo
# =====================

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


Export-ModuleMember -Function Get-*, New-*, OnApplicationExit
