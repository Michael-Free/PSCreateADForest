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
- Author: Michael Free (c) 2024
- Website: https://github.com/Michael-Free
- Social: https://mastodon.social/@MichaelFree

## RELATED LINKS

[https://github.com/Michael-Free/PSCreateADForest/Docs/Add-NetworkConfig.md](https://github.com/Michael-Free/PSCreateADForest/Docs/Add-NetworkConfig.md)

