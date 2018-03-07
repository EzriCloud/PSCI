$ErrorActionPreference = "Stop";

Function Login-AzureServicePrincipal {
Param (
    [string] $AzureClientId = $env:AzureClientId,
    [string] $AzureClientSecret = $env:AzureClientSecret
)

if (!$AzureClientId -or !$AzureClientSecret) {
    throw "Cannot login unless AzureClientId and AzureClientSecret are set"
}

$SecurePassword = $AzureClientSecret | ConvertTo-SecureString -AsPlainText -Force
$Credential = new-object -typename System.Management.Automation.PSCredential `
     -argumentlist $AzureClientId, $SecurePassword



# Connect to Azure using SP
$connectParameters = @{
    Credential     = $Credential
    TenantId       = "$Env:AzureTenantId"
    SubscriptionId = "$Env:AzureSubscriptionId"
}

$AzureAccount = Add-AzureRmAccount @connectParameters -ServicePrincipal -ErrorAction Stop -Verbose:$VerbosePreference

return $AzureAccount

}