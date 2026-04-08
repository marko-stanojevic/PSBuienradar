BeforeAll {
    $repoRoot = $PSCommandPath -replace 'src[/\\]Public[/\\]Get-WeatherSurvivalAdvice\.Tests\.ps1$', ''
    $privatePath = Join-Path $repoRoot 'src/Private'
    . (Join-Path $privatePath 'GetDistanceBetweenCoordinates.ps1')
    . (Join-Path $privatePath 'ConvertRainIntensity.ps1')
    . (Join-Path $privatePath 'GetSurvivalAdvice.ps1')

    $publicPath = Join-Path $repoRoot 'src/Public'
    . (Join-Path $publicPath 'Get-PublicIP.ps1')
    . (Join-Path $publicPath 'Get-GeoLocation.ps1')
    . (Join-Path $publicPath 'Get-RainForecast.ps1')
    . (Join-Path $publicPath 'Get-NearestWeatherStation.ps1')

    $scriptPath = $PSCommandPath -replace '\.Tests\.ps1$', '.ps1'
    . $scriptPath
}

Describe 'Get-WeatherSurvivalAdvice' {

    BeforeAll {
        $mockStation = [PSCustomObject]@{
            stationname  = 'Meetstation Amsterdam'
            lat          = 52.31
            lon          = 4.79
            temperature  = 14.5
            windspeed    = 4.2
            winddirection = 'ZW'
            humidity     = 78
        }

        $mockFeed = [PSCustomObject]@{
            actual = [PSCustomObject]@{
                stationmeasurements = @($mockStation)
            }
        }

        Mock Get-PublicIP { return '203.0.113.42' }

        Mock Get-GeoLocation {
            return [PSCustomObject]@{
                IP        = '203.0.113.42'
                Latitude  = 52.3676
                Longitude = 4.9041
                City      = 'Amsterdam'
                Country   = 'Netherlands'
            }
        }

        Mock Get-RainForecast {
            return @(
                [PSCustomObject]@{ Time = '09:00'; Intensity = 0;   Description = 'No rain ☀️' }
                [PSCustomObject]@{ Time = '09:05'; Intensity = 50;  Description = 'Very light rain (drizzle) 🌂' }
            )
        }

        Mock Invoke-RestMethod { return $mockFeed } -ParameterFilter {
            $Uri -like '*data.buienradar.nl*'
        }
    }

    Context 'Successful run' {
        It 'Should return a PSCustomObject' {
            $result = Get-WeatherSurvivalAdvice
            $result | Should -BeOfType [PSCustomObject]
        }

        It 'Should include Location' {
            $result = Get-WeatherSurvivalAdvice
            $result.Location | Should -Be 'Amsterdam, Netherlands'
        }

        It 'Should include StationName' {
            $result = Get-WeatherSurvivalAdvice
            $result.StationName | Should -Be 'Meetstation Amsterdam'
        }

        It 'Should include Temperature' {
            $result = Get-WeatherSurvivalAdvice
            $result.Temperature | Should -Be 14.5
        }

        It 'Should include RainForecast' {
            $result = Get-WeatherSurvivalAdvice
            @($result.RainForecast).Count | Should -Be 2
        }

        It 'Should include CurrentRain' {
            $result = Get-WeatherSurvivalAdvice
            $result.CurrentRain | Should -Be 'No rain ☀️'
        }

        It 'Should include SurvivalAdvice' {
            $result = Get-WeatherSurvivalAdvice
            $result.SurvivalAdvice | Should -Not -BeNullOrEmpty
        }

        It 'Should include Latitude and Longitude' {
            $result = Get-WeatherSurvivalAdvice
            $result.Latitude  | Should -Be 52.3676
            $result.Longitude | Should -Be 4.9041
        }
    }

    Context 'Error propagation' {
        It 'Should throw when Get-PublicIP fails' {
            Mock Get-PublicIP { throw 'IP lookup failed' }
            { Get-WeatherSurvivalAdvice } | Should -Throw
        }

        It 'Should throw when Get-GeoLocation fails' {
            Mock Get-PublicIP { return '203.0.113.42' }
            Mock Get-GeoLocation { throw 'GeoLocation failed' }
            { Get-WeatherSurvivalAdvice } | Should -Throw
        }
    }
}
