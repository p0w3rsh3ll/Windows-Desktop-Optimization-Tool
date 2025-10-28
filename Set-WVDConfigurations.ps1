Param (
    $ConfigurationFile,
    $ConfigFolderName
)
Function Set-WVDConfigurations
{
    [Cmdletbinding()]
    Param 
    (
        [Parameter()]
        $ConfigurationFile,
        
        [Parameter()]
        $ConfigFolderName
    )

    Begin {
        Switch -WildCard ($ConfigurationFile)
        {
            AppxPackages*        {$PropName = "AppxPackage"}
            AutoLoggers*         {$PropName = "KeyName"}
            DefaultUserSettings* {$PropName = "KeyName"}
            EdgsSettings*        {$PropName = "RegItemValueName"}
            LanManWorkstation*   {$PropName = ""}
            PolicyRegSettings*   {$PropName = "RegItemValueName" }
            ScheduledTasks*      {$PropName = "ScheduledTask"}
            Services*            {$PropName = "Name"}
        }
    }

    Process 
    {
        If (-not($ConfigurationFile.endsWith(".json") ))
        {
            $ConfigurationFile = "{0}.json" -f $ConfigurationFile
        }
        $TargetFile = "$PSScriptRoot\Configurations\$ConfigFolderName\$ConfigurationFile"
        if (Test-Path $TargetFile)
        {
            $Content = Get-Content $TargetFile -Raw | ConvertFrom-Json
            foreach ($Config in $Content)
            {
                #$FirstProp = $Config | Get-Member -MemberType NoteProperty | Select-Object -First 1
                $Name = $Config."$($PropName)"
                $Response = Read-Host "Enable '$Name'? [A]pply or [Enter] for 'Skip'"
                if ($Response -eq 'A' -or $Response -eq "a")
                {
                    $Config.OptimizationState = 'Apply'
                }
                else 
                {
                    $Config.OptimizationState = 'Skip'
                }
            }
            $Content | ConvertTo-Json -Depth 10 | Set-Content $TargetFile
        }
        else 
        {
            Write-Warning "File $TargetFile not found, exiting script!"    
        }
    }

    End {}
}

Set-WVDConfigurations -ConfigurationFile $ConfigurationFile -ConfigFolderName $ConfigFolderName 