[CmdletBinding()]
Param()


Function Format-MSDeploy {
    param(
      [String] $Source,
      $envConfig
    )

    $deployrArgs = New-Object System.Collections.ArrayList($null)
    $value = $deployrArgs.Add("-verb:sync")

    $envConfig.Keys | ForEach-Object {
	    $stub = $deployrArgs.Add("-setParam:Name=""$_"",value=""$($envConfig[$_])""")

    }


    #-dest:auto or -dest:Something Else?
    if ($envConfig['dest']) {
      $value = $deployrArgs.Add('-dest:' + $envConfig['dest'])
    } else {
      $value = $deployrArgs.Add("-dest:auto")
    }

    $value = $envConfig.Remove("dest")

    #source is always package for now
    $value = $deployrArgs.Add("-source:package=$($Source)")

    return $deployrArgs

}
