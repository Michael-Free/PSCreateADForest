---
external help file: PSCreateADForest-help.xml
Module Name: PSCreateADForest
online version: https://github.com/Michael-Free/PSCreateADForest/Docs/Approve-IPVariables.md
schema: 2.0.0
---

# Approve-IPVariables

## SYNOPSIS
This function validates an array of IP variables to ensure it is in the expected formats.

## SYNTAX

```
Approve-IPVariables [-IpVars] <Array> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Approve-IPVariables\` function takes an array of IP variables to ensure it is in
the expected formats.

The first three items in the array must be valid IP addresses, and the final item in
the array must be a subnet prefix between 8 and 24.

## EXAMPLES

### EXAMPLE 1
```
Approve-IPVariables -IpVars @('192.168.0.1', '192.168.0.2', '192.168.0.3', 24)
```

Validates the provided array of IP variables.
If all conditions are met, the function completes silently.

## PARAMETERS

### -IpVars
An array containing four elements:
    - The first three elements should be valid IPv4 addresses.
    - The fourth element should be a number representing the network prefix, ranging from 8 to 30.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

### [array]$IpVars
###   The function expects an array input with exactly four elements.
## OUTPUTS

### None. This script performs operations but does not return output.
## NOTES
Author      : Michael Free
Date        : 2025-03-22
License     : Free Custom License (FCL) v1.0
Copyright   : 2025, Michael Free.
All Rights Reserved.

## RELATED LINKS

[https://github.com/Michael-Free/PSCreateADForest/Docs/Approve-IPVariables.md](https://github.com/Michael-Free/PSCreateADForest/Docs/Approve-IPVariables.md)

