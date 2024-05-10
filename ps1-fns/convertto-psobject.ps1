function ConvertFrom-Text() { # {{{
  param(
    [string]$Pattern
  )
$input |
Select-String -allmatches -Pattern $pattern |
  % {
     foreach( $m in $_.matches ) {
       $o=[pscustomobject]@{}
       foreach( $g in $m.groups ) {
	 if( $g.name -ne 0 ) {
           $o | add-member -membertype noteproperty -name $g.name -value $g.value
	 }
       }
       $o
     }
  }
<#
.SYNOPSIS
Parse input strings into powershell objects based on supplied regular expression.

.INPUTS
string

.OUTPUTS
PsCustomObject

.DESCRIPTION
Try to match each input line to supplied regular expression pattern. Each matching string becomes PsCustomObject on the output. If the Pattern has named subgroups, such as "(?<number>[0-9]+), the output object will have a property named "number" with a value of whatever matched against it.

.LINK
Convertfrom-String

.EXAMPLE
cat sample-log.lc | Convertfrom-Text -pattern "^(?<timestamp>\d+-\d+ \d+:\d+:\d+\.\d+)?\s+((?<uid>\d+)\s+)?(?<pid>\d+)\s+(?<tid>\d+)\s+(?<level>[VIEWFD])\s+(?<tag>[^:\s]+)\s*:\s*(?<message>.*)"
Parses Android logcat entries and creates object with properties 
timestamp, uid, pid, tid, level, tag and message

#>
} # }}}
function ConvertTo-Pivot([string]$Row,[string]$Column,[string]$Value="") { #  {{{
 $input | Foreach-Object -begin {
    $row_set=@{}
    $column_set=@{}
    $row_order=@()
    $column_order=@()
    $cells=@{}
  } -process {
    $r=$_.$Row
    $c=$_.$Column
    if( -not $row_set.containsKey($r) ) {
      $cells[$r]=@{}
      $row_set[$r]++
      $row_order+=$r
    }
    if( -not $column_set.containsKey($c) ) {
      $column_set[$c]++
      $column_order+=$c;
    }

    if( $value -eq "" ) {
      $cells[$r][$c]++
    } else {
      # name of a field: only value of a field or "<many>"
      if( $cells[$r][$c] -eq $null ) {
        $cells[$r][$c]=$_.$Value
      } else {
        $cells[$r][$c]="<many>"
      }
      # TODO: more functions
    }
  } -end {
    # TODO: resort column_order and/or row_order; otherwise they are in the
    # order of first appearance
    foreach( $r in $row_order ) {
      $o=[pscustomobject]@{$row=$r}
      foreach( $c in $column_order ) {
        $o | Add-Member -MemberType NoteProperty -Name $c -Value ($cells[$r][$c])
      }
      $o
    }
  }
} # }}}

