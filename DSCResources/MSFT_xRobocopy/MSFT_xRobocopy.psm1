function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Source,

        [parameter(Mandatory = $true)]
        [System.String]
        $Destination,

        [System.String]
        $Files,

        [System.UInt32]
        $Retry,

        [System.UInt32]
        $Wait,

        [System.Boolean]
        $SubdirectoriesIncludingEmpty,

        [System.Boolean]
        $Restartable,

        [System.Boolean]
        $MultiThreaded,

        [System.String]
        $ExcludeFiles,

        [System.String]
        $ExcludeDirs,

        [System.String]
        $LogOutput,

        [System.Boolean]
        $AppendLog,

        [System.String]
        $AdditionalArgs
    )

    $returnValue = @{
        Source = $Source
        Destination = $Destination
        Files = $Files
        Retry = $Retry
        Wait = $Wait
        SubdirectoriesIncludingEmpty = $SubdirectoriesIncludingEmpty
        Restartable = $Restartable
        Multithreaded = $MultiThreaded
        ExcludeFiles = $ExcludeFiles
        ExcludeDirs = $ExcludeDirs
        LogOutput = $LogOutput
        AppendLog = $AppendLog
        AdditionalArgs = $AdditionalArgs
    }

    $returnValue
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Source,

        [parameter(Mandatory = $true)]
        [System.String]
        $Destination,

        [System.String]
        $Files,

        [System.UInt32]
        $Retry,

        [System.UInt32]
        $Wait,

        [System.Boolean]
        $SubdirectoriesIncludingEmpty,

        [System.Boolean]
        $Restartable,

        [System.Boolean]
        $MultiThreaded,

        [System.String]
        $ExcludeFiles,

        [System.String]
        $ExcludeDirs,

        [System.String]
        $LogOutput,

        [System.Boolean]
        $AppendLog,

        [System.String]
        $AdditionalArgs
    )

    [string]$Arguments = ''
    if ($Retry -ne '') {$Arguments += " /R:$Retry"}
    if ($Wait -ne '') {$Arguments += " /W:$Wait"}
    if ($SubdirectoriesIncludingEmpty -ne '') {$Arguments += ' /E'}
    if ($Restartable -ne '') {$Arguments += ' /MT'}
    if ($ExcludeFiles -ne '') {$Arguments += " /XF $ExludeFiles"}
    if ($ExcludeDirs -ne '') {$Arguments += " /XD $ExcludeDirs"}
    if ($LogOutput -ne '' -AND $AppendLog -eq $true) {
        $Arguments += " /LOG+:$LogOutput"
        }
    if ($LogOutput -ne '' -AND $AppendLog -eq $false) {
        $Arguments += " /LOG:$LogOutput"
     }
    if ($AdditionalArgs -ne $null) {$Arguments += " $AdditionalArgs"}

    try {
        Write-Verbose "Executing Robocopy with arguements: $Arguments"
        Invoke-Robocopy $Source $Destination $Arguments
        }
    catch {
        Write-Warning "An error occured executing Robocopy.exe.  ERROR: $_"
        }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Source,

        [parameter(Mandatory = $true)]
        [System.String]
        $Destination,

        [System.String]
        $Files,

        [System.UInt32]
        $Retry,

        [System.UInt32]
        $Wait,

        [System.Boolean]
        $SubdirectoriesIncludingEmpty,

        [System.Boolean]
        $Restartable,

        [System.Boolean]
        $MultiThreaded,

        [System.String]
        $ExcludeFiles,

        [System.String]
        $ExcludeDirs,

        [System.String]
        $LogOutput,

        [System.Boolean]
        $AppendLog,

        [System.String]
        $AdditionalArgs
    )

    try {
        $result = Invoke-RobocopyTest $Source $Destination
        }
    catch {
        Write-Warning "An error occured while getting the file list from Robocopy.exe.  ERROR: $_"
        }
    
    if ($result -eq 0) {[system.boolean]$result = $true}
     else {[system.boolean]$result = $false}
    
    $result
}

# Helper Functions

function Invoke-RobocopyTest {
param (
    [parameter(Mandatory = $true)]
    [System.String]
    $source,

    [parameter(Mandatory = $true)]
    [System.String]
    $destination
)
    $output = & robocopy.exe /L $source $destination
    $LASTEXITCODE
}
 # Invoke-RobocopyTest C:\DSCTestMOF C:\DSCTestMOF2

function Invoke-Robocopy {
param (
    [parameter(Mandatory = $true)]
    [System.String]
    $source,

    [parameter(Mandatory = $true)]
    [System.String]
    $destination,

    [System.String]
    $Arguments
)

    $output = & robocopy.exe $Source $Destination $Arguments.split(' ')
    if ($output -in (0..1)) {Write-Error "The file copy operation returned error: $ouput"}
    $LASTEXITCODE
}
 # Invoke-Robocopy -source C:\DSCTestMOF -destination C:\DSCTestMOF2 -Arguments '/E /MT'

Export-ModuleMember -Function *-TargetResource