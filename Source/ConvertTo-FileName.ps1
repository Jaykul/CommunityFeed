function ConvertTo-FileName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Name
    )
    begin {
        $characters = [RegEx]::Escape( -join ([IO.Path]::GetInvalidFileNameChars() + @(',','&')))
        $characters = [RegEx]::new("[$characters]", "Compiled")
    }
    process {
        # Strip invalid characters and trailing dots
        # Normalize whitespace to dashes, and make sure there's only ever one dash
        ($Name -replace $characters).TrimEnd(".") -replace '\s+','-' -replace '-+','-'
    }
}