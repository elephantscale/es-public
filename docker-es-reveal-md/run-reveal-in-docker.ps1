
param(
    [string]$image_id,
    [string]$cmd
  )

  IF ([string]::IsNullOrWhitespace($image_id)){
    Write-Host "Usage:  $image_id    <image name>    [optional command]"
    Write-Host "Missing Docker image id.  Exiting."
    exit -1
  }

  $working_dir = $(Get-Location)
  $utils_dir = Split-Path -Parent (Split-Path -Parent $myInvocation.MyCommand.Definition)


   $Command = "docker run -it --shm-size=1gb -p 2000:2000 -p 35729:35729 -v $($working_dir):/home/ubuntu/dev -v $($utils_dir):/home/ubuntu/utils  $image_id  $cmd"

   #Write-Host $Command.Replace("\", "/")

   Invoke-Expression  $Command.Replace("\", "/")
