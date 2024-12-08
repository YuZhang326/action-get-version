# Action: Get MinVer Version

A composite GitHub Action that uses the `minver-cli` tool to calculate the version of a project. This action parses the version and provides multiple outputs, including major, minor, patch, revision, and other version-related components.

## Features

- Calculates the version using `minver-cli`.
- Extracts detailed version components such as major, minor, patch, revision, suffix, etc.
- Provides clear outputs for release type (alpha, hotfix, or full release).
- Outputs assembly version in the 4-digit format.

## Inputs

This action does not currently take any user-defined inputs but relies on the project files in the repository.

## Outputs

The following outputs are provided by this action:

| Output            | Description                                                                                     |
|--------------------|-------------------------------------------------------------------------------------------------|
| `version`         | The full version returned by `minver`, e.g., `1.2.3` for a release version or `1.2.3-hotfix.1`. |
| `major`           | The major version number (e.g., `1` for `1.2.3-hotfix.4.5`).                                   |
| `minor`           | The minor version number (e.g., `2` for `1.2.3-hotfix.4.5`).                                   |
| `patch`           | The patch version number (e.g., `3` for `1.2.3-hotfix.4.5`).                                   |
| `revision`        | The revision component of the version (e.g., `5` for `1.2.3-hotfix.4.5`).                      |
| `hotfix`          | The hotfix version number (e.g., `4` for `1.2.3-hotfix.4.5`).                                  |
| `suffix`          | The version suffix (e.g., `alpha`, `hotfix`, or empty for release versions).                   |
| `isrelease`       | `true` if it is a full release version (suffix is empty).                                      |
| `isalpha`         | `true` if it is an alpha release.                                                              |
| `ishotfix`        | `true` if it is a hotfix release.                                                              |
| `assemblyVersion` | The 4-digit assembly version to apply to assemblies.                                           |

## Usage
## How It Works
- This action uses the get-minversion.ps1 PowerShell script to invoke the minver-cli tool.
- The tool calculates the version of the project based on the repository's state and outputs detailed version information.
- The script parses the output and provides structured outputs through the action.
## Requirements
- The minver-cli tool must be available.
- A .NET project or similar must be present in the repository to calculate the version.
## License
This project is licensed under the MIT License. See the LICENSE file for details.


### Example Workflow

```yaml
name: Example Workflow
on:
  push:
    branches:
      - main

jobs:
  calculate-version:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Get MinVer Version
      uses: ./ # Path to this action in your repository

    - name: Output version details
      run: |
        echo "Full Version: ${{ steps.parse-minver-output.outputs.version }}"
        echo "Major: ${{ steps.parse-minver-output.outputs.major }}"
        echo "Minor: ${{ steps.parse-minver-output.outputs.minor }}"
        echo "Patch: ${{ steps.parse-minver-output.outputs.patch }}"
        echo "Revision: ${{ steps.parse-minver-output.outputs.revision }}"
        echo "Hotfix: ${{ steps.parse-minver-output.outputs.hotfix }}"
        echo "Suffix: ${{ steps.parse-minver-output.outputs.suffix }}"
        echo "Is Release: ${{ steps.parse-minver-output.outputs.isrelease }}"
        echo "Is Alpha: ${{ steps.parse-minver-output.outputs.isalpha }}"
        echo "Is Hotfix: ${{ steps.parse-minver-output.outputs.ishotfix }}"
        echo "Assembly Version: ${{ steps.parse-minver-output.outputs.assemblyVersion }}"

