[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$WorkspacePath
)

$outputPath = Join-Path $WorkspacePath 'hello.txt'
Set-Content -LiteralPath $outputPath -Value 'Hello, PowerShellBench!' -Encoding UTF8
