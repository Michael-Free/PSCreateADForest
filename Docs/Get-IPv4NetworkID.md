---
external help file: PSCreateADForest-help.xml
Module Name: PSCreateADForest
online version: https://github.com/Michael-Free/PSCreateADForest/Docs/Get-IPv4NetworkID.md
schema: 2.0.0
---

# Get-IPv4NetworkID

## SYNOPSIS
Retrieves the IPv4 network ID for the active network adapter.

## SYNTAX

```
Get-IPv4NetworkID
```

## DESCRIPTION
The \`Get-IPv4NetworkID\` function calculates the network ID for the active IPv4 network adapter
by performing a bitwise AND operation between the IP address and subnet mask.
It returns the
network ID in CIDR notation (e.g., 192.168.1.0/24).

## EXAMPLES

### EXAMPLE 1
```
Get-IPv4NetworkID
192.168.1.0/24
```

This example retrieves the network ID for the current IPv4 network adapter.

### EXAMPLE 2
```
$networkID = Get-IPv4NetworkID
Write-Output $networkID
192.168.1.0/24
```

This example stores the network ID in the \`$networkID\` variable and outputs it.

## PARAMETERS

## INPUTS

### None. This function does not take input.
## OUTPUTS

### [string]
###     The network ID in CIDR notation, such as "192.168.1.0/24".
## NOTES
Author      : Michael Free
Date        : 2025-03-22
License     : Free Custom License (FCL) v1.0
Copyright   : 2025, Michael Free.
All Rights Reserved.

## RELATED LINKS

[https://github.com/Michael-Free/PSCreateADForest/Docs/Get-IPv4NetworkID.md](https://github.com/Michael-Free/PSCreateADForest/Docs/Get-IPv4NetworkID.md)

