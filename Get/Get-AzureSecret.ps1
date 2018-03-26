[CmdletBinding()]
Param()

$ErrorActionPreference = "Stop";

Function Get-AzureSecret {
  param (
     [string] $Name,
     [string] $VaultName = $env:AzureVaultPasswords,
     [switch] $Clipboard
  )

  $secretValue = (Get-AzureKeyVaultSecret -VaultName $VaultName -Name $Name -ErrorAction Stop).SecretValueText
  if ($Clipboard) {
    Write-Host "Copied to your clipboard!"
    $secretValue | Set-Clipboard
  }
  return ($secretValue)

}
