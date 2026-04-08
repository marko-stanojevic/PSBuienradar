BeforeAll {
    $privatePath = $PSCommandPath -replace 'src[/\\]Public[/\\]Get-RainForecast\.Tests\.ps1$', 'src/Private/'
    . (Join-Path $privatePath 'ConvertRainIntensity.ps1')

    $scriptPath = $PSCommandPath -replace '\.Tests\.ps1$', '.ps1'
    . $scriptPath
}

Describe 'Get-RainForecast' {

    Context 'Parameter validation' {
        It 'Should throw when Latitude is out of range' {
            { Get-RainForecast -Latitude 91 -Longitude 4.90 } | Should -Throw
        }

        It 'Should throw when Longitude is out of range' {
            { Get-RainForecast -Latitude 52.37 -Longitude 181 } | Should -Throw
        }
    }

    Context 'Successful forecast retrieval' {
        BeforeAll {
            Mock Invoke-RestMethod {
                return "000|09:00`n077|09:05`n110|09:10`n200|09:15`n"
            }
        }

        It 'Should return an array of forecast entries' {
            $result = Get-RainForecast -Latitude 52.37 -Longitude 4.90
            @($result).Count | Should -Be 4
        }

        It 'Should parse the Time field correctly' {
            $result = Get-RainForecast -Latitude 52.37 -Longitude 4.90
            @($result)[0].Time | Should -Be '09:00'
        }

        It 'Should parse the Intensity field correctly' {
            $result = Get-RainForecast -Latitude 52.37 -Longitude 4.90
            @($result)[0].Intensity | Should -Be 0
        }

        It 'Should include a Description for each entry' {
            $result = Get-RainForecast -Latitude 52.37 -Longitude 4.90
            @($result)[0].Description | Should -Not -BeNullOrEmpty
        }

        It 'Should assign no rain description for intensity 0' {
            $result = Get-RainForecast -Latitude 52.37 -Longitude 4.90
            @($result)[0].Description | Should -Match 'No rain'
        }

        It 'Should call the BuienRadar gpsgadget endpoint' {
            Get-RainForecast -Latitude 52.37 -Longitude 4.90
            Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -like '*gpsgadget.buienradar.nl*'
            }
        }

        It 'Should format coordinates with a decimal point not comma' {
            Get-RainForecast -Latitude 52.37 -Longitude 4.90
            Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -like '*lat=52.37*' -and $Uri -like '*lon=4.90*'
            }
        }
    }

    Context 'Empty response handling' {
        BeforeAll {
            Mock Invoke-RestMethod {
                return ''
            }
        }

        It 'Should throw when the API returns an empty response' {
            { Get-RainForecast -Latitude 52.37 -Longitude 4.90 } | Should -Throw
        }
    }

    Context 'Network error handling' {
        BeforeAll {
            Mock Invoke-RestMethod {
                throw 'Network error'
            }
        }

        It 'Should throw when the API call fails' {
            { Get-RainForecast -Latitude 52.37 -Longitude 4.90 } | Should -Throw
        }
    }
}
