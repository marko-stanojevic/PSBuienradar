function Get-WeatherSurvivalAdvice {
    <#
    .SYNOPSIS
        Returns a humorous Dutch weather survival report for your current location

    .DESCRIPTION
        Orchestrates the full BuienRadar weather survival pipeline:
            1. Detects the user's public IP address
            2. Resolves the IP to geographic coordinates and city name
            3. Fetches the two-hour rain forecast from BuienRadar
            4. Downloads the BuienRadar weather feed and finds the nearest station
            5. Assembles a custom PSCustomObject with weather data and survival advice

        Survival advice is generated based on current conditions:
            - Heavy rain    -> urgent evacuation humour
            - Moderate rain -> umbrella reminders
            - Light rain    -> mild caution
            - No rain       -> cautiously optimistic encouragement

    .EXAMPLE
        Get-WeatherSurvivalAdvice

        Detects location automatically and returns the survival report.

    .EXAMPLE
        $report = Get-WeatherSurvivalAdvice
        $report.SurvivalAdvice

        Retrieves only the survival advice text.

    .INPUTS
        None

    .OUTPUTS
        PSCustomObject

    .NOTES
        Requires internet access to the following endpoints:
            - https://api.ipify.org
            - http://ip-api.com
            - https://gpsgadget.buienradar.nl
            - https://data.buienradar.nl
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param ()

    try {
        Write-Verbose "$($MyInvocation.MyCommand): Starting Dutch weather survival assessment"

        # Step 1: Public IP
        Write-Verbose "$($MyInvocation.MyCommand): Step 1 - Detecting public IP"
        $publicIP = Get-PublicIP

        # Step 2: Geo-location
        Write-Verbose "$($MyInvocation.MyCommand): Step 2 - Resolving geo-location for $publicIP"
        $geoLocation = Get-GeoLocation -IP $publicIP

        # Step 3: Rain forecast
        Write-Verbose "$($MyInvocation.MyCommand): Step 3 - Fetching rain forecast"
        $rainForecast = Get-RainForecast -Latitude $geoLocation.Latitude -Longitude $geoLocation.Longitude

        # Step 4: Nearest weather station
        Write-Verbose "$($MyInvocation.MyCommand): Step 4 - Fetching BuienRadar weather feed"
        $feed = Invoke-RestMethod -Uri 'https://data.buienradar.nl/2.0/feed/json' -ErrorAction Stop
        $nearestStation = Get-NearestWeatherStation `
            -Latitude $geoLocation.Latitude `
            -Longitude $geoLocation.Longitude `
            -Stations $feed.actual.stationmeasurements

        # Step 5: Determine current rain severity from first non-null forecast entry
        $currentIntensity = if ($null -ne $rainForecast -and @($rainForecast).Count -gt 0) {
            @($rainForecast)[0].Intensity
        } else {
            0
        }

        $survivalAdvice = GetSurvivalAdvice -Intensity $currentIntensity -Station $nearestStation

        # Step 6: Build report
        $report = [PSCustomObject]@{
            Location        = "$($geoLocation.City), $($geoLocation.Country)"
            Latitude        = $geoLocation.Latitude
            Longitude       = $geoLocation.Longitude
            StationName     = $nearestStation.stationname
            Temperature     = $nearestStation.temperature
            WindSpeed       = $nearestStation.windspeed
            WindDirection   = $nearestStation.winddirection
            Humidity        = $nearestStation.humidity
            RainForecast    = $rainForecast
            CurrentRain     = if ($null -ne $rainForecast -and @($rainForecast).Count -gt 0) {
                @($rainForecast)[0].Description
            } else {
                'No rain data available'
            }
            SurvivalAdvice  = $survivalAdvice
        }
        $report.PSObject.TypeNames.Insert(0, 'BuienRadar.SurvivalReport')

        Write-Verbose "$($MyInvocation.MyCommand): Survival report assembled for $($report.Location)"
        return $report
    } catch {
        Write-Verbose "$($MyInvocation.MyCommand) failed: $_"
        throw $_
    }
}
