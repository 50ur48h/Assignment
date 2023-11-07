function Get-CommonTimeZone {
    [CmdletBinding()]
    param(
        [string]$Name,
        [int]$Offset
    )

    if (-not [string]::IsNullOrEmpty($Name) -and $Offset -ne $null) {
        Write-Host "Please provide only one parameter: 'Name' or 'Offset'."
        return
    }

    if ($Offset -ne 0 -and ($Offset -lt -12 -or $Offset -gt 12)) {
        Write-Error "Offset value should be between -12 and 12."
        return
    }

    $timezone = "https://raw.githubusercontent.com/dmfilipenko/timezones.json/master/timezones.json"

    try {
        $timeZoneData = Invoke-RestMethod -Uri $timezone -UseBasicParsing
    } catch {
        Write-Host "Failed to download time zone data from Github."
    }

    if (-not [string]::IsNullOrEmpty($Name)) {
        $filteredTimeZones = $timeZoneData | Where-Object { $_.utc -like "*$Name*"}
    } elseif ($Offset -ne 0) {
        $filteredTimeZones = $timeZoneData | Where-Object { $_.offset -eq $Offset }
    } else {
        $filteredTimeZones = $timeZoneData
    }

    $filteredTimeZones | FT
}
