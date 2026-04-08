---
document type: cmdlet
external help file: PSBuienradar-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSBuienradar
ms.date: 04/08/2026
PlatyPS schema version: 2024-05-01
title: Get-PublicIP
---

# Get-PublicIP

## SYNOPSIS

Returns the current user's public IP address

## SYNTAX

### __AllParameterSets

```
Get-PublicIP [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Queries the ipify.org API to determine the public IP address of the machine
running this command.
Useful as the first step in a geo-location workflow.

## EXAMPLES

### EXAMPLE 1

Get-PublicIP

Returns the public IP address as a string, e.g.
"203.0.113.42".

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String

{{ Fill in the Description }}

## NOTES

Requires internet access to reach https://api.ipify.org.


## RELATED LINKS

{{ Fill in the related links here }}

