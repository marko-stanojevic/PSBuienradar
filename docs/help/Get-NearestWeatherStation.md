---
document type: cmdlet
external help file: PSBuienradar-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSBuienradar
ms.date: 04/09/2026
PlatyPS schema version: 2024-05-01
title: Get-NearestWeatherStation
---

# Get-NearestWeatherStation

## SYNOPSIS

Finds the nearest BuienRadar weather station to the given coordinates

## SYNTAX

### __AllParameterSets

```
Get-NearestWeatherStation [-Latitude] <double> [-Longitude] <double> [-Stations] <Object[]>
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Accepts an array of BuienRadar station measurement objects (as returned
by the /2.0/feed/json endpoint) and returns the station closest to the
supplied latitude and longitude, calculated using the Haversine formula.

## EXAMPLES

### EXAMPLE 1

$feed = Invoke-RestMethod -Uri 'https://data.buienradar.nl/2.0/feed/json'
Get-NearestWeatherStation -Latitude 52.37 -Longitude 4.90 -Stations $feed.actual.stationmeasurements

Returns the weather station closest to Amsterdam.

## PARAMETERS

### -Latitude

The latitude of the reference point in decimal degrees.

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

The longitude of the reference point in decimal degrees.

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

### -Stations

An array of BuienRadar station measurement objects.
Each object must
expose at least a 'lat' and 'lon' property.
Typically sourced from
the 'actual.stationmeasurements' array of the BuienRadar JSON feed.

```yaml
Type: System.Object[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
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

Requires BuienRadar station objects with 'lat' and 'lon' properties.


## RELATED LINKS

{{ Fill in the related links here }}

