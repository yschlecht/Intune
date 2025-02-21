<#
.SYNOPSIS
  This script exports enrolled devices in a specific time period
.DESCRIPTION
  This script exports which devices (Windows, iOS, Android and macOS) were newly enrolled in a timeframe X days before today. It exports multiple attriubtes to provide more insights.

.NOTES
  Version:        1.0
  Author:         Yannick Schlecht
  Creation Date:  21.02.2025
  Purpose/Change: Initial script development

.EXAMPLE
  Intune_Get_All_Devices_ByEnrollmentDate.ps1
#>

#----------------------------------------------------------[Declarations]----------------------------------------------------------

$Runtime = Get-Date -Format "yyyyMMdd-HHmmss"
$logFile = "EnrolledDevices-$($Runtime).csv"
$logFolder = "C:\Temp\export"
$logFilePathCSV = Join-Path -Path $LogFolder -ChildPath $logFile
$daysBefore = -60

#-----------------------------------------------------------[Execution]------------------------------------------------------------

# Authenticate and connect to Microsoft Graph
Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All"

# Define the filter for devices enrolled in the last 30 days
$filter = "enrolledDateTime ge " + (Get-Date).AddDays($daysBefore).ToString("yyyy-MM-ddTHH:mm:ssZ")

# Query the managed devices with the additional properties
$devices = Get-MgDeviceManagementManagedDevice -Filter $filter -Select "id,deviceName,operatingSystem,enrolledDateTime,userPrincipalName,model,complianceState,deviceEnrollmentType,lastSyncDateTime,managedDeviceOwnerType,manufacturer,osVersion"

# Convert the results to a custom object with formatted enrolledDateTime
$formattedDevices = $devices | ForEach-Object {
    [PSCustomObject]@{
        id                     = $_.id
        deviceName             = $_.deviceName
        operatingSystem        = $_.operatingSystem
        enrolledDateTime       = (Get-Date $_.enrolledDateTime).ToString("yyyy-MM-dd HH:mm:ss")
        userPrincipalName      = $_.userPrincipalName
        model                  = $_.model
        complianceState        = $_.complianceState
        deviceEnrollmentType   = $_.deviceEnrollmentType
        lastSyncDateTime       = (Get-Date $_.lastSyncDateTime).ToString("yyyy-MM-dd HH:mm:ss")
        managedDeviceOwnerType = $_.managedDeviceOwnerType
        manufacturer           = $_.manufacturer
        osVersion              = $_.osVersion
    }
}

# Export as CSV file
try {
    # Check if the folder exists
    if (-Not (Test-Path -Path $logFolder)) {
        # Create the folder if it doesn't exist
        New-Item -ItemType Directory -Path $logFolder -ErrorAction Stop
    }

    # Export the CSV file
    $formattedDevices | Export-Csv -Path $logFilePathCSV -NoTypeInformation
} catch {
    Write-Error "An error occurred: $_"
}