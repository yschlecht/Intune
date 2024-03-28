try {
    # Set the registry value to show file extensions
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Value 0 -ErrorAction Stop
} catch {
    Write-Error -Message "Could not set registry value" -Category OperationStopped
    exit 1
}
