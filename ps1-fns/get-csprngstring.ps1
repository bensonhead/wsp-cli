function Get-CSPRNGString([int]$Count=22, $Alphabet) # {{{
{
$rnd=[System.Security.Cryptography.RandomNumberGenerator]::Create()
if( $Alphabet -eq $null ) { $Alphabet = "A-Za-z0-9" }
# Special case: if alphabet is bytes or ! return byte array
if( @("!","bytes","base64") -contains $alphabet ) {
  $b=[byte[]]@(0) * $Count
  $rnd.GetBytes($b)
  if( $alphabet -eq "base64" ) { return [System.convert]::ToBase64String($b) }
  return $b
}
$uc,$lc,$dg=[System.Text.Encoding]::ascii.getbytes('aA0')



$rs=[byte[]]@()
$re=[byte[]]@()
for( $i=0; $i -lt $Alphabet.length; ++$i ) {
  $s=[System.Text.Encoding]::ascii.getbytes($Alphabet[$i]);
  $e=$s;
  if( $i+2 -lt $Alphabet.length -and $Alphabet[$i+1] -eq '-' ) {
    $e=[System.Text.Encoding]::ascii.getbytes($Alphabet[$i+2])
    $i+=2
  }

  $rs+=@($s);
  $re+=@($e);
}



$res=@()
$b=[byte[]]@(0)
for($i=0; $i -lt $count; ++$i ) {
  do {
    $rnd.GetBytes($b)
    $b[0]=$b[0] -band 0x7f
    $inSet= $false
    for( $j=0; $j -lt $rs.length; ++$j ) {
      if( $b[0] -ge $rs[$j] -and $b[0] -le $re[$j] ) {
        $inSet=$true
        break
      }
    }
  } while (-not $inSet)
  $res+=[System.Text.Encoding]::ascii.getchars($b);
}
$res -join ''
}
#}}}
Set-Alias random Get-CSPRNGString
