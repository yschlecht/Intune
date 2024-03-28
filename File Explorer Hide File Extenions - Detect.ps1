# Define the registry key path and value name
$registryKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$registryValueName = "HideFileExt"

# Check if the registry key exists
if (Test-Path -Path $registryKey) {
    # Get the value of the specified registry value
    $value = Get-ItemProperty -Path $registryKey -Name $registryValueName

    # Check value (0 = false, 1 = true)
    if ($value -and $value.$registryValueName -eq 0) {
        Write-Host "File Explorer is set to show file extensions."
        exit 0
    } else {
        Write-Host "File Explorer is set to hide file extensions."
        exit 1
    }
} else {
    Write-Host "The registry key '$registryKey' does not exist."
    exit 1
}
