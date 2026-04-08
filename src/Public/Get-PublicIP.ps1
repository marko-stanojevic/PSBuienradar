function Get-PublicIP {
    <#
    .SYNOPSIS
        Returns the current user's public IP address

    .DESCRIPTION
        Queries the ipify.org API to determine the public IP address of the machine
        running this command. Useful as the first step in a geo-location workflow.

    .EXAMPLE
        Get-PublicIP

        Returns the public IP address as a string, e.g. "203.0.113.42".

    .INPUTS
        None

    .OUTPUTS
        System.String

    .NOTES
        Requires internet access to reach https://api.ipify.org.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param ()

    try {
        Write-Verbose "$($MyInvocation.MyCommand): Querying ipify.org for public IP"
        $response = Invoke-RestMethod -Uri 'https://api.ipify.org?format=json' -ErrorAction Stop
        $ip = $response.ip

        if ([string]::IsNullOrWhiteSpace($ip)) {
            throw 'ipify.org returned an empty IP address.'
        }

        Write-Verbose "$($MyInvocation.MyCommand): Detected public IP: $ip"
        return $ip
    } catch {
        Write-Verbose "$($MyInvocation.MyCommand) failed: $_"
        throw $_
    }
}
