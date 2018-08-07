function Convert-Entry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$GroupName,

        [string[]]$Tags,

        [ValidateScript({
            if($_.name -ne "entry") { throw "The node isn't an entry" }
            if(!$_.title) { throw "The entry doesn't have a title" }
            # validate <media:group
            if(!$_.group -or $_.group.NamespaceURI -ne "http://search.yahoo.com/mrss/") { throw "The entry doesn't have a media:group" }
            if(!$_.group.description) { Write-Warning "The '$GroupName\$($_.Title)' entry doesn't have a description" }
            $true
        })]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Xml.XmlElement]$Entry
    )
    begin {
        $GroupName = (ConvertTo-FileName $GroupName) -replace '\s+'
    }

    process {
        $Title = ConvertTo-FileName $Entry.title
        $Date = ([DateTime]$Entry.Published).ToString("yyyy-MM-dd")
        $FilePath = $GroupName, $Date, $Title -join " " | ConvertTo-Filename

        $thumbnail = "![$($Entry.title)]($($Entry.group.thumbnail.url) `"$($Entry.title)`")"

        Set-Content "$FilePath.md" @"
---
title: $($Entry.title)
date: $Date
tags: $($GroupName.ToLowerInvariant()), $($Tags -join ", ")
author: $($Entry.Author.name) $($Entry.Author.uri)
---

[$thumbnail](https://www.youtube.com/watch?v=$($Entry.videoId))

$($Entry.group.description)
"@ -Encoding UTF8

    }
}