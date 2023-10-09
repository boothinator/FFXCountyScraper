function Pull-Content($url)
{
    $response = Invoke-WebRequest $url
    return $response.ParsedHtml.getElementById("main-content").parentElement().outerHTML
}

$items = @(@{
    folder = "Policy Plan Amendments"
    name = "2022-CW-2CP"
    plusNumber = "PA-2022-00009"
    district = "Countywide"
    url = "https://www.fairfaxcounty.gov/planning-development/plan-amendments/Countywide-policy-plan-update"
},
@{
    folder = "Manufactured Housing"
    name = "2022-CW-1CP"
    plusNumber = "PA-2022-00006"
    district = "Countywide"
    url = "https://www.fairfaxcounty.gov/planning-development/plan-amendments/manufactured-housing"
},
@{
    folder = "Heritage Resources"
    name = "2017-CW-4CP"
    plusNumber = ""
    district = "Countywide"
    url = "https://www.fairfaxcounty.gov/planning-development/plan-amendments/2017-heritage-resources-plan-update"
},
@{
    folder = "Public Facilities Policy Plan"
    name = "2020-CW-1CP"
    plusNumber = "PA-2020-00026"
    district = "Countywide"
    url = "https://www.fairfaxcounty.gov/planning-development/plan-amendments/public-facilities-policy"
},
@{
    folder = "Public Facilities Plan Map"
    name = "2013-CW-5CP"
    plusNumber = "PA-2020-00003"
    district = "Countywide"
    url = "https://www.fairfaxcounty.gov/planning-development/plan-amendments/public-facilities-plan-map"
},
@{
    folder = "Fairfax Center Area, Phase III, Core Area"
    name = "2013-III-FC1 (C)"
    plusNumber = "PA-2020-00003"
    district = "Braddock"
    url = "https://www.fairfaxcounty.gov/planning-development/fairfax-center"
},
@{
    folder = "Fairfax Center Area, Phase III, Core Area"
    name = "2013-III-FC1 (C)"
    plusNumber = "PA-2020-00003"
    district = "Braddock"
    url = "https://www.fairfaxcounty.gov/planning-development/fairfax-center"
},
@{
    folder = "Centreville Study"
    name = "2022-III-BR1"
    plusNumber = "PA-2022-00008"
    district = "Sully"
    url = "https://www.fairfaxcounty.gov/planning-development/fairfax-center"
},
@{
    folder = "Lorton Visioning"
    name = "2021-IV-LP1"
    plusNumber = "PA-2021-00011"
    district = "Mount Vernon"
    url = "https://www.fairfaxcounty.gov/planning-development/plan-amendments/lorton-visioning"
},
@{
    folder = "Innovation Center TSA North Study"
    name = "2023-III-1UP"
    plusNumber = "PA-2023-00002"
    district = "Dranesville"
    url = "https://www.fairfaxcounty.gov/planning-development/plan-amendments/innovation-center-tsa-north"
},
@{
    folder = "Springfield TSA/CBC Study"
    name = "2023-IV-1S"
    plusNumber = "PA-2023-00003"
    district = "Franconia"
    url = "https://www.fairfaxcounty.gov/planning-development/plan-amendments/springfield-tsa-cbc"
},
@{
    folder = "Penn Daw CBC Land Unit C Study"
    name = "2023-IV-1MV"
    plusNumber = "PA-2023-00004"
    district = "Mount Vernon"
    url = "https://www.fairfaxcounty.gov/planning-development/plan-amendments/penn-daw-cbc-luc"
},
@{
    folder = "Fair Lakes Study"
    name = "2023-III-1FC"
    plusNumber = "PA-2023-00005"
    district = "Springfield"
    url = "https://www.fairfaxcounty.gov/planning-development/plan-amendments/fair-lakes-study"
},
@{
    folder = "Franconia Triangle Study"
    name = "2023-IV-2S"
    plusNumber = "PA-2023-00006"
    district = "Franconia"
    url = "https://www.fairfaxcounty.gov/planning-development/plan-amendments/franconia-triangle"
}<#, # Can't find URL
@{
    folder = "Reston TSA Study"
    name = "2023-III-6UP"
    plusNumber = "PA-2023-00006"
    district = "Franconia"
    url = ""
}#>,
@{
    folder = "Brookside Motel"
    name = "2021-IV-MV1"
    plusNumber = "PA-2021-00023"
    district = "Mount Vernon"
    url = "https://www.fairfaxcounty.gov/planning-development/plan-amendments/brookside-motel"
}
)

$timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
$diffPath = "$($rootPath)/content-$($timestamp).txt"

foreach ($item in $items)
{
    $rootPath = $PSCommandPath | Split-Path -Parent
    $folderPath = "$($rootPath)/$($item.folder)"
    $contentPath = "$($folderPath)/content.html"
    $timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
    $contentTimestampPath = "$($folderPath)/content-$($timestamp).html"

    if (-not (test-path $folderPath)) {
        new-item -ItemType Directory $folderPath
    }

    $prevContent = ""
    if (test-path $contentPath) {
        $prevContent = Get-Content $contentPath
    }

    $item.url
    $content = Pull-Content $item.url
    $content | out-file -Force $contentPath
    $content = Get-Content $contentPath
    #$content = "<p>fake content</p>`n" -split "`n"

    $content | out-file -Force $contentTimestampPath

    $diff = Compare-Object $prevContent $content

    $item.Add("diff", ($diff | ConvertTo-Csv))
    $item | format-list | out-file -append $diffPath -width 100000

    sleep -Milliseconds 200
}