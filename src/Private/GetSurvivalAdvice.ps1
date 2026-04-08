function GetSurvivalAdvice {
    <#
    .SYNOPSIS
        Generates humorous Dutch weather survival advice based on conditions

    .DESCRIPTION
        Internal helper that combines rain intensity and wind speed to produce
        a context-aware, slightly humorous survival tip for the Dutch weather.

    .PARAMETER Intensity
        The current BuienRadar rain intensity value (0-255).

    .PARAMETER Station
        The nearest BuienRadar station measurement object. Used to access
        wind speed for additional survival commentary.

    .EXAMPLE
        GetSurvivalAdvice -Intensity 0 -Station $station
        Returns: "Congratulations, it's not raining (yet). You might survive today."

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
        $Intensity,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [object]
        $Station
    )

    $windSpeed = if ($Station.PSObject.Properties['windspeed'] -and $null -ne $Station.windspeed) { [double]$Station.windspeed } else { 0.0 }
    $windWarning = if ($windSpeed -ge 10.0) {
        " Wind is strong enough to question your life choices ($windSpeed m/s). Hold on to your bicycle."
    } elseif ($windSpeed -ge 7.0) {
        " Also, it's quite breezy -- your umbrella may have other plans."
    } else {
        ''
    }

    $rainAdvice = if ($Intensity -eq 0) {
        "Congratulations, it's not raining (yet). You might survive today."
    } elseif ($Intensity -le 77) {
        'There is some drizzle. Your hair will notice even if you pretend not to.'
    } elseif ($Intensity -le 109) {
        'Take an umbrella. Seriously. This is not a drill.'
    } elseif ($Intensity -le 140) {
        'Moderate rain incoming. The Dutch call this "a bit wet". Outsiders call it "miserable".'
    } else {
        'HEAVY RAIN -- SURVIVAL MODE ACTIVATED. Find higher ground, a stroopwafel, and the will to carry on. 🌧️'
    }

    return "$rainAdvice$windWarning"
}
