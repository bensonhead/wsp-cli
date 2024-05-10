function Find-FileAbove # {{{
{
  [CmdletBinding()]
  param(
    [string]$FileName="notes.txt"
    # [string]$StartPath # optional, starting path may be passed in FileName
  )
  $p=get-location
  while( $p -ne "" -and (test-path -path $p -pathtype container) ) {
    $n=join-path $p $FileName
    write-debug ("Check for "+$n.toString())
    if( test-path -path $n -pathtype leaf ) {
      return (get-childitem $n)
    }
    $p=split-path -path $p -parent 
  }
  return $null
}
# }}}
function Get-Snippet() { # {{{
  [CmdletBinding()]
  Param(
    [parameter(ValueFromPipelineByPropertyName = $true)]
	
    [string]$Name,
    [string]$Tag,
    [string]$SourceFile
  )
  if( $SourceFile -eq "" ) {
    $SourceFile=Find-FileAbove
  }
  Write-Verbose "Look for snippet $($name) in $($SourceFile)"
  get-content $SourceFile | foreach-object -begin {
    $inside=0
    $isheader=$false
    $output=0 # count output lines
    $stack=new-object System.Collections.ArrayList
    $seen=new-object System.Collections.ArrayList
  } -process {
    $isheader=$false
    if( $_ -match '(^\s*["#/]*\s*(?<tag>[^ :]+)\s*:)?\s*(?<name>.*?)\s*{{3,3}' ) {
      $isheader=$true

      $sn=[pscustomobject]@{tag=$matches.tag;name=$matches.name}
      if( $Tag -eq "" -or $tag -ieq $sn.tag) { [void]$seen.add($sn) }
      [void]$stack.add($sn)
      if( $name -ieq $sn.name -and $name -ne "" ) {
	Write-Verbose "found $sn|$_"
	++$inside # track how deep withing found snippet
      } elseif( $inside -gt 0 ) {
	Write-Verbose "getting deeper $sn|$_"
        ++$inside
      }
    }
    elseif( $_ -match '}{3,3}') {
      $last=$stack.count-1
      if( $stack[$last].name -ieq $name) {
	Write-Verbose "leave $name"
        --$inside
      } elseif( $inside -gt 0 ) {
        --$inside
      }
      [void](1000+$stack.removeat($last))
    }
    if( $inside -gt 1 -or ($inside -eq 1 -and -not $isheader) ) {
      # skip the opening bracket of the target snippet
      # closing bracket of the target snippet will not be $inside
      write-output $_
      ++$output
    }
    [void]$null
  } -end {
    if( 0 -eq $output ) {
      $seen
    }
  }
} # }}}
function Invoke-Init() { # {{{
# placeholder
# TODO: apply iex in correct context
get-snippet | ?{$_.tag -eq 'init'} | % { get-snippet $_.name } | out-string
} # }}}
