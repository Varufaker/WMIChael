# =====================
# Constantes del modulo
# =====================

$Global:Gib = 1GB

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
    (Get-CimInstance -Namespace root\SecurityCenter2 -Class AntiVirusProduct).displayName
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

Export-ModuleMember -Function Get-Pcname, Get-Workgroup, Get-Domain, Get-AVSoft, Get-Cpuinfo, Get-Disks, Get-Mem