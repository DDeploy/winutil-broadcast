function Invoke-WinUtilCustomAppInstaller {
    <#
    .SYNOPSIS
        Dispatches custom install/uninstall logic for apps that are not managed by winget or Chocolatey.

    .PARAMETER AppKey
        The internal app key from $sync.configs.applicationsHashtable (e.g. 'WPFInstallvmix').

    .PARAMETER Action
        'Install' or 'Uninstall'.
    #>
    param(
        [Parameter(Mandatory)]
        [string]$AppKey,

        [Parameter(Mandatory)]
        [ValidateSet('Install','Uninstall')]
        [string]$Action
    )

    switch ($AppKey) {
        'WPFInstallvmix' {
            Install-WinUtilProgramVmix -Action $Action
        }
        default {
            Write-Host "No custom installer defined for $AppKey (manual app)."
        }
    }
}
