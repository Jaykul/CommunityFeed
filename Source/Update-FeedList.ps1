function Update-FeedList {
    <#
    .SYNOPSIS
        Fetch YouTube channel feeds and generate webpages
    #>
    [CmdletBinding()]
    param(
        # The output location where markdown will be output
        [Parameter(Mandatory)]
        $Path,

        # The input file containing a list of YouTube feeds
        [Parameter(Mandatory)]
        $FeedList
    )

    $feeds = Import-Csv $FeedList
    ## Allow Tags to be a comma-separated value of it's own
    foreach($feed in $feeds) {
        $feed.Tags = $feed.Tags -split "\s*,\s*"
    }

    Push-Location $Path -ErrorAction Stop

    $feeds | Update-Feed

    Pop-Location
}