[CmdletBinding()]
Param()

Function Get-AzureVMInfo {
    Param(
        [string] $ResourceGroupName = $env:AzureResourceGroupName,
        [string] $VMName = $env:ComputerName
    

    )

    Write-Verbose "[Get-AzureVMInfo] Checking VM Information of $VMName"
    
    $MyMachine = Get-AzureRmVm -Name $VMName -ResourceGroupName $ResourceGroupName
        
    if (!$MyMachine ) { throw "$VMName cannot be found in Resource Group $ResourceGroupName"  }

    $MyNicId = $MyMachine.NetworkProfile.NetworkInterfaces[0].Id

    if (!$MyNicId ) { throw "$VMName cannot find a valid NIC."  }

    if ($MyMachine.NetworkProfile.NetworkInterfaces.Count > 1) {
        Write-Warning "[WARNING] Only primary NIC is supported in Load Balancer using this script. Using NIC[0]"
    }


    $value = $MyNicId -match 'Network/networkInterfaces/(.*)'
    $nicName = $Matches[1]
    
    $nic = Get-AzureRmNetworkInterface -ResourceGroupName $ResourceGroupName -Name $nicName

    $retVal = @{
        Machine = $MyMachine
        NICId = $MyNicId
        NIC = $nic
    }

    return New-Object -TypeName PSObject -Property $retVal
}


