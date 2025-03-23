---
external help file: PSCreateADForest-help.xml
Module Name: PSCreateADForest
online version: https://github.com/Michael-Free/PSCreateADForest/Docs/Add-NetworkConfig.md
schema: 2.0.0
---

# Add-NetworkConfig

## SYNOPSIS
This function turns off IPv6 Random & Temporary IP Assignments, as well as IPv6 Transition Technologies.

## SYNTAX

```
Add-NetworkConfig
```

## DESCRIPTION
The \`Add-NetworkConfig\` function disables several IPv6 features on the Windows Server. 
This includes
IPv6 Random & Temporary IP Assignments, as well as IPv6 Transition Technologies.

This typically isn't a necessar step, but if IPv6 isn't enabled or supported by your network, it is
best to disable it.

## EXAMPLES

### EXAMPLE 1
```
Add-NetworkConfig
```

This command turns off IPv6 Random & Temporary IP Assignments, as well as IPv6 Transition Technologies.

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

[https://github.com/Michael-Free/PSCreateADForest/Docs/Add-NetworkConfig.md](https://github.com/Michael-Free/PSCreateADForest/Docs/Add-NetworkConfig.md)

