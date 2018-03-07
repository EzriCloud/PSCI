[CmdletBinding()]
param ()


$ErrorActionPreference = "Stop";



Function Disconnect-Me {
    if (!$env:AzureLoadBalancerName) {
        throw "ENV Variable AzureLoadBalancerName is not set"
    }

    if (!$env:AzureResourceGroupName) {
        throw "ENV Variable AzureResourceGroupName is not set"
    }

    Disconnect-LoadBalancerNode -LoadBalancerName $env:AzureLoadBalancerName -ResourceGroupName $env:AzureResourceGroupName -VMName $env:ComputerName -Verbose:$VerbosePreference
}






Function Disconnect-LoadBalancerNode {
    Param(
        [string] $LoadBalancerName = $env:AzureLoadBalancerName,
        [string] $ResourceGroupName = $env:AzureResourceGroupName,
        [string] $VMName,
        [int] $MinimumRequiredNodesAlive = 2
    )

    $lbStatus = Get-LoadBalancerStatus -LoadBalancerName $LoadBalancerName -ResourceGroupName $ResourceGroupName -VirtualMachines $VMName -Verbose:$VerbosePreference

    if ($($lbStatus.TotalInService) -le $MinimumRequiredNodesAlive) {
        throw "I will not remove $VMName from $LoadBalancerName because it would drop $it would drop total nodes ($($lbStatus.TotalInService)) below minimum $MinimumRequiredNodesAlive !!!"
    } else {
        $MachineInfo = Get-AzureVMInfo -VMName $VMName -ResourceGroupName $ResourceGroupName
        $nic = $MachineInfo.NIC
        $nic.IpConfigurations[0].LoadBalancerBackendAddressPools = $null
		$value = Set-AzureRmNetworkInterface -NetworkInterface $nic -ErrorAction Stop

        $NewStatus = Get-NodeLoadBalancerStatus -LoadBalancerName $LoadBalancerName -ResourceGroupName $ResourceGroupName -VMName $VMName

        if (!$NewStatus.CurrentlyInService) {
            Write-Verbose "[Connect-LoadBalancerNode] Good news! $VMName is out of service"
            return $True
        } else {
            throw "We attempted to remove $VMName from the service, but a check of the load balancer indicaited it was still in service. "
        }
        
    }

}


		
	

















