Write-Host "Wait for it..."
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
Add-Type -AssemblyName System.Windows.Forms
$cl=[System.Type]"System.Windows.Forms.Clipboard"
if( $cl -eq $null ) {
  Write-Error "Cannot access clipboard"
  return
}
$png=([System.Type]"System.Drawing.Imaging.ImageFormat")::Png
Write-Host "# Ready to save. Copy image to clipboard, it will be saved automatically as a new file."
while($true)
{
  
  if( $cl::ContainsImage() ) {
    $filename=new-filename $([System.IO.Path]::Combine($PWD,[string]$prefix)) .png
    $cl::GetImage().Save( $filename, $png)
    Write-Host "#img`n$filename"
  } elseif( $cl::ContainsText() ) {
    Write-Host "#text"
    Write-Host $cl::GetText()
  } else {
    Start-Sleep -Milliseconds 200
    continue
  }
  $cl::Clear()
  # Write-Host "Waiting for image in clipboard"
}
}
# }}}
AutoSave-ClipImage $([System.IO.Path]::GetFileName($PWD))
Read-Host
