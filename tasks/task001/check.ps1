[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$WorkspacePath
)

$outputPath = Join-Path $WorkspacePath 'hello.txt'
$expected = 'Hello, PowerShellBench!'
$passed = $false
$message = 'hello.txt was not found.'

if (Test-Path -LiteralPath $outputPath -PathType Leaf) {
    $actual = [System.IO.File]::ReadAllText($outputPath).Trim()
    $passed = $actual -eq $expected
    $message = if ($passed) {
        'hello.txt contains the expected text.'
    }
    else {
        "Expected '$expected' but found '$actual'."
    }
}

$result = [pscustomobject]@{
    task_id = 'task001'
    passed  = $passed
    score   = if ($passed) { 1.0 } else { 0.0 }
    checks  = @(
        [pscustomobject]@{
            name    = 'hello_file'
            passed  = $passed
            message = $message
        }
    )
}

$result | ConvertTo-Json -Depth 5

if (-not $passed) {
    exit 1
}
