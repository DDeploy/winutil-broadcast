function Install-WinUtilProgramVmix {
    <#
    .SYNOPSIS
        Installs or uninstalls vMix using a custom workflow.

    .PARAMETER Action
        'Install' or 'Uninstall'
    #>
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Install', 'Uninstall')]
        [string]$Action
    )

    $vmixUrl = 'https://www.vmix.com/download/vmix29.exe'
    $installerPath = Join-Path $env:TEMP 'vmix-setup.exe'

    if ($Action -eq 'Install') {
        Write-Host 'Downloading vMix installer...'
        Invoke-WebRequest -Uri $vmixUrl -OutFile $installerPath -UseBasicParsing

        Write-Host 'Running vMix installer silently...'
        # NOTE: Adjust arguments if vMix uses different silent switches
        $proc = Start-Process -FilePath $installerPath -ArgumentList '/SILENT' -Wait -PassThru
        if ($proc.ExitCode -eq 0) {
            Write-Host 'vMix installed/updated successfully.'
        }
        else {
            Write-Warning "vMix installer exited with code $($proc.ExitCode)."
        }
    }
    else {
        Write-Host 'Attempting to uninstall vMix...'

        try {
            $product = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like 'vMix*' }
            if ($null -ne $product) {
                $proc = Start-Process -FilePath 'msiexec.exe' -ArgumentList "/x $($product.IdentifyingNumber) /qn" -Wait -PassThru
                if ($proc.ExitCode -eq 0) {
                    Write-Host 'vMix uninstalled successfully.'
                }
                else {
                    Write-Warning "Failed to uninstall vMix, exit code $($proc.ExitCode)."
                }
            }
            else {
                Write-Warning 'vMix is not installed (nothing to uninstall).'
            }
        }
        catch {
            Write-Warning "Error while trying to uninstall vMix: $_"
        }
    }
}
function Install-WinUtilProgramVmix {
    <#
    .SYNOPSIS
        Installs or updates vMix using a custom workflow.
    .PARAMETER Action
        'Install' or 'Uninstall'
    #>
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Install', 'Uninstall')]
        [string]$Action
    )

    $vmixUrl = 'https://www.vmix.com/download/vmix29.exe'  # adjust to the actual latest URL
    $installerPath = Join-Path $env:TEMP 'vmix-setup.exe'

    if ($Action -eq 'Install') {
        Write-Host 'Downloading vMix installer...'
        Invoke-WebRequest -Uri $vmixUrl -OutFile $installerPath -UseBasicParsing

        Write-Host 'Running vMix installer silently...'
        # TODO: adjust arguments to the correct silent switches for vMix
        $proc = Start-Process -FilePath $installerPath -ArgumentList '/SILENT' -Wait -PassThru
        if ($proc.ExitCode -eq 0) {
            Write-Host 'vMix installed/updated successfully.'
        } else {
            Write-Warning "vMix installer exited with code $($proc.ExitCode)."
        }
    } else {
        Write-Host 'Uninstalling vMix...'
        # Example: try MSI/product-code or DisplayName; adjust to how vMix registers itself
        $product = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like 'vMix*' }
        if ($null -ne $product) {
            $proc = Start-Process -FilePath 'msiexec.exe' -ArgumentList "/x $($product.IdentifyingNumber) /qn" -Wait -PassThru
            if ($proc.ExitCode -eq 0) {
                Write-Host 'vMix uninstalled successfully.'
            } else {
                Write-Warning "Failed to uninstall vMix, exit code $($proc.ExitCode)."
            }
        } else {
            Write-Warning 'vMix is not installed (nothing to uninstall).'
        }
    }
}
