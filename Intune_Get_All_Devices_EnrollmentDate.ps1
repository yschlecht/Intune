# Authenticate and connect to Microsoft Graph
Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All"

# Define the filter for devices enrolled in the last 30 days
$filter = "enrolledDateTime ge " + (Get-Date).AddDays(-30).ToString("yyyy-MM-ddTHH:mm:ssZ")

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


# Export the formatted results to a CSV file
$formattedDevices | Export-Csv -Path "C:\Temp\export\ManagedDevices.csv" -NoTypeInformation
