---
document type: cmdlet
external help file: PSBuienradar-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSBuienradar
ms.date: 04/08/2026
PlatyPS schema version: 2024-05-01
title: Get-RainForecast
---

# Get-RainForecast

## SYNOPSIS

Retrieves the rain forecast for the next two hours from BuienRadar

## SYNTAX

### __AllParameterSets

```
Get-RainForecast [-Latitude] <double> [-Longitude] <double> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Queries the BuienRadar gpsgadget rain-text endpoint for the given
latitude and longitude and parses the response into a collection of
time-stamped rain intensity objects.

Each forecast entry contains:
    - Time        : The forecast time (HH:mm)
    - Intensity   : Raw BuienRadar rain value (0-255)
    - Description : Human-friendly rain description with emoji

The rain intensity scale is roughly logarithmic:
    0        = No rain
    1-77     = Very light rain (drizzle)
    78-109   = Light rain
    110-140  = Moderate rain
    141-255  = Heavy rain (SURVIVAL MODE)

## EXAMPLES

### EXAMPLE 1

Get-RainForecast -Latitude 52.37 -Longitude 4.90

Returns the next two-hour rain forecast for Amsterdam.

## PARAMETERS

### -Latitude

The latitude of the location to fetch the rain forecast for.

```yaml
Type: System.Double
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Longitude

The longitude of the location to fetch the rain forecast for.

```yaml
Type: System.Double
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
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

## OUTPUTS

### PSCustomObject

{{ Fill in the Description }}

### System.Management.Automation.PSObject

{{ Fill in the Description }}

## NOTES

Uses https://gpsgadget.buienradar.nl/data/raintext?lat={lat}&lon={lon}.
Data is updated approximately every 5 minutes.


## RELATED LINKS

{{ Fill in the related links here }}

