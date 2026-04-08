# PSBuienradar

A PowerShell survival toolkit for the Netherlands that fetches weather and rain forecast data from Buienradar, then turns it into practical (and slightly humorous) advice.

[![Build Status](https://img.shields.io/github/actions/workflow/status/marko-stanojevic/PSBuienradar/ci.yml?branch=main&logo=github&style=flat-square)](https://github.com/marko-stanojevic/PSBuienradar/actions/workflows/ci.yml)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PSBuienradar.svg)](https://www.powershellgallery.com/packages/PSBuienradar)
[![Downloads](https://img.shields.io/powershellgallery/dt/PSBuienradar.svg)](https://www.powershellgallery.com/packages/PSBuienradar)
[![License](https://img.shields.io/github/license/marko-stanojevic/PSBuienradar)](LICENSE)

## About

PSBuienradar helps you quickly answer one question: "Do I need to panic-pack an umbrella right now?"

The module combines:

- Public IP detection
- Geo-location lookup
- Rain forecast retrieval (Buienradar rain text endpoint)
- Nearest weather station matching
- Human-friendly survival advice

## Why PSBuienradar?

- Fast local weather context for users in the Netherlands
- PowerShell-native objects that are easy to filter, sort, and script
- End-to-end "single command" experience via `Get-WeatherSurvivalAdvice`
- Useful for terminals, scripts, and lightweight automations

## Features

- `Get-PublicIP`: gets your current public IP via ipify
- `Get-GeoLocation`: resolves IP to latitude/longitude and city
- `Get-RainForecast`: retrieves and parses the 2-hour Buienradar rain forecast
- `Get-NearestWeatherStation`: finds the closest Buienradar station using Haversine distance
- `Get-WeatherSurvivalAdvice`: orchestrates the full workflow and returns a survival report

## 🚀 Getting Started

### Prerequisites

**Required:**

- **PowerShell 7.0+**
- Internet access to external APIs:
	- `https://api.ipify.org`
	- `http://ip-api.com`
	- `https://gpsgadget.buienradar.nl`
	- `https://data.buienradar.nl`

### Installation

Install the module from the PowerShell Gallery:

```powershell
Install-Module -Name PSBuienradar -Scope CurrentUser
```

### Usage

Import the module and use its commands:

```powershell
Import-Module PSBuienradar
Get-Command -Module PSBuienradar
```

### Quick Example

```powershell
$report = Get-WeatherSurvivalAdvice
$report | Format-List
```

### Individual Command Examples

```powershell
# 1) Detect public IP
$ip = Get-PublicIP

# 2) Resolve IP to geo-location
$location = Get-GeoLocation -IP $ip

# 3) Get rain forecast for current location
$forecast = Get-RainForecast -Latitude $location.Latitude -Longitude $location.Longitude

# 4) Find nearest weather station
$feed = Invoke-RestMethod -Uri 'https://data.buienradar.nl/2.0/feed/json'
$station = Get-NearestWeatherStation -Latitude $location.Latitude -Longitude $location.Longitude -Stations $feed.actual.stationmeasurements

# 5) Full end-to-end report
Get-WeatherSurvivalAdvice
```

## Output Shape

`Get-WeatherSurvivalAdvice` returns a `PSCustomObject` with fields such as:

- `Location`
- `Latitude`
- `Longitude`
- `StationName`
- `Temperature`
- `WindSpeed`
- `WindDirection`
- `Humidity`
- `RainForecast`
- `CurrentRain`
- `SurvivalAdvice`

## 📘 Documentation

Documentation is available in the [`docs/`](docs/) directory:

- 🚀 **[Getting Started](docs/getting-started.md)** - Practical examples and usage scenarios
- 📘 **[Command Help](docs/help/)** - Generated help files

## 🤝 Contributing

Contributions are welcome. Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on:

- Pull request workflow
- Code style and conventions
- Testing and quality requirements

## ⭐ Support This Project

If this project helps you avoid Dutch weather surprises, consider supporting it:

- ⭐ Star the repository to show your support
- 🔁 Share it with other PowerShell developers
- 💬 Provide feedback via issues or discussions
- ❤️ Sponsor ongoing development via GitHub Sponsors

---

Built with ❤️ by [marko-stanojevic](https://github.com/marko-stanojevic)
