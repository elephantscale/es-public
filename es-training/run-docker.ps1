
param(
    [Parameter(Mandatory=$false, Position=0)]
    [String]
    $image="elephantscale/es-training:prod",

    [Parameter(Mandatory=$false, Position=1)]
    [String]
    $cmd,

    [Parameter(Mandatory=$false, Position=2)]
    [String]
    $p="bingobob123"
)


IF ([string]::IsNullOrWhitespace($image)) {
    Write-Host "Usage:  $image    <image name> [cmd] [-p] <password>"
    Write-Host "Missing Docker image id.  Exiting."
    exit -1
}


$working_dir = $(Get-Location)

$data_dir = ${working_dir}/data


$command = "docker run -it -v ${working_dir}:/home/ubuntu/dev -v ${data_dir}:/data  -v ${data_dir}:/home/ubuntu/data -p 80:80 -p 2181:2181 -p 2222:22 -p 3389:3389 -p 4040-4050:4040-4050 -p 6006:6006 -p 8000:8000 -p 8001:8001 -p 8080:8080 -p 8081:8081 -p 8787:8787 -p 8888:8888 -p 9000:9000 -p 9001:9001 -p 9092:9092 -p 10000-10100:10000-10100 -e PASSWORD=${p} ${image} ${cmd}"
Invoke-Expression $command
