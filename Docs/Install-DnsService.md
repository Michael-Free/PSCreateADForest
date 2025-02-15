---
external help file: PSCreateADForest-help.xml
Module Name: PSCreateADForest
online version: https://github.com/Michael-Free/PSCreateADForest/Docs/Install-DnsService.md
schema: 2.0.0
---

# Install-DnsService

## SYNOPSIS
This function installs DNS service and other features, configures DNS server zones,
and sets up time synchronization.

## SYNTAX

```
Install-DnsService [-SiteName] <String> [-SiteLocation] <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The \`Install-DnsService\` function installs the required DNS server features and tools,
configures the DNS server settings, and sets up Active Directory replication.
It also
configures automatic DNS scavenging, aging for DNS zones, and time synchronization using
an NTP server.

This function assumes the system is running Windows Server and has internet access to
download required features.
It also assumes the presence of an Active Directory environment
for configuring replication sites and subnets.

## EXAMPLES

### EXAMPLE 1
```
Install-DnsService -SiteName "NewYork" -SiteLocation "NYC Datacenter"
```

This command installs the DNS service, configures the Active Directory site to "NewYork",
and sets the location to "NYC Datacenter".
It also configures DNS scavenging, aging, and
time synchronization.

### EXAMPLE 2
```
$result = Install-DnsService -SiteName "London" -SiteLocation "London Datacenter"
```

This stores the result of the DNS installation and configuration into the \`$result\` variable.
However, the function does not return output, so \`$result\` will be \`$null\`.

## PARAMETERS

### -SiteName
The name of the Active Directory site to be configured.
This name will be used to rename
the default site.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SiteLocation
The location associated with the Active Directory site.
This is used when creating a new
replication subnet for the site.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [string]$SiteName
### [string]$SiteLocation
## OUTPUTS

## NOTES
- Author: Michael Free (c) 2024
- Website: https://github.com/Michael-Free
- Social: https://mastodon.social/@MichaelFree

## RELATED LINKS

[https://github.com/Michael-Free/PSCreateADForest/Docs/Install-DnsService.md](https://github.com/Michael-Free/PSCreateADForest/Docs/Install-DnsService.md)

