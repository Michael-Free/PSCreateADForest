# PSCreateADForest

PSCreateADForest is a PowerShell module designed to quickly create new Active Directory forests and domain controllers. It's ideal for disaster recovery, setting up AD from scratch, or creating test and development environments efficiently, allowing for rapid deployment and teardown without starting from scratch.

## Prerequisites

## Installation

## Usage

### Examples

#### Creating a New Active Directory Forest

This example shows how to set up a NEW Active Directory Forest and a new Domain Controller. Before starting this process, the new Domain Controller must not be actively joined to an existing Active Directory domain.

```powershell
Invoke-DomainControllerNetworkSettings -Hostname "DC1" -IPv4Address "192.168.1.10" -IPv4Prefix 24 -IPv4Gateway "192.168.1.1" -IPv4DNS "8.8.8.8"
Restart-Computer -Force
```
In the first step, we are setting the new hostname of this server instance. However, if the server is already set to the desired hostname, supply the current hostname of the device. The IPv4Address MUST be an IP address that is currently NOT in use.  This will be the NEW IP address of the server going forward.

After the first reboot, creating the new Domain Controller and setting up the forest is now possible.

```powershell
Install-NewAdForestAndPromote -DomainName "example.com" -NetBiosName "EXAMPLE" -Mode "Win2012"
Restart-Computer -Force
```

Reboot after this action has completed and the Domain Controller will now be configured and ready to use.


#### Adding a New Domain Controller in an Existing Forest
This example demonstrates how to add additional domain controllers to the newly created Active Directory forest that was created in Example 1. 

Before starting, the new server must be added to the domain.  Firstly, the DNS server used by this device must be set to the IP address used for the first domain controller.

```powershell
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses ("192.168.1.10")
```

Now that the DNS server has been set on this machine, the machine can now be added to the domain. Unfortunately, this is Windows and a reboot is required after this action.

```powershell
Add-Computer -DomainName example.com -Credential example.com\Administrator
Restart-Computer -Force
```

After the reboot has taken place, we will apply network settings for the domain controller. 

```powershell
Invoke-DomainControllerNetworkSettings -Hostname "DC2" -IPv4Address "192.168.1.11" -IPv4Prefix 24 -IPv4Gateway "192.168.1.1" -IPv4DNS "192.168.1.10"
Restart-Computer -Force
```

Once this reboot is complete, add the new domain controller and reboot

```powershell
Add-NewDomainController
Restart-Computer -Force
```

## License

Free Custom License (FCL) v1.0

Copyright 2025, Michael Free. All Rights Reserved.

## Contributions

### Reporting Bugs

If you encounter any issues while using the tool, please report them in the issue tracker on GitHub. Be sure to include the following information in your bug report:

- The steps to reproduce the issue
- The expected behavior
- The actual behavior
- Any error messages or stack traces associated with the issue

### Requesting Features

If you have an idea for a new feature, please let me know by creating an issue in the issue tracker on GitHub. Be sure to explain why this feature would be useful and how it could benefit the project.

### Contributing Code

If you're a developer interested in contributing code to the project, I encourage you to submit a pull request through GitHub. Before submitting your code, please make sure it adheres to my coding standards and passes any automated tests.

### Providing Feedback

Your feedback is valuable to me. If you have any suggestions or ideas for improving the tool, please share them with me through the issue tracker on GitHub or by reaching out to me on Mastodon: https://mastodon.social/@MichaelFree

### Testing and Quality Assurance

I appreciate any help testing the project and reporting issues. If you have experience in testing, please let me know by creating an issue in the issue tracker on GitHub or by contacting me directly.

Thank you for your interest in contributing to my project! Your contributions will help make it even better.
