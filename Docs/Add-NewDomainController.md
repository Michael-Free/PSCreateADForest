---
external help file: PSCreateADForest-help.xml
Module Name: PSCreateADForest
online version: https://github.com/Michael-Free/PSCreateADForest/Docs/Add-NewDomainController.md
schema: 2.0.0
---

# Add-NewDomainController

## SYNOPSIS
Installs and configures a new domain controller in an existing Active Directory domain.

## SYNTAX

```
Add-NewDomainController
```

## DESCRIPTION
The \`Add-NewDomainController\` function installs the required features for Active Directory Domain Services,
DNS, and RSAT (Remote Server Administration Tools).
It then uses the provided credentials to join a machine
to an existing Active Directory domain and configure it as a new domain controller.

The function also gathers domain information, prepares the necessary settings (such as database paths, log
paths, and replication settings), and runs the \`Install-ADDSDomainController\` cmdlet to configure the server
as a domain controller.

This function assumes the machine is part of an existing Active Directory forest and has internet access to
download required features.
The user running the script must have the necessary administrative privileges to
install Active Directory Domain Services and configure DNS.

## EXAMPLES

### EXAMPLE 1
```
Add-NewDomainController
```

This command installs the required features, prompts for user credentials, and configures the current server as
a new domain controller in the existing Active Directory domain.

### EXAMPLE 2
```
$domainController = Add-NewDomainController
```

This stores the result of the domain controller promotion into the \`$domainController\` variable, but since the
function doesn't return output, \`$domainController\` will be \`$null\`.

## PARAMETERS

## INPUTS

## OUTPUTS

## NOTES
- Author: Michael Free (c) 2024
- Website: https://github.com/Michael-Free
- Social: https://mastodon.social/@MichaelFree

## RELATED LINKS

[https://github.com/Michael-Free/PSCreateADForest/Docs/Add-NewDomainController.md](https://github.com/Michael-Free/PSCreateADForest/Docs/Add-NewDomainController.md)

