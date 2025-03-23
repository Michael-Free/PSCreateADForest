---
external help file: PSCreateADForest-help.xml
Module Name: PSCreateADForest
online version: https://github.com/Michael-Free/PSCreateADForest/Docs/Get-AdapterCount.md
schema: 2.0.0
---

# Get-AdapterCount

## SYNOPSIS
This function checks the total amount of network adapters that currently have an active network
connection.

## SYNTAX

```
Get-AdapterCount
```

## DESCRIPTION
The \`Get-AdapterCount\` function checks the total number of active network adapters on the server.
If there is no active network adapters (or more than one), an exception will be thrown.
This function assumes that the network adapters are not WiFi Connections, as this is not ideal
for a Domain Controller.

## EXAMPLES

### EXAMPLE 1
```
Get-AdapterCount
```

This command will return no output if all requirements are met.

## PARAMETERS

## INPUTS

## OUTPUTS

## NOTES
Author      : Michael Free
Date        : 2025-03-22
License     : Free Custom License (FCL) v1.0
Copyright   : 2025, Michael Free.
All Rights Reserved.

## RELATED LINKS

[https://github.com/Michael-Free/PSCreateADForest/Docs/Get-AdapterCount.md](https://github.com/Michael-Free/PSCreateADForest/Docs/Get-AdapterCount.md)

