function Invoke-WinUtilCustomAppDetect {
    <#
    .SYNOPSIS
        Detects whether a custom (non-winget/choco) app is installed.

    .PARAMETER AppKey
        The internal app key from $sync.configs.applicationsHashtable (e.g. 'WPFInstallvmix').

    .OUTPUTS
        [bool] True if the app is detected as installed, otherwise False.
    #>
    param(
        [Parameter(Mandatory)]
        [string]$AppKey
    )

    switch ($AppKey) {
        'WPFInstallvmix' {
            $paths = @(
                'C:\Program Files (x86)\vMix\vMix64.exe',
                'C:\Program Files\vMix\vMix64.exe'
            )
            return ($paths | ForEach-Object { Test-Path $_ } | Where-Object { $_ } | Measure-Object).Count -gt 0
        }
        'WPFInstalldantecontroller' {
            $paths = @(
                'C:\Program Files (x86)\Dante Controller\Dante Controller.exe',
                'C:\Program Files\Dante Controller\Dante Controller.exe'
            )
            return ($paths | ForEach-Object { Test-Path $_ } | Where-Object { $_ } | Measure-Object).Count -gt 0
        }
        'WPFInstallblackmagicatem1011' {
            $paths = @(
                'C:\Program Files (x86)\Blackmagic Design\Blackmagic ATEM Switchers\ATEM Setup.exe'
            )
            return ($paths | ForEach-Object { Test-Path $_ } | Where-Object { $_ } | Measure-Object).Count -gt 0
        }
        'WPFInstallblackmagicdesktopvideo153' {
            $paths = @(
                'C:\Program Files (x86)\Blackmagic Design\Desktop Video Setup\Desktop Video Setup.exe'
            )
            return ($paths | ForEach-Object { Test-Path $_ } | Where-Object { $_ } | Measure-Object).Count -gt 0
        }

        'WPFInstallcompanionsatellite' {
            $paths = @(
                'C:\Program Files\companion-satellite\companion-satellite.exe',
                'C:\Program Files (x86)\companion-satellite\companion-satellite.exe'
            )
            return ($paths | ForEach-Object { Test-Path $_ } | Where-Object { $_ } | Measure-Object).Count -gt 0
        }
        default {
            return $false
        }
    }
}
