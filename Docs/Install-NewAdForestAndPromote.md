---
external help file: PSCreateADForest-help.xml
Module Name: PSCreateADForest
online version: https://github.com/Michael-Free/PSCreateADForest/Docs/Install-NewAdForestAndPromote.md
schema: 2.0.0
---

# Install-NewAdForestAndPromote

## SYNOPSIS
Installs a new Active Directory Domain Services forest with the specified domain name,
NetBIOS name, and operating system mode.

## SYNTAX

```
Install-NewAdForestAndPromote [-DomainName] <String> [-NetBiosName] <String> [-Mode] <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function installs and configures a new Active Directory Domain Services (AD DS) forest.

It takes the following parameters: \`DomainName\`, \`NetBiosName\`, and \`Mode\`.
The function
checks that the system is running Windows Server, validates the domain and NetBIOS names,
verifies that the provided operating system mode is supported, and installs the necessary
features to configure AD DS.

## EXAMPLES

### EXAMPLE 1
```
Install-New-AdForestAndPromote -DomainName "example.com" -NetBiosName "EXAMPLE" -Mode "Win2012"
```

This command will install a new Active Directory Domain Services forest with the domain
"example.com" and the NetBIOS name "EXAMPLE" using the "Win2016" AD mode.

## PARAMETERS

### -DomainName
The Fully Qualified Domain Name (FQDN) for the new domain in the forest.
This should be in
the format of a valid FQDN (e.g., "example.com").

The function validates the domain name to ensure it matches the correct format.

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

### -NetBiosName
The NetBIOS name for the domain, which must be a single-word name without spaces or special
characters.
This name is used for backward compatibility in networking.

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

### -Mode
The operating system mode to use for the new domain forest.
Supported values are: \`Win2008\`, \`Win2008R2\`, \`Win2012\`, \`Win2012R2\`, \`WinThreshold\`, \`Default\`.
This parameter determines the version of Active Directory to be used in the forest.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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

### [string]$DomainName
### [string]$NetBiosName
### [string]$Mode
## OUTPUTS

## NOTES
- Author: Michael Free (c) 2024
- Website: https://github.com/Michael-Free
- Social: https://mastodon.social/@MichaelFree

## RELATED LINKS

[https://github.com/Michael-Free/PSCreateADForest/Docs/Install-NewAdForestAndPromote.md](https://github.com/Michael-Free/PSCreateADForest/Docs/Install-NewAdForestAndPromote.md)

