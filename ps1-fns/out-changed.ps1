function Out-Changed() # {{{
{
[CmdletBinding()] param(
  [Parameter(ValueFromPipeLine = $True)] [String] $InputString,
  $RelevantCharacters,
  $Color="Cyan"
)
Begin {
  $relevantpart={Param($str); return $str}
  if($RelevantCharacters -gt 0) {
    $relevantpart={
      Param($str);
      return $str.substring(0,[math]::min($RelevantCharacters,$str.length))
    }
  }
  $c="";
  $cnt=0;
}
Process {
  if((&$relevantpart $_) -ne (&$relevantpart $c)) {
    write-host
    $cnt=0
    $c=$_
  }
  write-host -nonewline $_
  if( ++$cnt -gt 1 ) {
    write-host -foregroundcolor $color -nonewline (" ({0:d})   " -f $cnt)
  }
  write-host -nonewline "`r"
}
End {
 write-host
}
} # }}}

