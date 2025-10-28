Param ($FolderName)
Function New-WVDConfigurationFiles
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        $FolderName

    )
    Begin
    {
        
    }

    Process
    {

        $TargetFolder = "$PSScriptRoot\Configurations\$FolderName"
        If (-not(Test-Path $TargetFolder))
        {
            New-Item $TargetFolder -ItemType Directory | Out-Null
            Copy-Item "$PSScriptRoot\Configurations\Templates\*.*" "$PSScriptRoot\Configurations\$FolderName"
        }
        Else
        {
            Write-Warning "Folder $FolderName already exists, exiting script!"
        }
        
        
    }

    End
    {

    }
}

New-WVDConfigurationFiles -FolderName $FolderName