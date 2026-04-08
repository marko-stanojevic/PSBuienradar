---
document type: cmdlet
external help file: PSBuienradar-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSBuienradar
ms.date: 04/08/2026
PlatyPS schema version: 2024-05-01
title: Get-WeatherSurvivalAdvice
---

# Get-WeatherSurvivalAdvice

## SYNOPSIS

Returns a humorous Dutch weather survival report for your current location

## SYNTAX

### __AllParameterSets

```
Get-WeatherSurvivalAdvice [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Orchestrates the full BuienRadar weather survival pipeline:
    1.
Detects the user's public IP address
    2.
Resolves the IP to geographic coordinates and city name
    3.
Fetches the two-hour rain forecast from BuienRadar
    4.
Downloads the BuienRadar weather feed and finds the nearest station
    5.
Assembles a custom PSCustomObject with weather data and survival advice

Survival advice is generated based on current conditions:
    - Heavy rain    -> urgent evacuation humour
    - Moderate rain -> umbrella reminders
    - Light rain    -> mild caution
    - No rain       -> cautiously optimistic encouragement

## EXAMPLES

### EXAMPLE 1

Get-WeatherSurvivalAdvice

Detects location automatically and returns the survival report.

### EXAMPLE 2

$report = Get-WeatherSurvivalAdvice
$report.SurvivalAdvice

Retrieves only the survival advice text.

## PARAMETERS

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

Requires internet access to the following endpoints:
    - https://api.ipify.org
    - http://ip-api.com
    - https://gpsgadget.buienradar.nl
    - https://data.buienradar.nl


## RELATED LINKS

{{ Fill in the related links here }}

