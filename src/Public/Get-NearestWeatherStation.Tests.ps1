BeforeAll {
    $privatePath = $PSCommandPath -replace 'src[/\\]Public[/\\]Get-NearestWeatherStation\.Tests\.ps1$', 'src/Private/'
    . (Join-Path $privatePath 'GetDistanceBetweenCoordinates.ps1')

    $scriptPath = $PSCommandPath -replace '\.Tests\.ps1$', '.ps1'
    . $scriptPath
}

Describe 'Get-NearestWeatherStation' {

    Context 'Parameter validation' {
        It 'Should throw when Latitude is out of range' {
            { Get-NearestWeatherStation -Latitude 91 -Longitude 4.90 -Stations @([PSCustomObject]@{ lat = 52; lon = 4 }) } | Should -Throw
        }

        It 'Should throw when Longitude is out of range' {
            { Get-NearestWeatherStation -Latitude 52.37 -Longitude 181 -Stations @([PSCustomObject]@{ lat = 52; lon = 4 }) } | Should -Throw
        }

        It 'Should throw when Stations is empty' {
            { Get-NearestWeatherStation -Latitude 52.37 -Longitude 4.90 -Stations @() } | Should -Throw
        }
    }

    Context 'Station selection' {
        BeforeAll {
            $testStations = @(
                [PSCustomObject]@{ stationname = 'Amsterdam Schiphol'; lat = 52.31; lon = 4.79 }
                [PSCustomObject]@{ stationname = 'Rotterdam Airport'; lat = 51.96; lon = 4.45 }
                [PSCustomObject]@{ stationname = 'De Bilt'; lat = 52.10; lon = 5.18 }
            )
        }

        It 'Should return the nearest station to Amsterdam' {
            $result = Get-NearestWeatherStation -Latitude 52.37 -Longitude 4.90 -Stations $testStations
            $result.stationname | Should -Be 'Amsterdam Schiphol'
        }

        It 'Should return the nearest station to Rotterdam' {
            $result = Get-NearestWeatherStation -Latitude 51.92 -Longitude 4.48 -Stations $testStations
            $result.stationname | Should -Be 'Rotterdam Airport'
        }

        It 'Should return a PSCustomObject' {
            $result = Get-NearestWeatherStation -Latitude 52.37 -Longitude 4.90 -Stations $testStations
            $result | Should -BeOfType [PSCustomObject]
        }
    }

    Context 'Stations with missing coordinates' {
        It 'Should skip stations with null coordinates and find the valid nearest' {
            $stations = @(
                [PSCustomObject]@{ stationname = 'No Coords'; lat = $null; lon = $null }
                [PSCustomObject]@{ stationname = 'Amsterdam Schiphol'; lat = 52.31; lon = 4.79 }
            )
            $result = Get-NearestWeatherStation -Latitude 52.37 -Longitude 4.90 -Stations $stations
            $result.stationname | Should -Be 'Amsterdam Schiphol'
        }

        It 'Should throw when all stations have missing coordinates' {
            $stations = @(
                [PSCustomObject]@{ stationname = 'No Coords'; lat = $null; lon = $null }
            )
            { Get-NearestWeatherStation -Latitude 52.37 -Longitude 4.90 -Stations $stations } | Should -Throw
        }
    }
}
