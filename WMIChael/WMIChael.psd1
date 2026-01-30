@{
    # Module name
    RootModule        = 'WMIChael.psm1'

    # Module version
    ModuleVersion     = '0.1'

    # GUID (you have to generate new one with [guid]::NewGuid())
    GUID              = '12345678-abcd-1234-abcd-1234567890ab'

    # Creator
    Author            = 'Jony Lobeto'
    CompanyName       = 'Estudios Comet'

    # Short description
    Description       = 'Wmichael logic module'

    # Functions to export
    FunctionsToExport = @('Get-Pcname','Get-AVSoft','Get-Cpuinfo','Get-Workgroup','Get-Domain','Get-Disks','Get-Mem')

    # Exported Cmdlets, variables and aliases
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    # PowerShell minimun compatibility
    PowerShellVersion = '5.1'
}