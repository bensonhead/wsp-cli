function New-TodayFolder { # {{{
<#
.SYNOPSIS
	Create a new folder prefixed by current date and intiate its contents.

.DESCRIPTION
	Creates a place for a new task or subproject for folder-based workflow.
	Creates a new folder in the current directory. The name of this new
folder is current date followed by suffix.
One empty file, `notes.txt` is created in this directory.
.PARAMETER
#>
  [CmdletBinding()]
  param (
    # suffix to use for a new folder name
    [String]$suffix = ""
  )
  if( $suffix -ne "" ) {
    $suffix="-"+$suffix
  }  
  $d=(get-date -format yyyy-MM-dd)+$suffix
  mkdir $d
  cd $d
  new-item notes.txt
  start .
}

function cldate {
  get-date -format yyyy-MM-dd | set-clipboard
}
# }}}
set-alias mtd New-TodayFolder

# Function: cal {{{
function cal($date)
{
if( $date -eq $null ) { $date=get-date }
else { $date=get-date $date }
$last=get-date ("{0:yyyy-MM-dd}" -f (get-date ("{0:yyyy-MM}-01" -f $date.addmonths(1))).adddays(-1))
$alldays=(1..$last.day) | %{ "{0:yyyy-MM}-{1:d2}" -f $date,$_}
$table=($alldays|get-date) | % -begin {
  $header=@("Su","Mo","Tu","We","Th","Fr","Sa")
  $week=[ordered]@{}
  $header | %{$week[$_]=$null}
  $c=0
  } -process {
    if( $_.dayofweek -eq 0 -and $c -gt 0 ) {
      [pscustomobject]$week
      $week=[ordered]@{}
      $header | %{$week[$_]=$null}
      $c=0
    }
    $week[$header[[int]$_.dayofweek]]=$_.day
    ++$c
  } -end {
    if( $c -gt 0 ) {
      [pscustomobject]$week
    }
  }
  "";"   {0:MMMM yyyy}" -f $date ;$table|ft
}
# }}}


