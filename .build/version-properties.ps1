
$ErrorActionPreference = 'stop'

class VersionProperties
{
    [string] $Version
    [string] $Major
    [string] $Minor
    [string] $Patch
    [string] $Revision
    [string] $Suffix
    [string] $Hotfix
    [string] $IsRelease
    [string] $IsAlpha
    [string] $IsHotfix
    [string] $AssemblyVersion

    # Default constructor
    VersionProperties() { $this.Init(@{}) }
    VersionProperties([hashtable]$Properties) { $this.Init($Properties) }

    VersionProperties([string] $version)
    {
        $v = $this
        $v.Version = $version

        $releasePattern = '^(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$'
        if ($version -match $releasePattern)
        {
            $v.Major = $Matches.major
            $v.Minor = $Matches.minor
            $v.Patch = $Matches.patch
            $v.Hotfix = ''
            $v.Revision = 10000
            $v.Suffix = ''
            $v.IsRelease = 'true'
            $v.IsAlpha = 'false'
            $v.IsHotfix= 'false'
            $v.AssemblyVersion= "$($v.Major).$($v.Minor).$($v.Patch).$($v.Revision)"
            return
        }

        $alphaPattern = '^(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)\-alpha.(?<build>\d+)$'
        if ($version -match $alphaPattern)
        {
            $v.Major = $Matches.major
            $v.Minor = $Matches.minor
            $v.Patch = $Matches.patch
            $v.Hotfix = ''
            $v.Revision = $Matches.build
            $v.Suffix = 'alpha'
            $v.IsRelease = 'false'
            $v.IsAlpha = 'true'
            $v.IsHotfix= 'false'
            $v.AssemblyVersion= "$($v.Major).$($v.Minor).$($v.Patch).$($v.Revision)"
            return
        }

        $hotfixPattern = '^(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)\-hotfix.(?<hotfix>\d+).(?<build>\d+)$'
        if ($version -match $hotfixPattern)
        {
            $v.Major = $Matches.major
            $v.Minor = $Matches.minor
            $v.Patch = $Matches.patch
            $v.Hotfix = $Matches.hotfix
            $v.Revision = ([Convert]::ToInt32($Matches.hotfix) + 1) * 10000 + [Convert]::ToInt32($Matches.build)
            $v.Suffix = 'hotfix'
            $v.IsRelease = 'false'
            $v.IsAlpha = 'false'
            $v.IsHotfix= 'true'
            $v.AssemblyVersion= "$($v.Major).$($v.Minor).$($v.Patch).$($v.Revision)"
            return
        }

        throw "the version $($version) is not supported"
    }

    # Convenience constructor from hashtable
    [void] Init([hashtable]$Properties)
    {
        foreach ($Property in $Properties.Keys)
        {
            $this.$Property = $Properties.$Property
        }
    }
}