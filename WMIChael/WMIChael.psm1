# =====================
# Constantes del modulo
# =====================

class HWConstants {
    static [double]$GiB = 1GB
    static [double]$MB  = 1MB
}

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

# Discos
function Get-Disks {
$disks = Get-CimInstance Win32_DiskDrive
foreach ($disk in $disks) {
    $sizeGB = [math]::Round($disk.Size / [HWConstants]::$GiB, 2)
    $disks_info = "$($disk.Model) - $sizeGB GB"
    }
}

Export-ModuleMember -Function Get-Pcname, Get-Workgroup, Get-Domain, Get-AVSoft, Get-Cpuinfo, Get-Disks