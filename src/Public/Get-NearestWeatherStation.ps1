function Get-NearestWeatherStation {
    <#
    .SYNOPSIS
        Finds the nearest BuienRadar weather station to the given coordinates

    .DESCRIPTION
        Accepts an array of BuienRadar station measurement objects (as returned
        by the /2.0/feed/json endpoint) and returns the station closest to the
        supplied latitude and longitude, calculated using the Haversine formula.

    .PARAMETER Latitude
        The latitude of the reference point in decimal degrees.

    .PARAMETER Longitude
        The longitude of the reference point in decimal degrees.

    .PARAMETER Stations
        An array of BuienRadar station measurement objects. Each object must
        expose at least a 'lat' and 'lon' property. Typically sourced from
        the 'actual.stationmeasurements' array of the BuienRadar JSON feed.

    .EXAMPLE
        $feed = Invoke-RestMethod -Uri 'https://data.buienradar.nl/2.0/feed/json'
        Get-NearestWeatherStation -Latitude 52.37 -Longitude 4.90 -Stations $feed.actual.stationmeasurements

        Returns the weather station closest to Amsterdam.

    .INPUTS
        None

    .OUTPUTS
        PSCustomObject

    .NOTES
        Requires BuienRadar station objects with 'lat' and 'lon' properties.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory)]
        [ValidateRange(-90.0, 90.0)]
        [double]
        $Latitude,

        [Parameter(Mandatory)]
        [ValidateRange(-180.0, 180.0)]
        [double]
        $Longitude,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [object[]]
        $Stations
    )

    try {
        Write-Verbose "$($MyInvocation.MyCommand): Finding nearest station to Lat=$Latitude, Lon=$Longitude from $($Stations.Count) stations"

        $nearest = $null
        $shortestDistance = [double]::MaxValue

        foreach ($station in $Stations) {
            if ($null -eq $station.lat -or $null -eq $station.lon) {
                Write-Verbose "$($MyInvocation.MyCommand): Skipping station with missing coordinates: $($station.stationname)"
                continue
            }

            $distance = GetDistanceBetweenCoordinates `
                -Latitude1 $Latitude `
                -Longitude1 $Longitude `
                -Latitude2 ([double]$station.lat) `
                -Longitude2 ([double]$station.lon)

            if ($distance -lt $shortestDistance) {
                $shortestDistance = $distance
                $nearest = $station
            }
        }

        if ($null -eq $nearest) {
            throw 'No valid weather stations found in the provided data.'
        }

        Write-Verbose "$($MyInvocation.MyCommand): Nearest station is '$($nearest.stationname)' at $([Math]::Round($shortestDistance, 1)) km"
        return $nearest
    } catch {
        Write-Verbose "$($MyInvocation.MyCommand) failed for Lat=$Latitude, Lon=${Longitude}: $_"
        throw $_
    }
}
