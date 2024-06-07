Add-Type -AssemblyName System.Security
function ConvertTo-ProtectedString([string]$secret, [switch]$SaveToClipboard, [string]$ExtraEntropyBase64=$EXTRA_ENTROPY_FOR_SECRET_PROTECTION)
{
  if( $secret -eq "" ) {
    $secret=Read-Host "Enter secret value"
    $SaveToClipboard=$true
  }
  $entropy=[System.Convert]::FromBase64String($ExtraEntropyBase64)
  $scope=[System.Security.Cryptography.DataProtectionScope]::CurrentUser
  $data=[System.Text.Encoding]::Utf8.GetBytes($secret)
  $protected=[System.Convert]::ToBase64String([System.Security.Cryptography.ProtectedData]::Protect($data, $entropy, $scope))
  if( $SaveToClipboard ) {
    $protected | Set-Clipboard
  } else {
    $protected
  }
}

function ConvertFrom-ProtectedString([string]$protectedsecret, [switch]$SaveToClipboard, [string]$ExtraEntropyBase64=$EXTRA_ENTROPY_FOR_SECRET_PROTECTION)
{
  $entropy=[System.Convert]::FromBase64String($ExtraEntropyBase64)
  $scope=[System.Security.Cryptography.DataProtectionScope]::CurrentUser
  $data=[System.Convert]::FromBase64String($protectedsecret)
  $unprotecteddata=[System.Security.Cryptography.ProtectedData]::Unprotect($data, $entropy, $scope)
  try {
    $str=[System.Text.Encoding]::Utf8.GetString($unprotecteddata)
    if( $SaveToClipboard ) {
      $str | Set-Clipboard
    } else {
      $str
    }
  } catch [Exception] {
  $unprotecteddata
  }
}
set-alias protect ConvertTo-ProtectedString
set-alias unprotect ConvertFrom-ProtectedString
