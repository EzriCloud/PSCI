[CmdletBinding()]
Param(
)

$ErrorActionPreference = "Stop"


Function Connect-Me {
    if (!$env:AzureLoadBalancerName) {
        throw "ENV Variable AzureLoadBalancerName is not set"
    }

    if (!$env:AzureResourceGroupName) {
        throw "ENV Variable AzureResourceGroupName is not set"
    }

    return (Connect-LoadBalancerNode -LoadBalancerName $env:AzureLoadBalancerName -ResourceGroupName $env:AzureResourceGroupName -VMName $env:ComputerName -Verbose:$VerbosePreference)
}


Function Connect-LoadBalancerNode {
    Param(
        [string] $LoadBalancerName = $env:AzureLoadBalancerName,
        [string] $ResourceGroupName = $env:AzureResourceGroupName,
        [string] $VMName
    )



    $CurrentStatus = Get-NodeLoadBalancerStatus -LoadBalancerName $LoadBalancerName -ResourceGroupName $ResourceGroupName -VMName $VMName


    if ($CurrentStatus.CurrentlyInService) {
        Write-Warning "$VMName was already in service. Nothing to do here."
        return $True
    } else {

        $lb = Get-AzureRmLoadBalancer -Name $LoadBalancerName -ResourceGroupName $ResourceGroupName

        $MachineInfo = Get-AzureVMInfo -VMName $VMName -ResourceGroupName $ResourceGroupName


        $nic = $MachineInfo.NIC
        $nic.IpConfigurations[0].LoadBalancerBackendAddressPools = $lb.BackendAddressPools
        $value = Set-AzureRmNetworkInterface -NetworkInterface $nic

        $NewStatus = Get-NodeLoadBalancerStatus -LoadBalancerName $LoadBalancerName -ResourceGroupName $ResourceGroupName -VMName $VMName

        if ($NewStatus.CurrentlyInService) {
            Write-Verbose "[Connect-LoadBalancerNode] Good news! $VMName is back in service"
            return $True
        } else {
            throw "We attempted to place $VMName back into service, but a check of the load balancer indicaited it was still not servicing customers. "
        }



    }








}
