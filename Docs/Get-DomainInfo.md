---
external help file: PSCreateADForest-help.xml
Module Name: PSCreateADForest
online version: https://github.com/Michael-Free/PSCreateADForest/Docs/Get-DomainInfo.md
schema: 2.0.0
---

# Get-DomainInfo

## SYNOPSIS
This function gets information about the current Windows domain and its domain controller.

## SYNTAX

```
Get-DomainInfo
```

## DESCRIPTION
The \`Get-DomainInfo\` function checks whether the computer is joined to a Windows domain.
If it is,
the function retrieves details about the domain controller, including the domain name, site name,
and hostname.
If the computer is not joined to a domain, the function throws an error.

If there are multiple domain controllers, it gets the information from the last domain controller
listed (sorted by hostname in alphanumerical order).

## EXAMPLES

### EXAMPLE 1
```
$domainInfo = Get-DomainInfo
Write-Output $domainInfo.DomainName
```

This example stores the domain information in the \`$domainInfo\` variable and outputs the domain name.

## PARAMETERS

## INPUTS

### None. This function does not take input.
## OUTPUTS

### [PSCustomObject]
###     A Custom Object with:
###     - DomainName: FQDN of the Windows domain.
###     - SiteName: Site associated with the Domain Controller.
###     - HostName: Domain Controller's hostname.
## NOTES
Author      : Michael Free
Date        : 2025-03-22
License     : Free Custom License (FCL) v1.0
Copyright   : 2025, Michael Free.
All Rights Reserved.

## RELATED LINKS

[https://github.com/Michael-Free/PSCreateADForest/Docs/Get-DomainInfo.md](https://github.com/Michael-Free/PSCreateADForest/Docs/Get-DomainInfo.md)

