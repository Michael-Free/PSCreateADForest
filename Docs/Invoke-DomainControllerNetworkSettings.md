---
external help file: PSCreateADForest-help.xml
Module Name: PSCreateADForest
online version: https://github.com/Michael-Free/PSCreateADForest/Docs/Invoke-DomainControllerNetworkSettings.md
schema: 2.0.0
---

# Invoke-DomainControllerNetworkSettings

## SYNOPSIS
Configures a network interface on a Windows Server for use as a domain controller, setting
the hostname, IPv4 address, subnet prefix, gateway, and DNS server.

## SYNTAX

```
Invoke-DomainControllerNetworkSettings [-Hostname] <String> [-IPv4Address] <String> [-IPv4Prefix] <Int32>
 [-IPv4Gateway] <String> [-IPv4DNS] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This script configures the network settings required for setting up a domain controller. 
It
takes the following parameters: \`Hostname\`, \`IPv4Address\`, \`IPv4Prefix\`, \`IPv4Gateway\`,
and \`IPv4DNS\`.
The function validates the input parameters, ensures the system is running
Windows Server, checks for active network interfaces, and disables unnecessary IPv6 configurations.

It then sets the IPv4 address, default gateway, and DNS server for the network interface.
If the
hostname is different from the current computer name, it renames the computer to match the
specified \`Hostname\`.

## EXAMPLES

### EXAMPLE 1
```
Invoke-DomainControllerNetworkSettings -Hostname "DC1" -IPv4Address "192.168.1.10" -IPv4Prefix 24 -IPv4Gateway "192.168.1.1" -IPv4DNS "8.8.8.8"
```

This command will configure the network interface of the domain controller, set the hostname
to \`DC1\`, configure the IPv4 address to \`192.168.1.10\`, with a subnet prefix of \`24\`, the
gateway \`192.168.1.1\`, and set the upstream DNS server to Google's DNS IP address (\`8.8.8.8\`).

## PARAMETERS

### -Hostname
The name that the machine will be assigned as its hostname.
If the current hostname is already set, enter the existing hostname.

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

### -IPv4Address
The IP address that will be configured for the domain controller.
This address will be used to
uniquely identify the domain controller on the network.

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

### -IPv4Prefix
Specifies the subnet mask for the IPv4 address, which defines the size of the network portion
of the address.

This value must be between 8 and 30, with 24 being a typical value for most networks.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -IPv4Gateway
The IP address of the device (such as a router or switch) that will act as the intermediary
for communication between devices within the network and external networks.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IPv4DNS
The IP address of the DNS server for the domain controller.
For domain controllers, this is
often an upstream DNS server (8.8.8.8, 1.1.1.1), where external domain names can resolve.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
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

### [string]$Hostname
### [string]$IPv4Address
### [int]$IPv4Prefix
### [string]$IPv4Gateway
### [string]$IPv4DNS
## OUTPUTS

## NOTES
- Author: Michael Free (c) 2024
- Website: https://github.com/Michael-Free
- Social: https://mastodon.social/@MichaelFree

## RELATED LINKS

[https://github.com/Michael-Free/PSCreateADForest/Docs/Invoke-DomainControllerNetworkSettings.md](https://github.com/Michael-Free/PSCreateADForest/Docs/Invoke-DomainControllerNetworkSettings.md)

