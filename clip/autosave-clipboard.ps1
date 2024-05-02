function New-FileName([string]$prefix, [string]$suffix=".log") # {{{
{
if( $suffix.indexOf(".") -lt 0 ) { $suffix="."+$suffix }
if( $prefix -ne "" ) { $prefix=$prefix+"-" }
$prefix+=get-date -format yyyyMMdd
$np=$prefix+$suffix
if( -not (Test-Path ($prefix+"*"+$ext)) ) {
  return $np
}
$ext=$suffix.substring($suffix.indexOf("."))
$z=0
do {
  --$z;
  $np=$prefix+$z+$suffix
} while( (Test-Path $np) -or (Test-Path ($prefix+$z+"-*"+$ext)) )
return $np
} #}}}
function AutoSave-ClipImage([string]$prefix="") # {{{
{
Write-Host "Wait for it..."
Add-Type -AssemblyName System.Windows.Forms
$cl=[System.Type]"System.Windows.Forms.Clipboard"
if( $cl -eq $null ) {
  Write-Error "Cannot access clipboard"
  return
}
$png=([System.Type]"System.Drawing.Imaging.ImageFormat")::Png
while($true)
{
  Write-Host "Waiting for image in clipboard"
  while(-not $cl::ContainsImage()) {
    Start-Sleep -Milliseconds 200
  }
  $filename=new-filename $([System.IO.Path]::Combine($PWD,[string]$prefix)) .png
  $cl::GetImage().Save( $filename, $png)
  Write-Host "$filename"
  $cl::Clear()
}
}
# }}}
AutoSave-ClipImage $([System.IO.Path]::GetFileName($PWD))

