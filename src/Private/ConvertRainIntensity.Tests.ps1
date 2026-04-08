BeforeAll {
    $scriptPath = $PSCommandPath -replace '\.Tests\.ps1$', '.ps1'
    . $scriptPath
}

Describe 'ConvertRainIntensity' {

    Context 'Parameter validation' {
        It 'Should throw when Value is below 0' {
            { ConvertRainIntensity -Value -1 } | Should -Throw
        }

        It 'Should throw when Value is above 255' {
            { ConvertRainIntensity -Value 256 } | Should -Throw
        }
    }

    Context 'Rain intensity descriptions' {
        It 'Should return no rain message for Value 0' {
            $result = ConvertRainIntensity -Value 0
            $result | Should -Match 'No rain'
        }

        It 'Should return very light rain message for Value 1' {
            $result = ConvertRainIntensity -Value 1
            $result | Should -Match 'Very light rain'
        }

        It 'Should return very light rain message for Value 77' {
            $result = ConvertRainIntensity -Value 77
            $result | Should -Match 'Very light rain'
        }

        It 'Should return light rain message for Value 78' {
            $result = ConvertRainIntensity -Value 78
            $result | Should -Match 'Light rain'
        }

        It 'Should return light rain message for Value 109' {
            $result = ConvertRainIntensity -Value 109
            $result | Should -Match 'Light rain'
        }

        It 'Should return moderate rain message for Value 110' {
            $result = ConvertRainIntensity -Value 110
            $result | Should -Match 'Moderate rain'
        }

        It 'Should return moderate rain message for Value 140' {
            $result = ConvertRainIntensity -Value 140
            $result | Should -Match 'Moderate rain'
        }

        It 'Should return heavy rain and SURVIVAL MODE message for Value 141' {
            $result = ConvertRainIntensity -Value 141
            $result | Should -Match 'Heavy rain'
            $result | Should -Match 'SURVIVAL MODE'
        }

        It 'Should return heavy rain message for maximum Value 255' {
            $result = ConvertRainIntensity -Value 255
            $result | Should -Match 'Heavy rain'
        }
    }

    Context 'Return type' {
        It 'Should return a string' {
            $result = ConvertRainIntensity -Value 0
            $result | Should -BeOfType [string]
        }
    }
}
