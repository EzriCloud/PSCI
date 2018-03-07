







## Environment Variables

| Variable | Purpose
|:---------|:-----------------------------------|
---Security---|
AzureClientId | The Service principal Client ID scripts should login as
AzureClientSecret | The service principal client secret scripts should login as
AzureTenantId | Azure Tenant to login as
AzureSubscriptionId | Azure Subscription ID to use
---General---|
AzureResourceGroupName | The default resource group
---Set by OS ---|
ComputerName | (self-set by OS) used when VMName is not provided to a script
---Load Balancers---|
AzureLoadBalancerName | The default load balancer name




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
