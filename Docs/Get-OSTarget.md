---
external help file: PSCreateADForest-help.xml
Module Name: PSCreateADForest
online version: https://github.com/Michael-Free/PSCreateADForest/Docs/Get-OSTarget.md
schema: 2.0.0
---

# Get-OSTarget

## SYNOPSIS
This function checks if the operating system is Windows Server.

## SYNTAX

```
Get-OSTarget
```

## DESCRIPTION
The \`Get-OSTarget\` function checks the CIM instance class for the Operating System type.
If it is not ProductType 2 or 3, it throws an exception.

## EXAMPLES

### EXAMPLE 1
```
Get-OSTarget
```

This command will return no output if it is Windows Server.
If it is not Windows Server,
an exception will be thrown.

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

[https://github.com/Michael-Free/PSCreateADForest/Docs/Get-OSTarget.md](https://github.com/Michael-Free/PSCreateADForest/Docs/Get-OSTarget.md)

