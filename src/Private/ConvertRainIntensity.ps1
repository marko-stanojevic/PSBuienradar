function ConvertRainIntensity {
    <#
    .SYNOPSIS
        Converts a BuienRadar rain intensity value to a human-friendly description

    .DESCRIPTION
        Internal helper that maps BuienRadar rain intensity values (0-255) to
        a human-readable text description with survival-oriented humour and emoji.
        The BuienRadar scale is roughly logarithmic:
            0        = No rain
            1-77     = Very light rain (drizzle)
            78-109   = Light rain
            110-140  = Moderate rain
            141-255  = Heavy rain (SURVIVAL MODE)

    .PARAMETER Value
        The rain intensity value as returned by BuienRadar (0-255)

    .EXAMPLE
        ConvertRainIntensity -Value 0
        Returns: "No rain ☀️"

    .EXAMPLE
        ConvertRainIntensity -Value 120
        Returns: "Moderate rain 🌧️"

    .OUTPUTS
        System.String

    .NOTES
        Private function - not exported from module
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [ValidateRange(0, 255)]
        [int]
        $Value
    )

    if ($Value -eq 0) {
        return 'No rain ☀️'
    }

    if ($Value -le 77) {
        return 'Very light rain (drizzle) 🌂'
    }

    if ($Value -le 109) {
        return 'Light rain 🌦️'
    }

    if ($Value -le 140) {
        return 'Moderate rain 🌧️'
    }

    return 'Heavy rain 🌧️ -- SURVIVAL MODE ACTIVATED'
}
