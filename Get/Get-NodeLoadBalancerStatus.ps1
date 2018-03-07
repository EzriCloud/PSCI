[CmdletBinding()]
Param(
)

$ErrorActionPreference = "Stop";

Function Get-NodeLoadBalancerStatus {
    param (
        [string] $LoadBalancerName = $env:AzureLoadBalancerName,
        [string] $ResourceGroupName = $env:AzureResourceGroupName,
        [string] $VMName = $env:ComputerName
    )

    Write-Verbose "[Get-NodeLoadBalancerStatus] Checking status of $VMName"

    $MachineInfo = Get-AzureVMInfo -VMName $VMName -ResourceGroupName $ResourceGroupName
    $nic = $($MachineInfo.NIC)
    $NodeIsInService = ($nic.IpConfigurations[0].LoadBalancerBackendAddressPools.Count -gt 0)


    $IndividualretVal = @{
        VMName = $VMName
        NodeIPAddress = $nic.IpConfigurations[0].PrivateIpAddress
        CurrentlyInService = $NodeIsInService

    }

    return New-Object -TypeName PSObject -Property $IndividualRetVal
        
}


#Accept Comma separated list of VMs
Function Get-LoadBalancerStatus {
    [CmdletBinding()]
    Param(
        [string] $LoadBalancerName = $env:AzureLoadBalancerName,
        [string] $ResourceGroupName = $env:AzureResourceGroupName,
        [string] $VirtualMachines = $env:ComputerName
    )
    Write-Verbose "[Get-LoadBalancerStatus] Checking status of $VirtualMachines"

     #Information about the Load Balancer as a whole


    $lb = Get-AzureRmLoadBalancer -Name $LoadBalancerName -ResourceGroupName $ResourceGroupName
    $lbCount = $lb.BackendAddressPools.BackendIpConfigurations.Count


    #Information about each node we requested in the VirtualMachine parameter

    $nodeStatus = New-Object System.Collections.ArrayList

    $VirtualMachines.Split(",") | ForEach-Object {
        $lbStatus = Get-NodeLoadBalancerStatus -LoadBalancerName $LoadBalancerName -ResourceGroupName $ResourceGroupName -VMName $_
        $value = $nodeStatus.Add($lbStatus)

    }

   

    #Format our return data
    $retVal = @{
        NodeReport = $nodeStatus
        TotalInService = $lbCount
    }

    return New-Object -TypeName PSObject -Property $retVal
    

    return $retVal
}