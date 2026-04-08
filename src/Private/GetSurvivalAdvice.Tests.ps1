BeforeAll {
    $privatePath = $PSCommandPath -replace 'src[/\\]Private[/\\]GetSurvivalAdvice\.Tests\.ps1$', 'src/Private/'
    . (Join-Path $privatePath 'GetSurvivalAdvice.ps1')
}

Describe 'GetSurvivalAdvice' {

    Context 'Parameter validation' {
        It 'Should throw when Intensity is below 0' {
            $station = [PSCustomObject]@{ windspeed = 3.0 }
            { GetSurvivalAdvice -Intensity -1 -Station $station } | Should -Throw
        }

        It 'Should throw when Intensity is above 255' {
            $station = [PSCustomObject]@{ windspeed = 3.0 }
            { GetSurvivalAdvice -Intensity 256 -Station $station } | Should -Throw
        }

        It 'Should throw when Station is null' {
            { GetSurvivalAdvice -Intensity 0 -Station $null } | Should -Throw
        }
    }

    Context 'Survival advice based on intensity' {
        BeforeAll {
            $calmStation = [PSCustomObject]@{ windspeed = 2.0 }
        }

        It 'Should include no-rain message when Intensity is 0' {
            $result = GetSurvivalAdvice -Intensity 0 -Station $calmStation
            $result | Should -Match "not raining"
        }

        It 'Should include drizzle message for Intensity 50' {
            $result = GetSurvivalAdvice -Intensity 50 -Station $calmStation
            $result | Should -Match 'drizzle'
        }

        It 'Should include umbrella message for Intensity 100' {
            $result = GetSurvivalAdvice -Intensity 100 -Station $calmStation
            $result | Should -Match 'umbrella'
        }

        It 'Should include moderate rain message for Intensity 120' {
            $result = GetSurvivalAdvice -Intensity 120 -Station $calmStation
            $result | Should -Match 'Moderate rain'
        }

        It 'Should include SURVIVAL MODE message for Intensity 200' {
            $result = GetSurvivalAdvice -Intensity 200 -Station $calmStation
            $result | Should -Match 'SURVIVAL MODE'
        }
    }

    Context 'Wind speed commentary' {
        It 'Should include wind warning when windspeed is 10 or above' {
            $windyStation = [PSCustomObject]@{ windspeed = 12.0 }
            $result = GetSurvivalAdvice -Intensity 0 -Station $windyStation
            $result | Should -Match 'Wind is strong'
        }

        It 'Should include breezy comment when windspeed is between 7 and 9' {
            $breezeyStation = [PSCustomObject]@{ windspeed = 8.0 }
            $result = GetSurvivalAdvice -Intensity 0 -Station $breezeyStation
            $result | Should -Match 'breezy'
        }

        It 'Should not include wind warning for calm conditions' {
            $calmStation = [PSCustomObject]@{ windspeed = 3.0 }
            $result = GetSurvivalAdvice -Intensity 0 -Station $calmStation
            $result | Should -Not -Match 'Wind is strong'
            $result | Should -Not -Match 'breezy'
        }

        It 'Should handle missing windspeed gracefully' {
            $noWindStation = [PSCustomObject]@{ stationname = 'Test' }
            { GetSurvivalAdvice -Intensity 0 -Station $noWindStation } | Should -Not -Throw
        }
    }

    Context 'Return type' {
        It 'Should return a string' {
            $station = [PSCustomObject]@{ windspeed = 2.0 }
            $result = GetSurvivalAdvice -Intensity 0 -Station $station
            $result | Should -BeOfType [string]
        }
    }
}
