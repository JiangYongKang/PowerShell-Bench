[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$WorkspacePath
)

New-Item -ItemType Directory -Path $WorkspacePath -Force | Out-Null
