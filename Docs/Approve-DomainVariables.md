---
external help file: PSCreateADForest-help.xml
Module Name: PSCreateADForest
online version: https://github.com/Michael-Free/PSCreateADForest/Docs/Approve-DomainVariables.md
schema: 2.0.0
---

# Approve-DomainVariables

## SYNOPSIS
This function checks to see if the variables provided about the new domain are in correct format.

## SYNTAX

```
Approve-DomainVariables [-Domain] <String> [-NetBios] <String> [-ModeType] <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Approve-DomainVariables\` function takes the Domain parameter (the domain name you're creating),
and verifies that it is in the format of a Fully Qualified Domain Name (FQDN), if it isn't it
throws an exception.

It also takes the NetBios parameter.
It verifies the parameter is no more than 15 characters, and
does not contain any other special characters.
If it doesn't meet this criteria, it throws an
exception.

Finally, it takes the ModeType parameter.
It verifies that the parameter is an accepted value. 
If
it is not, an exception is thrown.
Accepted values can be: 'Win2008', 'Win2008R2', 'Win2012',
'Win2012R2', 'WinThreshold', and 'Default'.
In most cases this can be WinThreshold or Default -
unless you are working with legacy systems.

## EXAMPLES

### EXAMPLE 1
```
Approve-DomainVariables -Domain mydomain.com -NetBios mydomain -ModeType Win2008
```

This command will verify that mydomain.com is a valid FQDN, NetBios doesn't have special characters and isn't
over 15 characters, and that the ModeType is valid (in this case, Win2008).

## PARAMETERS

### -Domain
A domain is a logical grouping of objects (users, computers, and devices) that share a common
directory database, security policies, and trust boundaries.

It is defined by a a domain name, which this parameter is checking.
This must be in a FQDN
format.
(ie.
my.domain.com, mydomain.net, etc.)

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

### -NetBios
The NetBIOS name is a short name used for backward compatibility with older Windows systems and
legacy applications to identify the domain.

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

### -ModeType
The ModeType (or functional level of the domain) determines the available features and compatibility
based on the version of Windows Server used by the domain controllers.

Accepted values can be: 'Win2008', 'Win2008R2', 'Win2012', 'Win2012R2', 'WinThreshold', and 'Default'.
In most cases this can be WinThreshold or Default - unless you are working with legacy systems.

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

### [string]$Domain
### [string]$NetBios
### [string]$ModeType
## OUTPUTS

### None. This function performs operations but does not return output.
## NOTES
Author      : Michael Free
Date        : 2025-03-22
License     : Free Custom License (FCL) v1.0
Copyright   : 2025, Michael Free.
All Rights Reserved.

## RELATED LINKS

[https://github.com/Michael-Free/PSCreateADForest/Docs/Approve-DomainVariables.md](https://github.com/Michael-Free/PSCreateADForest/Docs/Approve-DomainVariables.md)

