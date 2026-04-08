function Get-RainForecast {
    <#
    .SYNOPSIS
        Retrieves the rain forecast for the next two hours from BuienRadar

    .DESCRIPTION
        Queries the BuienRadar gpsgadget rain-text endpoint for the given
        latitude and longitude and parses the response into a collection of
        time-stamped rain intensity objects.

        Each forecast entry contains:
            - Time        : The forecast time (HH:mm)
            - Intensity   : Raw BuienRadar rain value (0-255)
            - Description : Human-friendly rain description with emoji

        The rain intensity scale is roughly logarithmic:
            0        = No rain
            1-77     = Very light rain (drizzle)
            78-109   = Light rain
            110-140  = Moderate rain
            141-255  = Heavy rain (SURVIVAL MODE)

    .PARAMETER Latitude
        The latitude of the location to fetch the rain forecast for.

    .PARAMETER Longitude
        The longitude of the location to fetch the rain forecast for.

    .EXAMPLE
        Get-RainForecast -Latitude 52.37 -Longitude 4.90

        Returns the next two-hour rain forecast for Amsterdam.

    .INPUTS
        None

    .OUTPUTS
        PSCustomObject[]

    .NOTES
        Uses https://gpsgadget.buienradar.nl/data/raintext?lat={lat}&lon={lon}.
        Data is updated approximately every 5 minutes.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param (
        [Parameter(Mandatory)]
        [ValidateRange(-90.0, 90.0)]
        [double]
        $Latitude,

        [Parameter(Mandatory)]
        [ValidateRange(-180.0, 180.0)]
        [double]
        $Longitude
    )

    try {
        $lat = [string]::Format([System.Globalization.CultureInfo]::InvariantCulture, '{0:F2}', $Latitude)
        $lon = [string]::Format([System.Globalization.CultureInfo]::InvariantCulture, '{0:F2}', $Longitude)
        $uri = "https://gpsgadget.buienradar.nl/data/raintext?lat=$lat&lon=$lon"

        Write-Verbose "$($MyInvocation.MyCommand): Fetching rain forecast from $uri"
        $raw = Invoke-RestMethod -Uri $uri -ErrorAction Stop

        if ([string]::IsNullOrWhiteSpace($raw)) {
            throw 'BuienRadar returned an empty rain forecast response.'
        }

        $lines = $raw -split "`n" | Where-Object { $_ -match '\S' }
        $forecast = foreach ($line in $lines) {
            $parts = $line.Trim() -split '\|'
            if ($parts.Count -ne 2) {
                Write-Verbose "$($MyInvocation.MyCommand): Skipping malformed line: $line"
                continue
            }

            $intensityValue = [int]$parts[0]
            $entry = [PSCustomObject]@{
                Time        = $parts[1].Trim()
                Intensity   = $intensityValue
                Description = ConvertRainIntensity -Value $intensityValue
            }
            $entry.PSObject.TypeNames.Insert(0, 'BuienRadar.RainForecastEntry')
            $entry
        }

        Write-Verbose "$($MyInvocation.MyCommand): Parsed $(@($forecast).Count) forecast entries"
        return $forecast
    } catch {
        Write-Verbose "$($MyInvocation.MyCommand) failed for Lat=$Latitude, Lon=${Longitude}: $_"
        throw $_
    }
}
