function Invoke-WinUtilCustomAppInstaller {
    <#
    .SYNOPSIS
        Runs custom install/uninstall logic for apps that are not handled via winget or Chocolatey.

    .PARAMETER AppKey
        Internal app key from $sync.configs.applicationsHashtable (e.g. 'WPFInstallvmix').

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

    function Invoke-DownloadInstaller {
        param(
            [Parameter(Mandatory)][string]$Name,
            [Parameter(Mandatory)][string]$Url,
            [string]$Arguments = '',
            [string]$InstallerFileName = ''
        )

        $installerPath = if ($InstallerFileName) {
            Join-Path $env:TEMP $InstallerFileName
        } else {
            Join-Path $env:TEMP ([System.IO.Path]::GetFileName(($Url -split '\?')[0]))
        }

        Write-Host "Downloading $Name installer..."
        Invoke-WebRequest -Uri $Url -OutFile $installerPath -UseBasicParsing

        Write-Host "Running $Name installer..."
        $proc = Start-Process -FilePath $installerPath -ArgumentList $Arguments -Wait -PassThru
        if ($proc.ExitCode -eq 0) {
            Write-Host "$Name installer completed successfully."
        } else {
            Write-Warning "$Name installer exited with code $($proc.ExitCode)."
        }
    }

    switch ($AppKey) {
        'WPFInstallvmix' {
            if ($Action -eq 'Install') {
                Invoke-DownloadInstaller -Name 'vMix' -Url 'https://www.vmix.com/download/vmix29.exe' -Arguments '' -InstallerFileName 'vmix-setup.exe'
            } else {
                Write-Warning 'Automatic uninstall for vMix is not implemented. Please uninstall via Apps & Features.'
            }
        }
        'WPFInstalldantecontroller' {
            if ($Action -eq 'Install') {
                Invoke-DownloadInstaller -Name 'Dante Controller' -Url 'https://www.getdante.com/download/DanteController/4/4.16/DanteController-4.16.1.5_windows.exe'
            } else {
                Write-Warning 'Automatic uninstall for Dante Controller is not implemented. Please uninstall via Apps & Features.'
            }
        }
        'WPFInstallblackmagicatem1011' {
            if ($Action -eq 'Install') {
                Invoke-DownloadInstaller -Name 'Blackmagic ATEM Switchers 10.1.1' -Url 'https://www.blackmagicdesign.com/support/download/78398c4ec6ac4c69b97e8d7841fa14a9/Windows'
            } else {
                Write-Warning 'Automatic uninstall for Blackmagic ATEM Switchers is not implemented. Please uninstall via Apps & Features.'
            }
        }
        'WPFInstallblackmagicdesktopvideo153' {
            if ($Action -eq 'Install') {
                Invoke-DownloadInstaller -Name 'Blackmagic Desktop Video 15.3' -Url 'https://www.blackmagicdesign.com/support/download/655452f94941434883b8cb790e128954/Windows'
            } else {
                Write-Warning 'Automatic uninstall for Blackmagic Desktop Video is not implemented. Please uninstall via Apps & Features.'
            }
        }

        'WPFInstallcompanionsatellite' {
            if ($Action -eq 'Install') {
                Invoke-DownloadInstaller -Name 'Bitfocus Companion Satellite' -Url 'https://s4.bitfocus.io/builds/companion-satellite/companion-satellite-x64-551-d9dae48.exe'
            } else {
                Write-Warning 'Automatic uninstall for Bitfocus Companion Satellite is not implemented. Please uninstall via Apps & Features.'
            }
        }
        default {
            Write-Host "No custom installer defined for $AppKey (manual app)."
        }
    }
}
