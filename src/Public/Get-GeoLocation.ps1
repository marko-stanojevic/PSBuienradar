function Get-GeoLocation {
    <#
    .SYNOPSIS
        Converts a public IP address to geographic coordinates and city name

    .DESCRIPTION
        Uses the ip-api.com free GeoIP API to resolve an IP address to
        latitude, longitude, and city name. The result is used to find
        nearby BuienRadar weather stations and fetch rain forecasts.

    .PARAMETER IP
        The public IP address to look up. Accepts IPv4 addresses.

    .EXAMPLE
        Get-GeoLocation -IP '203.0.113.42'

        Returns a PSCustomObject with Latitude, Longitude, and City.

    .EXAMPLE
        Get-PublicIP | Get-GeoLocation

        Chains public-IP detection with geo-location lookup.

    .INPUTS
        System.String

    .OUTPUTS
        PSCustomObject

    .NOTES
        Uses http://ip-api.com/json/{ip}. The free tier supports up to
        45 requests per minute from the same IP address.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [string]
        $IP
    )

    process {
        try {
            Write-Verbose "$($MyInvocation.MyCommand): Looking up geo-location for IP: $IP"
            $uri = "http://ip-api.com/json/$IP"
            $response = Invoke-RestMethod -Uri $uri -ErrorAction Stop

            if ($response.status -ne 'success') {
                throw "Geo-location lookup failed for '$IP': $($response.message)"
            }

            $location = [PSCustomObject]@{
                IP        = $IP
                Latitude  = [double]$response.lat
                Longitude = [double]$response.lon
                City      = $response.city
                Country   = $response.country
            }
            $location.PSObject.TypeNames.Insert(0, 'BuienRadar.GeoLocation')

            Write-Verbose "$($MyInvocation.MyCommand): Resolved to $($location.City), Lat=$($location.Latitude), Lon=$($location.Longitude)"
            return $location
        } catch {
            Write-Verbose "$($MyInvocation.MyCommand) failed for '$IP': $_"
            throw $_
        }
    }
}
