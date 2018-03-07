[CmdletBinding()]
Param(
    [String] $LoadFilter = "*"
)

$scriptName = split-path -leaf $MyInvocation.MyCommand.Definition
$rootPath = split-path -parent $MyInvocation.MyCommand.Definition
$scripts = Get-ChildItem -Recurse $rootPath -in "$LoadFilter.ps1" | ?{ $_.Name -ne $scriptName }


foreach ( $item in $scripts ) {
    Write-Verbose "[Import Module] $($item.FullName)"
    . $item.FullName -ErrorAction Stop
}