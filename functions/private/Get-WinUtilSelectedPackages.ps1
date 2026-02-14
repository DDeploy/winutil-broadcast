function Get-WinUtilSelectedPackages
{
     <#
    .SYNOPSIS
        Sorts given packages based on installer preference and availability.

    .OUTPUTS
        Hashtable. Key = Package Manager, Value = ArrayList of packages to install
    #>
    param (
        [Parameter(Mandatory=$true)]
        $PackageList,
        [Parameter(Mandatory=$true)]
        [PackageManagers]$Preference
    )

    if ($PackageList.count -eq 1) {
        $sync.form.Dispatcher.Invoke([action]{ Set-WinUtilTaskbaritem -state "Indeterminate" -value 0.01 -overlay "logo" })
    } else {
        $sync.form.Dispatcher.Invoke([action]{ Set-WinUtilTaskbaritem -state "Normal" -value 0.01 -overlay "logo" })
    }

    $packages = [System.Collections.Hashtable]::new()
    $packagesWinget = [System.Collections.ArrayList]::new()
    $packagesChoco = [System.Collections.ArrayList]::new()
    $packages[[PackageManagers]::Winget] = $packagesWinget
    $packages[[PackageManagers]::Choco] = $packagesChoco

    Write-Debug "Checking packages using Preference '$($Preference)'"

    foreach ($package in $PackageList) {
        # Skip packages that have no package manager support (custom/manual installs)
        $hasWinget = $package.winget -and $package.winget -ne 'na'
        $hasChoco  = $package.choco  -and $package.choco  -ne 'na'

        if (-not $hasWinget -and -not $hasChoco) {
            Write-Debug "$($package.content) has no winget or choco value — skipping (handled by custom installer)."
            continue
        }

        switch ($Preference) {
            "Choco" {
                if ($hasChoco) {
                    $null = $packagesChoco.add($package.choco)
                    Write-Host "Queueing $($package.choco) for Chocolatey"
                } elseif ($hasWinget) {
                    Write-Debug "$($package.content) has no Choco value, falling back to Winget."
                    $null = $packagesWinget.add($($package.winget))
                    Write-Host "Queueing $($package.winget) for Winget"
                }
                break
            }
            "Winget" {
                if ($hasWinget) {
                    $null = $packagesWinget.add($($package.winget))
                    Write-Host "Queueing $($package.winget) for Winget"
                } elseif ($hasChoco) {
                    Write-Debug "$($package.content) has no Winget value, falling back to Choco."
                    $null = $packagesChoco.add($package.choco)
                    Write-Host "Queueing $($package.choco) for Chocolatey"
                }
                break
            }
        }
    }

    return $packages
}
