[CmdletBinding()]
  Param()

$ErrorActionPreference = "Stop";

Function Get-EnvironmentParameters {
  param (
    [string] $EnvironmentName,
    [string] $SecretVault = $env:AzureVaultEnvConfig

  )

    $secrets = Get-AzureKeyVaultSecret -VaultName $SecretVault -ErrorAction Stop
    $envConfig = @{}

    $globalSecrets = $secrets.GetEnumerator() | Where-Object { $_.Name -notlike "*-*" }
    $envSecrets = $secrets.GetEnumerator() | Where-Object { $_.Name -Like "*-$EnvironmentName" }

   


    $globalSecrets | ForEach-Object {
          Write-Host "[SECRET] $($_.Name) (Global)"
	         $value = $envConfig.add( $_.Name, (Get-AzureKeyVaultSecret -VaultName $SecretVault -Name $_.Name -ErrorAction Stop).SecretValueText)
         }

    $envSecrets | ForEach-Object {
	          $SecretName = $_.Name -Replace "-$EnvironmentName"
	           Write-Host "[SECRET] $SecretName (Env Override)"
             $envConfig[$SecretName] = (Get-AzureSecret -VaultName $SecretVault -Name $_.Name)
           }

    #A final word of caution should the env name be typed wrong (we wouldn't know)
    if ($envSecrets.Count -eq 0){
             Write-Warning "We looked for environment overriding values for $EnvironmentName but none were found. Accepting all defaults with no overrides. Are you sure this is the right Environment Name?"
   }

return $envConfig

}
