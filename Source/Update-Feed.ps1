function Update-Feed {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Type,

        [string[]]$Tags,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Name,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Uri
    )
    process {
        $Tags += $Type
        Invoke-RestMethod -uri $Uri | Convert-Entry -Group ($Name -replace '"') -Tags $Tags
    }
}