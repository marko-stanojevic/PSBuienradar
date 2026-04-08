function GetDistanceBetweenCoordinates {
    <#
    .SYNOPSIS
        Calculates the distance between two geographic coordinates

    .DESCRIPTION
        Internal helper that uses the Haversine formula to calculate the
        great-circle distance in kilometres between two latitude/longitude points.

    .PARAMETER Latitude1
        Latitude of the first point in decimal degrees

    .PARAMETER Longitude1
        Longitude of the first point in decimal degrees

    .PARAMETER Latitude2
        Latitude of the second point in decimal degrees

    .PARAMETER Longitude2
        Longitude of the second point in decimal degrees

    .EXAMPLE
        GetDistanceBetweenCoordinates -Latitude1 52.37 -Longitude1 4.90 -Latitude2 51.92 -Longitude2 4.48
        Returns the distance in km between Amsterdam and Rotterdam.

    .OUTPUTS
        System.Double

    .NOTES
        Private function - not exported from module
    #>
    [CmdletBinding()]
    [OutputType([double])]
    param (
        [Parameter(Mandatory)]
        [ValidateRange(-90.0, 90.0)]
        [double]
        $Latitude1,

        [Parameter(Mandatory)]
        [ValidateRange(-180.0, 180.0)]
        [double]
        $Longitude1,

        [Parameter(Mandatory)]
        [ValidateRange(-90.0, 90.0)]
        [double]
        $Latitude2,

        [Parameter(Mandatory)]
        [ValidateRange(-180.0, 180.0)]
        [double]
        $Longitude2
    )

    $earthRadiusKm = 6371.0

    $deltaLat = ($Latitude2 - $Latitude1) * [Math]::PI / 180.0
    $deltaLon = ($Longitude2 - $Longitude1) * [Math]::PI / 180.0

    $lat1Rad = $Latitude1 * [Math]::PI / 180.0
    $lat2Rad = $Latitude2 * [Math]::PI / 180.0

    $a = [Math]::Sin($deltaLat / 2) * [Math]::Sin($deltaLat / 2) +
         [Math]::Cos($lat1Rad) * [Math]::Cos($lat2Rad) *
         [Math]::Sin($deltaLon / 2) * [Math]::Sin($deltaLon / 2)

    $c = 2 * [Math]::Atan2([Math]::Sqrt($a), [Math]::Sqrt(1 - $a))

    return $earthRadiusKm * $c
}
