---
document type: cmdlet
external help file: PSBuienradar-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSBuienradar
ms.date: 04/09/2026
PlatyPS schema version: 2024-05-01
title: Get-GeoLocation
---

# Get-GeoLocation

## SYNOPSIS

Converts a public IP address to geographic coordinates and city name

## SYNTAX

### __AllParameterSets

```
Get-GeoLocation [-IP] <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Uses the ip-api.com free GeoIP API to resolve an IP address to
latitude, longitude, and city name.
The result is used to find
nearby BuienRadar weather stations and fetch rain forecasts.

## EXAMPLES

### EXAMPLE 1

Get-GeoLocation -IP '203.0.113.42'

Returns a PSCustomObject with Latitude, Longitude, and City.

### EXAMPLE 2

Get-PublicIP | Get-GeoLocation

Chains public-IP detection with geo-location lookup.

## PARAMETERS

### -IP

The public IP address to look up.
Accepts IPv4 addresses.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

{{ Fill in the Description }}

## OUTPUTS

### PSCustomObject

{{ Fill in the Description }}

### System.Management.Automation.PSObject

{{ Fill in the Description }}

## NOTES

Uses http://ip-api.com/json/{ip}.
The free tier supports up to
45 requests per minute from the same IP address.


## RELATED LINKS

{{ Fill in the related links here }}

