# Drive Mapping Cut Over Script
# Written by: Harry Shelton | 2024
#
#Define just the Server Address / Server IP
$ipAddress = "192.168.1.1"

#Ping the IP address
$pingResult = Test-Connection -ComputerName $ipAddress -Count 1 -Quiet

# Check if the ping was successful
if ($pingResult) {
    # If ping is successful, proceed with the rest of the script
    Write-Host "This PC Reached: $ipAddress"

    #Make Sure User does not have File Explorer Open, otherwise script will stall out
    start explorer.exe
    taskkill /f /im explorer.exe

    #\\ Checking if PC has legacy drive attached //
    #Function to find the drive letter for a given network path
    function Get-MappedDriveLetter {
        param (
            [string]$DrivePath
        )

        $networkDrives = net use | Select-String -Pattern "OK"
        foreach ($drive in $networkDrives) {
            if ($drive -match "\\\\LegacySERVER\\Share") {
                $driveInfo = $drive -split "\s+"
                $driveLetter = $driveInfo[1]
                Write-Output $driveLetter
                return
            }
        }

        Write-Output "No drive letter is mapped to $DrivePath"
    }

    #Check which drive letter is mapped to the legacy Share Drive
    $mappedDriveLetter = Get-MappedDriveLetter -DrivePath "\\LegacySERVER\Share"
    Write-Host "The drive letter mapped to the legacy share is: $mappedDriveLetter"

    #Delete the drive with net use
    net use $mappedDriveLetter /delete

    # Add new mappings - This will map using the previously used letter, change to "S:" if you want to use S drive specifically etc
    net use $mappedDriveLetter \\NEWSERVER\NewShare /persistent:yes

    #Force Restart File Explorer to ensure Windows updates the new Drives, as sometimes will get stuck not updating
    start explorer.exe
    taskkill /f /im explorer.exe
    start explorer.exe

    # Run ipconfig /all and output the results for quicker network checking if an issue happens
    Write-Host "Running ipconfig /all"
    ipconfig /all | Write-Host
    
} else {
    # If ping fails, exit the script with an error message
    Write-Error "Process Failed - Unable to reach server at $ipAddress"
    Write-Host "Running ipconfig /all"
    ipconfig /all | Write-Host
    exit 25
}