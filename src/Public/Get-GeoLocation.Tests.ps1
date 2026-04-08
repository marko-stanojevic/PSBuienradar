BeforeAll {
    $scriptPath = $PSCommandPath -replace '\.Tests\.ps1$', '.ps1'
    . $scriptPath
}

Describe 'Get-GeoLocation' {

    Context 'Parameter validation' {
        It 'Should throw when IP is empty' {
            { Get-GeoLocation -IP '' } | Should -Throw
        }

        It 'Should throw when IP is null' {
            { Get-GeoLocation -IP $null } | Should -Throw
        }
    }

    Context 'Successful geo-location lookup' {
        BeforeAll {
            Mock Invoke-RestMethod {
                return [PSCustomObject]@{
                    status  = 'success'
                    lat     = 52.3676
                    lon     = 4.9041
                    city    = 'Amsterdam'
                    country = 'Netherlands'
                }
            }
        }

        It 'Should return a PSCustomObject' {
            $result = Get-GeoLocation -IP '203.0.113.42'
            $result | Should -BeOfType [PSCustomObject]
        }

        It 'Should include Latitude' {
            $result = Get-GeoLocation -IP '203.0.113.42'
            $result.Latitude | Should -Be 52.3676
        }

        It 'Should include Longitude' {
            $result = Get-GeoLocation -IP '203.0.113.42'
            $result.Longitude | Should -Be 4.9041
        }

        It 'Should include City' {
            $result = Get-GeoLocation -IP '203.0.113.42'
            $result.City | Should -Be 'Amsterdam'
        }

        It 'Should include Country' {
            $result = Get-GeoLocation -IP '203.0.113.42'
            $result.Country | Should -Be 'Netherlands'
        }

        It 'Should include the original IP' {
            $result = Get-GeoLocation -IP '203.0.113.42'
            $result.IP | Should -Be '203.0.113.42'
        }

        It 'Should call the ip-api endpoint with the IP address' {
            Get-GeoLocation -IP '203.0.113.42'
            Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -like '*ip-api.com*203.0.113.42*'
            }
        }
    }

    Context 'Failed lookup' {
        BeforeAll {
            Mock Invoke-RestMethod {
                return [PSCustomObject]@{
                    status  = 'fail'
                    message = 'private range'
                }
            }
        }

        It 'Should throw when the API returns a failure status' {
            { Get-GeoLocation -IP '192.168.1.1' } | Should -Throw
        }
    }

    Context 'Pipeline input' {
        BeforeAll {
            Mock Invoke-RestMethod {
                return [PSCustomObject]@{
                    status  = 'success'
                    lat     = 52.3676
                    lon     = 4.9041
                    city    = 'Amsterdam'
                    country = 'Netherlands'
                }
            }
        }

        It 'Should accept IP via pipeline' {
            $result = '203.0.113.42' | Get-GeoLocation
            $result | Should -Not -BeNullOrEmpty
        }
    }
}
