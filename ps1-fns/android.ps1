
function Get-AndroidScreenshot([string]$suffix) {
# adbpath
if( $suffix -ne "" -and $suffix[0] -ne "-" ) {
  $suffix="-"+$suffix
}
if( $suffix.indexOf(".") -lt 0 ) {
  $suffix+=".png"
}
$prefix="scr"
adb shell screencap -p /sdcard/screencap.png
adb pull /sdcard/screencap.png ($file=new-filename $prefix $suffix) >$null
write-verbose "saved to $file"
}
set-alias screencap Get-AndroidScreenshot

# re which parses logcat entry from bugreport or logcat directly
$relogcat="^(?<timestamp>\d+-\d+ \d+:\d+:\d+\.\d+)?\s+((?<uid>\d+)\s+)?(?<pid>\d+)\s+(?<tid>\d+)\s+(?<level>[VIEWFD])\s+(?<tag>[^:\s]+)\s*:\s*(?<message>.*)"

