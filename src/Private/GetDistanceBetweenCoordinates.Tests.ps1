BeforeAll {
    $scriptPath = $PSCommandPath -replace '\.Tests\.ps1$', '.ps1'
    . $scriptPath
}

Describe 'GetDistanceBetweenCoordinates' {

    Context 'Parameter validation' {
        It 'Should throw when Latitude1 is out of range' {
            { GetDistanceBetweenCoordinates -Latitude1 91 -Longitude1 0 -Latitude2 0 -Longitude2 0 } | Should -Throw
        }

        It 'Should throw when Latitude2 is out of range' {
            { GetDistanceBetweenCoordinates -Latitude1 0 -Longitude1 0 -Latitude2 -91 -Longitude2 0 } | Should -Throw
        }

        It 'Should throw when Longitude1 is out of range' {
            { GetDistanceBetweenCoordinates -Latitude1 0 -Longitude1 181 -Latitude2 0 -Longitude2 0 } | Should -Throw
        }

        It 'Should throw when Longitude2 is out of range' {
            { GetDistanceBetweenCoordinates -Latitude1 0 -Longitude1 0 -Latitude2 0 -Longitude2 -181 } | Should -Throw
        }
    }

    Context 'Distance calculations' {
        It 'Should return 0 for identical coordinates' {
            $result = GetDistanceBetweenCoordinates -Latitude1 52.37 -Longitude1 4.90 -Latitude2 52.37 -Longitude2 4.90
            $result | Should -BeExactly 0.0
        }

        It 'Should return a positive distance for different coordinates' {
            $result = GetDistanceBetweenCoordinates -Latitude1 52.37 -Longitude1 4.90 -Latitude2 51.92 -Longitude2 4.48
            $result | Should -BeGreaterThan 0
        }

        It 'Should calculate Amsterdam to Rotterdam as approximately 57 km' {
            $result = GetDistanceBetweenCoordinates -Latitude1 52.37 -Longitude1 4.90 -Latitude2 51.92 -Longitude2 4.48
            $result | Should -BeGreaterThan 50
            $result | Should -BeLessThan 65
        }

        It 'Should return a double' {
            $result = GetDistanceBetweenCoordinates -Latitude1 0 -Longitude1 0 -Latitude2 1 -Longitude2 1
            $result | Should -BeOfType [double]
        }

        It 'Should be symmetric (A to B equals B to A)' {
            $ab = GetDistanceBetweenCoordinates -Latitude1 52.37 -Longitude1 4.90 -Latitude2 51.92 -Longitude2 4.48
            $ba = GetDistanceBetweenCoordinates -Latitude1 51.92 -Longitude1 4.48 -Latitude2 52.37 -Longitude2 4.90
            [Math]::Round($ab, 6) | Should -Be ([Math]::Round($ba, 6))
        }
    }
}
