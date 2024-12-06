param (
    # Pass a path to handle version-related information
    [string] $path,
    # Used to specify the output file path to which the results are written
    [string] $outputFile
)

# If the script encounters an error, stop execution immediately
$ErrorActionPreference = 'stop'

. "${PSScriptRoot}\version-properties.ps1"

# Define an exception class named InvocationException, which inherits from the system exception
class InvocationException : System.Exception
{
    [string] $Command
    [string] $Arguments
    [int] $ExitCode
    [string] $Output
    [string] $ErrorOutput
    
# Capture information about external commands (command name, parameters, exit code, standard output, and error output)
    InvocationException($command, $arguments, $exitCode, $output, $errorOutput)
    {
        $this.Command = $command
        $this.Arguments = $arguments
        $this.ExitCode = $exitCode
        $this.Output = $output
        $this.ErrorOutput = $errorOutput
    }
}

# Generic command execution function
function Invoke-Command
{
    param
    (
        [string] $command,
        [string] $arguments
    )
    # Set the command execution environment
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $command
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $arguments
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    # Gets command output and errors
    $stdout = $p.StandardOutput.ReadToEnd()
    $stderr = $p.StandardError.ReadToEnd()
    $lec = $p.ExitCode
    # If the command fails to execute, throw a custom exception
    if (0 -ne $lec)
    {
        $ex = [InvocationException]::new($command, $arguments, $lec, $stdout, $stderr)
        throw $ex
    }
    return $stdout
}

# String splitting function
function Split-Into-Array()
{
    param ( [string] $s )

    return $s.Split("`n").Replace("`r", "").Replace("`n", "")
}

# Get version function
function Get-NextMinVerVersion {
    param ( [string] $path )

    Write-Host "Validating path: $path"
    if (!(Test-Path $path)) {
        Write-Host "Error: The path $path does not exist."
        throw "Invalid path: $path"
    }

    $output = & minver --verbosity error --default-pre-release-identifiers alpha

    Write-Host "Command output:"
    Write-Host $output
    # Extract version information
    $version = $output -split "`n" | Select-Object -Last 2 | Select-Object -First 1
    Write-Host "Extracted version: $version"

    return $version
}

# Writes the version property to the file
function Write-VersionProperties-To-File
{
    param
    (
        [string] $path,
        [VersionProperties] $versionProperties
    )
    Add-Content -Path $path -Value "version=$($versionProperties.Version)"
    Add-Content -Path $path -Value "major=$($versionProperties.Major)"
    Add-Content -Path $path -Value "minor=$($versionProperties.Minor)"
    Add-Content -Path $path -Value "patch=$($versionProperties.Patch)"
    Add-Content -Path $path -Value "revision=$($versionProperties.Revision)"
    Add-Content -Path $path -Value "suffix=$($versionProperties.Suffix)"
    Add-Content -Path $path -Value "hotfix=$($versionProperties.Hotfix)"
    Add-Content -Path $path -Value "isrelease=$($versionProperties.IsRelease)"
    Add-Content -Path $path -Value "isalpha=$($versionProperties.IsAlpha)"
    Add-Content -Path $path -Value "ishotfix=$($versionProperties.IsHotfix)"
    Add-Content -Path $path -Value "assemblyversion=$($versionProperties.AssemblyVersion)"
}
# Call get-nextminverversion to Get the version number
$version = Get-NextMinVerVersion -path $path
# Create a VersionProperties object using the version number
$versionProperties = [VersionProperties]::new($version)
# Call write-versionproperties-to-file To Write the VersionProperties to the File
Write-VersionProperties-To-File -path $outputFile -versionProperties $versionProperties