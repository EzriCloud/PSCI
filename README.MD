
## TL;DR

1. Set the Environment Variables listed in the section below.
```
ipmo .\psci.ps1 -Force
Login-AzureServicePrincipal

```


## Commands

### Security
1. Login-AzureServicePrincipal - Automatically login, through the use of pre-defined environment variables.




### Azure Virtual MachineInfo
1. Get-AzureVMInfo
1. Get-NodeLoadBalancerStatus : Retrieve information about a single node being included/excluded from the load balancer


### Load Balancers

1. Get-LoadBalancerStatus : Retrieve information about the ENTIRE load balancer, and what nodes are currently servicing it. (You can pass in a CSV set of machine names to see status of a set of nodes)
1. Connect-LoadBalancerNode
1. Disconnect-LoadBalancerNode

### Common Parameters ###

Argument | Purpose
:-------:|:-----------------------|
-LoadBalancerName| The Load Balancer name to disconnect / reconnect from. This defaults to the machine's environment variable AzureLoadBalancerName
-ResourceGroupName | The resource group where the Load Balancer exists, defaults to machine's environment variable `AzureResourceGroupName`. For now, it's assumed load balancers and compute instances are in the same resource group.
-VMName | The name of the compute VM to remove/place. Defaults to default computer hostname.
-MinimumRequiredNodesAlive | *Disconnect Only*: A minimum number of nodes that must be alive.  Removal will not take place if violating this threshold would occur.




## Environment Variables

| Variable | Purpose
|:---------|:-----------------------------------|
|---Security---|
|AzureClientId | The Service principal Client ID scripts should login as
|AzureClientSecret | The service principal client secret scripts should login as
|AzureTenantId | Azure Tenant to login as
|AzureSubscriptionId | Azure Subscription ID to use
|---Key Vaults---|
|AzureVaultEnvConfig | What vault will be find deployment configuration settings in?
|AzureVaultPasswords | What vault should we pull default passwords from - must be different than AzureVaultEnvConfig!
|---General---|
|AzureResourceGroupName | The default resource group
|---Set by OS ---|
|ComputerName | (self-set by OS) used when VMName is not provided to a script
|---Load Balancers---|
|AzureLoadBalancerName | The default load balancer name


## Examples
```
[CmdletBinding()]
Param()

Write-Host $VerbosePreference

Import-Module .\PSCI\Import-PSCI.ps1 -Force -Verbose:$VerbosePreference

$MyAzureAccount = Login-AzureServicePrincipal
$ResourceGroupName = "webservers"
$lbName = "lb-webserver-primary"


#Get information about a Virtual Machine
#$serverInfo = Get-AzureRmVm -Name "internalad" -ResourceGroupName $ResourceGroupName
#$serverInfo | Format-Table


#Load Balancer Things

#$lbStatus = Get-LoadBalancerStatus -LoadBalancerName $lbName -ResourceGroupName $ResourceGroupName -VirtualMachines "server1,server2,server3" -Verbose:$VerbosePreference
#$($lbStatus.NodeReport) | Format-Table
#Write-Host $lbStatus.TotalInService



#Connect-LoadBalancerNode -LoadBalancerName $lbName -ResourceGroupName $ResourceGroupName -VMName "server1"


Disconnect-LoadBalancerNode -LoadBalancerName $lbName -ResourceGroupName $ResourceGroupName -VMName "server1" -Verbose:$VerbosePreference
Connect-LoadBalancerNode -LoadBalancerName $lbName -ResourceGroupName $ResourceGroupName -VMName "server1" -Verbose:$VerbosePreference


#Am I in service?
# Get-NodeLoadBalancerStatus -LoadBalancerName $lbName -ResourceGroupName $ResourceGroupName

#Is My partner in servce?
#Get-NodeLoadBalancerStatus -LoadBalancerName $lbName -ResourceGroupName $ResourceGroupName -VMName server1
```
