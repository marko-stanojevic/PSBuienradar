BeforeAll {
    $scriptPath = $PSCommandPath -replace '\.Tests\.ps1$', '.ps1'
    . $scriptPath
}

Describe 'Get-PublicIP' {

    Context 'Successful IP retrieval' {
        BeforeAll {
            Mock Invoke-RestMethod {
                return [PSCustomObject]@{ ip = '203.0.113.42' }
            }
        }

        It 'Should return the IP address as a string' {
            $result = Get-PublicIP
            $result | Should -Be '203.0.113.42'
        }

        It 'Should return a string type' {
            $result = Get-PublicIP
            $result | Should -BeOfType [string]
        }

        It 'Should call ipify.org endpoint' {
            Get-PublicIP
            Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -like '*ipify.org*'
            }
        }
    }

    Context 'Empty response handling' {
        BeforeAll {
            Mock Invoke-RestMethod {
                return [PSCustomObject]@{ ip = '' }
            }
        }

        It 'Should throw when the API returns an empty IP' {
            { Get-PublicIP } | Should -Throw
        }
    }

    Context 'Network error handling' {
        BeforeAll {
            Mock Invoke-RestMethod {
                throw 'Network error'
            }
        }

        It 'Should throw when the API call fails' {
            { Get-PublicIP } | Should -Throw
        }
    }
}
