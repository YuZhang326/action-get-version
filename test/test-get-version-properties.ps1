
# $ErrorActionPreference = 'stop'

$VerbosePreference = 'Continue'


. "${PSScriptRoot}\..\.build\version-properties.ps1"

function Test-ExpectedValue()
{
	param (
		[string] $version,
		[string] $label,
		[string] $actual,
		[string] $expected
	)

	Write-Host "Testing: $label for version: $version"
    	Write-Host "Actual: $actual, Expected: $expected"
	if ($actual -ne $expected)
	{
		$message = "$($version) $($label): expected $($actual) to be $($expected)"
		Write-Host $message
		throw $message
	}
	else
	{
		Write-Host "$($version) $($label): passed"
	}
}

function Test-AllValues
{
	param (
		[VersionProperties] $actual,
		[VersionProperties] $expected
	)
	Write-Host "Comparing actual values with expected values..."
    Write-Host "Actual:"
    $actual | Format-Table -AutoSize
    Write-Host "Expected:"
    $expected | Format-Table -AutoSize
	Test-ExpectedValue $expected.Version "Version" $actual.Version $expected.Version
	Test-ExpectedValue $expected.Version "Major" $actual.Major $expected.Major
	Test-ExpectedValue $expected.Version "Minor" $actual.Minor $expected.Minor
	Test-ExpectedValue $expected.Version "Patch"  $actual.Patch $expected.Patch
	Test-ExpectedValue $expected.Version "Revision" $actual.Revision $expected.Revision
	Test-ExpectedValue $expected.Version "Suffix" $actual.Suffix $expected.Suffix
	Test-ExpectedValue $expected.Version "Hotfix" $actual.Hotfix $expected.Hotfix
	Test-ExpectedValue $expected.Version "IsRelease" $actual.IsRelease $expected.IsRelease
	Test-ExpectedValue $expected.Version "IsAlpha" $actual.IsAlpha $expected.IsAlpha
	Test-ExpectedValue $expected.Version "IsHotFix" $actual.IsHotFix $expected.IsHotFix
	Test-ExpectedValue $expected.Version "AssemblyVersion" $actual.AssemblyVersion $expected.AssemblyVersion
}

function Test-VersionProperties
{
	param (
		[VersionProperties] $expectedVersionProperties
	)

	Write-Host "Testing VersionProperties for version: $($expectedVersionProperties.Version)"
    Write-Host "Expected values:"
    $expectedVersionProperties | Format-Table -AutoSize
	$actualVersionProperties = [VersionProperties]::new($expectedVersionProperties.Version)
	Test-AllValues -actual $actualVersionProperties -expected $expectedVersionProperties 
}

$releasedVersion = [VersionProperties]::new(@{
	Version = '1.1.1'
	Major = '1'
	Minor = '1'
	Patch = '1'
	Revision = '10000'
	Suffix = ''
	Hotfix = ''
	IsRelease = 'true'
	IsAlpha = 'false'
	IsHotFix = 'false'
	AssemblyVersion = '1.1.1.10000'
})

$alphaVersion = [VersionProperties]::new(@{
	Version = '1.2.3-alpha.4'
	Major = '1'
	Minor = '2'
	Patch = '3'
	Revision = '4'
	Suffix = 'alpha'
	Hotfix = ''
	IsRelease = 'false'
	IsAlpha = 'true'
	IsHotFix = 'false'
	AssemblyVersion = '1.2.3.4'
})

$hotfixVersion = [VersionProperties]::new(@{
	Version = '1.32.32-hotfix.2.4'
	Major = '1'
	Minor = '32'
	Patch = '32'
	Revision = '30004'
	Suffix = 'hotfix'
	Hotfix = '2'
	IsRelease = 'false'
	IsAlpha = 'false'
	IsHotFix = 'true'
	AssemblyVersion = '1.32.32.30004'
})

Write-Host "Running test for released version..."
Test-VersionProperties -expectedVersionProperties $releasedVersion

Write-Host "Running test for alpha version..."
Test-VersionProperties -expectedVersionProperties $alphaVersion

Write-Host "Running test for hotfix version..."
Test-VersionProperties -expectedVersionProperties $hotfixVersion
