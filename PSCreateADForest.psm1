#Requires -RunAsAdministrator

function Get-OSTarget {
  <#
    .SYNOPSIS
        This function checks if the operating system is Windows Server.

    .DESCRIPTION
        The `Get-OSTarget` function checks the CIM instance class for the Operating System type.
        If it is not ProductType 2 or 3, it throws an exception.

    .PARAMETER None

    .INPUTS

    .OUTPUTS

    .EXAMPLE
        Get-OSTarget

        This command will return no output if it is Windows Server. If it is not Windows Server,
        an exception will be thrown.

    .NOTES
        - Author: Michael Free (c) 2024
        - Website: https://github.com/Michael-Free
        - Social: https://mastodon.social/@MichaelFree

    .LINK
        https://github.com/Michael-Free/PSCreateADForest/Docs/Get-OSTarget.md
  #>
  $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
  if (-not ($osInfo.ProductType -eq 2 -or $osInfo.ProductType -eq 3)) {
    throw 'This script must run on Windows Server.'
  }
}

function Get-AdapterCount {
  <#
    .SYNOPSIS
        This function checks the total amount of network adapters that currently have an active network
        connection.

    .DESCRIPTION
        The `Get-AdapterCount` function checks the total number of active network adapters on the server.
        If there is no active network adapters (or more than one), an exception will be thrown.
        This function assumes that the network adapters are not WiFi Connections, as this is not ideal
        for a Domain Controller.

    .PARAMETER None

    .INPUTS

    .OUTPUTS

    .EXAMPLE
        Get-AdapterCount

        This command will return no output if all requirements are met.

    .NOTES
        - Author: Michael Free (c) 2024
        - Website: https://github.com/Michael-Free
        - Social: https://mastodon.social/@MichaelFree

    .LINK
        https://github.com/Michael-Free/PSCreateADForest/Docs/Get-AdapterCount.md
    #>
  $activeAdapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
  $adapterCount = $activeAdapters.Count
  if ($adapterCount -eq 0) {
    throw 'A domain controller requires at least one active network interface.'
  }
  elseif ($adapterCount -gt 1) {
    throw 'Multiple active network interfaces detected. Please disable additional interfaces.'
  }
}

function Get-IPv4NetworkID {
  <#
    .SYNOPSIS
        Retrieves the IPv4 network ID for the active network adapter.

    .DESCRIPTION
        The `Get-IPv4NetworkID` function calculates the network ID for the active IPv4 network adapter
        by performing a bitwise AND operation between the IP address and subnet mask. It returns the
        network ID in CIDR notation (e.g., 192.168.1.0/24).

    .PARAMETER None
        This function does not take any parameters.

    .INPUTS
        None. This function does not take input.

    .OUTPUTS
        [string]
            The network ID in CIDR notation, such as "192.168.1.0/24".

    .EXAMPLE
        Get-IPv4NetworkID
        192.168.1.0/24

        This example retrieves the network ID for the current IPv4 network adapter.

    .EXAMPLE
        $networkID = Get-IPv4NetworkID
        Write-Output $networkID
        192.168.1.0/24

        This example stores the network ID in the `$networkID` variable and outputs it.

    .NOTES
        - Author: Michael Free (c) 2024
        - Website: https://github.com/Michael-Free
        - Social: https://mastodon.social/@MichaelFree

    .LINK
        https://github.com/Michael-Free/PSCreateADForest/Docs/Get-IPv4NetworkID.md

    #>
  try {
    $adapterConfig = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled }
    $ipAddress = $adapterConfig.IPaddress[0]
    $ipSubnetMask = $adapterConfig.IPSubnet[0]
    $ipAddressBytes = [System.Net.IPAddress]::Parse($ipAddress).GetAddressBytes()
    $ipSubnetMaskBytes = [System.Net.IPAddress]::Parse($ipSubnetMask).GetAddressBytes()
    $networkBytes = @()
    for ($byteIndex = 0; $byteIndex -lt $ipAddressBytes.Length; $byteIndex++) {
      $networkBytes += $ipAddressBytes[$byteIndex] -band $ipSubnetMaskBytes[$byteIndex]
    }
    $firstAddressInSubnet = [System.Net.IPAddress]::new($networkBytes).IPAddressToString
    $networkAdapterPrefix = (Get-NetAdapter).ifIndex
    $cidrPrefix = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $networkAdapterPrefix | Select-Object PrefixLength).PrefixLength
    $networkID = "$firstAddressInSubnet/$cidrPrefix"
  }
  catch {
    throw "$_"
  }
  return $networkID
}

function Get-DomainInfo {
  <#
    .SYNOPSIS
      This function gets information about the current Windows domain and its domain controller.

    .DESCRIPTION
        The `Get-DomainInfo` function checks whether the computer is joined to a Windows domain. If it is,
        the function retrieves details about the domain controller, including the domain name, site name,
        and hostname. If the computer is not joined to a domain, the function throws an error.

        If there are multiple domain controllers, it gets the information from the last domain controller
        listed (sorted by hostname in alphanumerical order).

    .PARAMETER None
        This function does not take any parameters.

    .INPUTS
        None. This function does not take input.

    .OUTPUTS
        [PSCustomObject]
            A Custom Object with:
            - DomainName: FQDN of the Windows domain.
            - SiteName: Site associated with the Domain Controller.
            - HostName: Domain Controller's hostname.

    .EXAMPLE
        $domainInfo = Get-DomainInfo
        Write-Output $domainInfo.DomainName

        This example stores the domain information in the `$domainInfo` variable and outputs the domain name.

    .NOTES
        - Author: Michael Free (c) 2024
        - Website: https://github.com/Michael-Free
        - Social: https://mastodon.social/@MichaelFree

    .LINK
        https://github.com/Michael-Free/PSCreateADForest/Docs/Get-DomainInfo.md
    #>
  $domainInfo = Get-CimInstance -Namespace root\cimv2 -ClassName Win32_ComputerSystem
  if (-not $domainInfo.PartOfDomain) {
    throw 'Server must already be joined to a Windows Domain.'
  }
  try {
    $domainController = Get-ADDomainController -Filter * | Sort-Object -Property HostName | Select-Object -Last 1
    return [PSCustomObject]@{
      DomainName = $domainController.Domain
      SiteName   = $domainController.Site
      Hostname   = $domainController.HostName
    }
  }
  catch {
    throw "Error getting domain controller info: $($_.Exception.Message)"
  }
}

function Approve-DomainVariables {
  <#
    .SYNOPSIS
        This function checks to see if the variables provided about the new domain are in correct format.

    .DESCRIPTION
        The `Approve-DomainVariables` function takes the Domain parameter (the domain name you're creating),
        and verifies that it is in the format of a Fully Qualified Domain Name (FQDN), if it isn't it
        throws an exception.

        It also takes the NetBios parameter. It verifies the parameter is no more than 15 characters, and
        does not contain any other special characters. If it doesn't meet this criteria, it throws an
        exception.

        Finally, it takes the ModeType parameter. It verifies that the parameter is an accepted value.  If
        it is not, an exception is thrown. Accepted values can be: 'Win2008', 'Win2008R2', 'Win2012',
        'Win2012R2', 'WinThreshold', and 'Default'. In most cases this can be WinThreshold or Default -
        unless you are working with legacy systems.

    .PARAMETER Domain
        A domain is a logical grouping of objects (users, computers, and devices) that share a common
        directory database, security policies, and trust boundaries.

        It is defined by a a domain name, which this parameter is checking. This must be in a FQDN
        format. (ie. my.domain.com, mydomain.net, etc.)

    .PARAMETER NetBios
        The NetBIOS name is a short name used for backward compatibility with older Windows systems and
        legacy applications to identify the domain.

    .PARAMETER ModeType
        The ModeType (or functional level of the domain) determines the available features and compatibility
        based on the version of Windows Server used by the domain controllers.

        Accepted values can be: 'Win2008', 'Win2008R2', 'Win2012', 'Win2012R2', 'WinThreshold', and 'Default'.
        In most cases this can be WinThreshold or Default - unless you are working with legacy systems.

    .INPUTS
        [string]$Domain
        [string]$NetBios
        [string]$ModeType

    .OUTPUTS
        None. This function performs operations but does not return output.

    .EXAMPLE
        Approve-DomainVariables -Domain mydomain.com -NetBios mydomain -ModeType Win2008

        This command will verify that mydomain.com is a valid FQDN, NetBios doesn't have special characters and isn't
        over 15 characters, and that the ModeType is valid (in this case, Win2008).
  
    .NOTES
        - Author: Michael Free (c) 2024
        - Website: https://github.com/Michael-Free
        - Social: https://mastodon.social/@MichaelFree
  
    .LINK
        https://github.com/Michael-Free/PSCreateADForest/Docs/Approve-DomainVariables.md
    #>
  param(
    [Parameter(Mandatory = $true)]
    [string]$Domain,
    [Parameter(Mandatory = $true)]
    [string]$NetBios,
    [Parameter(Mandatory = $true)]
    [string]$ModeType
  )
  $fqdnRegex = '^(?=.{1,255}$)([a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}$'
  if ($Domain -notmatch $fqdnRegex) {
    throw "Domain Name doesn't match FQDN format: $Domain"
  }
  $netBiosRegex = '^[A-Za-z0-9-]+$'
  if ($NetBios -notmatch $netBiosRegex -or $NetBios.Count -gt 15) {
    throw 'Invalid NetBIOS name. Must not have spaces, special characters or exceed 15 characters in length: '
  }
  $modeArray = @(
    'Win2008',
    'Win2008R2'
    'Win2012',
    'Win2012R2',
    'WinThreshold',
    'Default'
  )
  if ($modeArray -notcontains $ModeType) {
    throw "$ModeType is not supported, must use $modeArray"
  }
}

function Approve-IPVariables {
  <#
    .SYNOPSIS
        This function validates an array of IP variables to ensure it is in the expected formats.

    .DESCRIPTION
        The `Approve-IPVariables` function takes an array of IP variables to ensure it is in
        the expected formats.

        The first three items in the array must be valid IP addresses, and the final item in
        the array must be a subnet prefix between 8 and 24.

    .PARAMETER IpVars
        An array containing four elements:
            - The first three elements should be valid IPv4 addresses.
            - The fourth element should be a number representing the network prefix, ranging from 8 to 30.

    .INPUTS
        [array]$IpVars
          The function expects an array input with exactly four elements.

    .OUTPUTS
        None. This script performs operations but does not return output.

    .EXAMPLE
        Approve-IPVariables -IpVars @('192.168.0.1', '192.168.0.2', '192.168.0.3', 24)

        Validates the provided array of IP variables. If all conditions are met, the function completes silently.
 
    .NOTES
        - Author: Michael Free (c) 2024
        - Website: https://github.com/Michael-Free
        - Social: https://mastodon.social/@MichaelFree

    .LINK
        https://github.com/Michael-Free/PSCreateADForest/Docs/Approve-IPVariables.md
    #>
  param (
    [Parameter(Mandatory = $true)]
    [array]$IpVars
  )
  $ipRegex = '^((25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$'
  if ($IpVars.Count -ne 4) {
    throw "Too many items in array ipVars array. Expecting 4 - got $($ipVars.Count)"
  }
  elseif (-not ($IpVars[-1] -ge 8 -and $IpVars[-1] -le 30)) {
    throw "The value of the network prefix is not between 8 and 30. Got $($IpVars[-1])"
  }
  else {
    $IpVars[0..2] | ForEach-Object {
      if ($_ -notmatch $ipRegex) {
        throw "$_ is not a valid IPv4 address."
      }
    }
  }
}

function Add-NetworkConfig {
  <#
    .SYNOPSIS
        This function turns off IPv6 Random & Temporary IP Assignments, as well as IPv6 Transition Technologies.

    .DESCRIPTION
        The `Add-NetworkConfig` function disables several IPv6 features on the Windows Server.  This includes
        IPv6 Random & Temporary IP Assignments, as well as IPv6 Transition Technologies.

        This typically isn't a necessar step, but if IPv6 isn't enabled or supported by your network, it is
        best to disable it.

    .PARAMETER None

    .INPUTS

    .OUTPUTS

    .EXAMPLE
        Add-NetworkConfig

        This command turns off IPv6 Random & Temporary IP Assignments, as well as IPv6 Transition Technologies.
    
    .NOTES
        - Author: Michael Free (c) 2024
        - Website: https://github.com/Michael-Free
        - Social: https://mastodon.social/@MichaelFree

    .LINK
        https://github.com/Michael-Free/PSCreateADForest/Docs/Add-NetworkConfig.md
    #>
  try {
    Set-NetIPv6Protocol -RandomizeIdentifiers Disabled
    Set-NetIPv6Protocol -UseTemporaryAddresses Disabled
    Set-Net6to4Configuration -State Disabled
    Set-NetIsatapConfiguration -State Disabled
    Set-NetTeredoConfiguration -Type Disabled
  }
  catch {
    throw "Failed to set network configuration: $($_.Exception.Message)"
  }
}

function Invoke-DomainControllerNetworkSettings {
  <#
    .SYNOPSIS
        Configures a network interface on a Windows Server for use as a domain controller, setting
        the hostname, IPv4 address, subnet prefix, gateway, and DNS server.

    .DESCRIPTION
        This script configures the network settings required for setting up a domain controller.  It
        takes the following parameters: `Hostname`, `IPv4Address`, `IPv4Prefix`, `IPv4Gateway`,
        and `IPv4DNS`. The function validates the input parameters, ensures the system is running
        Windows Server, checks for active network interfaces, and disables unnecessary IPv6 configurations.

        It then sets the IPv4 address, default gateway, and DNS server for the network interface. If the
        hostname is different from the current computer name, it renames the computer to match the
        specified `Hostname`.

    .PARAMETER Hostname
        The name that the machine will be assigned as its hostname.
        If the current hostname is already set, enter the existing hostname.

    .PARAMETER IPv4Address
        The IP address that will be configured for the domain controller. This address will be used to
        uniquely identify the domain controller on the network.

    .PARAMETER IPv4Prefix
        Specifies the subnet mask for the IPv4 address, which defines the size of the network portion
        of the address.

        This value must be between 8 and 30, with 24 being a typical value for most networks.

    .PARAMETER IPv4Gateway
        The IP address of the device (such as a router or switch) that will act as the intermediary
        for communication between devices within the network and external networks.

    .PARAMETER IPv4DNS
        The IP address of the DNS server for the domain controller. For domain controllers, this is
        often an upstream DNS server (8.8.8.8, 1.1.1.1), where external domain names can resolve.

    .INPUTS
        [string]$Hostname
        [string]$IPv4Address
        [int]$IPv4Prefix
        [string]$IPv4Gateway
        [string]$IPv4DNS

    .OUTPUTS

    .EXAMPLE
        Invoke-DomainControllerNetworkSettings -Hostname "DC1" -IPv4Address "192.168.1.10" -IPv4Prefix 24 -IPv4Gateway "192.168.1.1" -IPv4DNS "8.8.8.8"

        This command will configure the network interface of the domain controller, set the hostname
        to `DC1`, configure the IPv4 address to `192.168.1.10`, with a subnet prefix of `24`, the
        gateway `192.168.1.1`, and set the upstream DNS server to Google's DNS IP address (`8.8.8.8`).

    .NOTES
        - Author: Michael Free (c) 2024
        - Website: https://github.com/Michael-Free
        - Social: https://mastodon.social/@MichaelFree

    .LINK
        https://github.com/Michael-Free/PSCreateADForest/Docs/Invoke-DomainControllerNetworkSettings.md
 #>
  param(
    [Parameter(Mandatory = $true)]
    [string]$Hostname,
    [Parameter(Mandatory = $true)]
    [string]$IPv4Address,
    [Parameter(Mandatory = $true)]
    [int]$IPv4Prefix,
    [Parameter(Mandatory = $true)]
    [string]$IPv4Gateway,
    [Parameter(Mandatory = $true)]
    [string]$IPv4DNS
  )
  $ipVariables = @(
    $IPv4Address,
    $IPv4Gateway,
    $IPv4DNS,
    $IPv4Prefix
  )

  try {
    Get-OSTarget
    Get-AdapterCount
    Approve-IPVariable -IpVars $ipVariables
    Add-NetworkConfig
    $networkAdapterPrefix = (Get-NetAdapter).ifIndex
    New-NetIPAddress -InterfaceIndex $networkAdapterPrefix -IPAddress $IPv4Address -PrefixLength $IPv4Prefix -DefaultGateway $IPv4Gateway | Out-Null
    Set-DNSClientServerAddress -interfaceIndex $networkAdapterPrefix -ServerAddresses $IPv4DNS | Out-Null
    if ($Hostname -ne $env:ComputerName) {
      Rename-Computer -NewName $Hostname -Force -WarningAction SilentlyContinue
    }
    # output message here
  }
  catch {
    throw "Error completing this script: $($_.Exception.Message)"
  }
}

function Install-NewAdForestAndPromote {
  <#
    .SYNOPSIS
        Installs a new Active Directory Domain Services forest with the specified domain name,
        NetBIOS name, and operating system mode.

    .DESCRIPTION
        This function installs and configures a new Active Directory Domain Services (AD DS) forest.

        It takes the following parameters: `DomainName`, `NetBiosName`, and `Mode`. The function
        checks that the system is running Windows Server, validates the domain and NetBIOS names,
        verifies that the provided operating system mode is supported, and installs the necessary
        features to configure AD DS.

    .PARAMETER DomainName
        The Fully Qualified Domain Name (FQDN) for the new domain in the forest. This should be in
        the format of a valid FQDN (e.g., "example.com").

        The function validates the domain name to ensure it matches the correct format.

    .PARAMETER NetBiosName
        The NetBIOS name for the domain, which must be a single-word name without spaces or special
        characters. This name is used for backward compatibility in networking.

    .PARAMETER Mode
        The operating system mode to use for the new domain forest.
        Supported values are: `Win2008`, `Win2008R2`, `Win2012`, `Win2012R2`, `WinThreshold`, `Default`.
        This parameter determines the version of Active Directory to be used in the forest.

    .INPUTS
        [string]$DomainName
        [string]$NetBiosName
        [string]$Mode

    .OUTPUTS

    .EXAMPLE
        Install-New-AdForestAndPromote -DomainName "example.com" -NetBiosName "EXAMPLE" -Mode "Win2012"

        This command will install a new Active Directory Domain Services forest with the domain
        "example.com" and the NetBIOS name "EXAMPLE" using the "Win2016" AD mode.

    .NOTES
        - Author: Michael Free (c) 2024
        - Website: https://github.com/Michael-Free
        - Social: https://mastodon.social/@MichaelFree

    .LINK
        https://github.com/Michael-Free/PSCreateADForest/Docs/Install-NewAdForestAndPromote.md
    #>
  param(
    [Parameter(Mandatory = $true)]
    [string]$DomainName,
    [Parameter(Mandatory = $true)]
    [string]$NetBiosName,
    [Parameter(Mandatory = $true)]
    [string]$Mode
  )
  try {
    Get-OSTarget
    Approve-DomainVariables -Domain $DomainName -NetBios $NetBiosName -ModeType $Mode
    $password = Read-Host 'Enter Safe Mode Administrator password' -AsSecureString
    Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools -Confirm:$false -Verbose:$false | Out-Null
    Import-Module ADDSDeployment
    $forestProperties = @{
      DomainName                    = $domainName
      DomainNetbiosName             = $netBIOSname
      ForestMode                    = $Mode
      DomainMode                    = $Mode
      CreateDnsDelegation           = $false
      InstallDns                    = $true
      DatabasePath                  = 'C:\Windows\NTDS'
      LogPath                       = 'C:\Windows\NTDS'
      SysvolPath                    = 'C:\Windows\SYSVOL'
      NoRebootOnCompletion          = $true
      Force                         = $true
      SafeModeAdministratorPassword = $password
    }
    Install-ADDSForest @forestProperties -Confirm:$false -Verbose:$false | Out-Null
  }
  catch {
    throw "Installation of New Forest Failed: $($_.Exception.Message)"
  }
}

function Install-DnsService {
  <#
    .SYNOPSIS
        This function installs DNS service and other features, configures DNS server zones,
        and sets up time synchronization.

    .DESCRIPTION
        The `Install-DnsService` function installs the required DNS server features and tools,
        configures the DNS server settings, and sets up Active Directory replication. It also
        configures automatic DNS scavenging, aging for DNS zones, and time synchronization using
        an NTP server.

        This function assumes the system is running Windows Server and has internet access to
        download required features. It also assumes the presence of an Active Directory environment
        for configuring replication sites and subnets.

    .PARAMETER SiteName
        The name of the Active Directory site to be configured. This name will be used to rename
        the default site.

    .PARAMETER SiteLocation
        The location associated with the Active Directory site. This is used when creating a new
        replication subnet for the site.

    .INPUTS
        [string]$SiteName
        [string]$SiteLocation

    .OUTPUTS

    .EXAMPLE
        Install-DnsService -SiteName "NewYork" -SiteLocation "NYC Datacenter"

        This command installs the DNS service, configures the Active Directory site to "NewYork",
        and sets the location to "NYC Datacenter". It also configures DNS scavenging, aging, and
        time synchronization.

    .EXAMPLE
        $result = Install-DnsService -SiteName "London" -SiteLocation "London Datacenter"

        This stores the result of the DNS installation and configuration into the `$result` variable.
        However, the function does not return output, so `$result` will be `$null`.

    .NOTES
        - Author: Michael Free (c) 2024
        - Website: https://github.com/Michael-Free
        - Social: https://mastodon.social/@MichaelFree

    .LINK
        https://github.com/Michael-Free/PSCreateADForest/Docs/Install-DnsService.md
  #>
  param(
    [Parameter(Mandatory = $true)]
    [string]$SiteName,
    [Parameter(Mandatory = $true)]
    [string]$SiteLocation
  )
  try {
    Add-WindowsCapability -Online -Name Rsat.Dns.Tools~~~~0.0.1.0 | Out-Null
    Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 | Out-Null
    Install-WindowsFeature -Name DNS -IncludeManagementTools -IncludeAllSubFeature -Confirm:$false -Verbose:$false | Out-Null
    Install-WindowsFeature -Name RSAT-AD-PowerShell -IncludeAllSubFeature -IncludeManagementTools -Confirm:$false -Verbose:$false | Out-Null
    Import-Module -Name ActiveDirectory -Force
    Import-Module -Name DnsServer -Force

    $IPv4netID = Get-IPv4NetworkID
    Add-DNSServerPrimaryZone -NetworkID $IPv4netID -ReplicationScope 'Forest' -DynamicUpdate 'Secure'
    $defaultSite = (Get-ADReplicationSite | Select-Object DistinguishedName).DistinguishedName
    Rename-ADObject $defaultSite -NewName $SiteName
    New-ADReplicationSubnet -Name $IPv4netID -site $SiteName -Location $SiteLocation
    Register-DnsClient
    Set-DnsServerScavenging -ScavengingState $True -ScavengingInterval 7:00:00:00 -ApplyOnAllZones
    $Zones = Get-DnsServerZone | Where-Object { $_.IsAutoCreated -eq $False -and $_.ZoneName -ne 'TrustAnchors' }
    $Zones | Set-DnsServerZoneAging -Aging $True
    $timePeerList = '0.us.pool.ntp.org 1.us.pool.ntp.org'
    w32tm /config /manualpeerlist:$timePeerList /syncfromflags:manual /reliable:yes /update | Out-Null
  }
  catch {
    throw "Error completing this script: $($_.Exception.Message)"
  }
}

function Add-NewDomainController {
  <#
    .SYNOPSIS
        Installs and configures a new domain controller in an existing Active Directory domain.

    .DESCRIPTION
        The `Add-NewDomainController` function installs the required features for Active Directory Domain Services,
        DNS, and RSAT (Remote Server Administration Tools). It then uses the provided credentials to join a machine
        to an existing Active Directory domain and configure it as a new domain controller.

        The function also gathers domain information, prepares the necessary settings (such as database paths, log
        paths, and replication settings), and runs the `Install-ADDSDomainController` cmdlet to configure the server
        as a domain controller.

        This function assumes the machine is part of an existing Active Directory forest and has internet access to
        download required features. The user running the script must have the necessary administrative privileges to
        install Active Directory Domain Services and configure DNS.

    .PARAMETER DomainName
        The name of the domain in which the new domain controller will be installed.

    .PARAMETER SiteName
        The name of the Active Directory site where the new domain controller will be located.

    .PARAMETER DomainCredential
        The credentials used to join the domain and promote the server to a domain controller.

    .INPUTS

    .OUTPUTS

    .EXAMPLE
        Add-NewDomainController

        This command installs the required features, prompts for user credentials, and configures the current server as
        a new domain controller in the existing Active Directory domain.

    .EXAMPLE
        $domainController = Add-NewDomainController

        This stores the result of the domain controller promotion into the `$domainController` variable, but since the
        function doesn't return output, `$domainController` will be `$null`.

    .NOTES
        - Author: Michael Free (c) 2024
        - Website: https://github.com/Michael-Free
        - Social: https://mastodon.social/@MichaelFree

    .LINK
        https://github.com/Michael-Free/PSCreateADForest/Docs/Add-NewDomainController.md
  #>
  try {
    $currentUsername = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $password = Read-Host -AsSecureString "Enter password for $currentUsername"
    # Maybe add safe mode password here somewhere?
    $domainCredential = New-Object System.Management.Automation.PSCredential ($currentUsername, $password)
    Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools -Confirm:$false -Verbose:$false | Out-Null

    Add-WindowsCapability -Online -Name Rsat.Dns.Tools~~~~0.0.1.0 | Out-Null
    Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 | Out-Null
    Install-WindowsFeature -Name DNS -IncludeManagementTools -IncludeAllSubFeature -Confirm:$false -Verbose:$false | Out-Null
    Install-WindowsFeature -Name RSAT-AD-PowerShell -IncludeAllSubFeature -IncludeManagementTools -Confirm:$false -Verbose:$false | Out-Null

    Import-Module ADDSDeployment
    $domainDetails = Get-DomainInfo
    $forestProperties = @{
      DomainName              = $domainDetails.DomainName
      SiteName                = $domainDetails.SiteName
      CreateDnsDelegation     = $false
      InstallDns              = $true
      DatabasePath            = 'C:\Windows\NTDS'
      LogPath                 = 'C:\Windows\NTDS'
      SysvolPath              = 'C:\Windows\SYSVOL'
      NoRebootOnCompletion    = $true
      Force                   = $true
      Credential              = $domainCredential
      CriticalReplicationOnly = $false
      NoGlobalCatalog         = $false
      ReplicationSourceDC     = $domainDetails.HostName
      #SafeModeAdministratorPassword = $password
    }
    Install-ADDSDomainController @forestProperties
  }
  catch {
    throw "Error completing this script: $($_.Exception.Message)"
  }
}
