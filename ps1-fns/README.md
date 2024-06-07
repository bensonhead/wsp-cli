== Usage notes

=== secret-protection.ps1

Implements two functions, `ConvertTo-ProtectedString` and
`ConvertFrom-ProtectedString`, aliased as `protect` and `unprotect`

They can be use to embed secret login credentials in scripts in secure-ish manner.

For example, to embed a password in a protected format enter:
```
protect pass1234 -SaveToClipboard
```

Encrypted string representing `pass1234` is copied to clipboard.
Then go to a ps1 script where this password needs to be used and paste encrypted result in the script. Use `unprotect` function to recover the password.

```
#  paste here ---V...
$pass=unprotect "AQAAANCMnd8BFdERjHoAwE/Cl+sBAAAAuqP6AFaooEicp6U9VbUgHQAAAAACAAAAAAADZgAAwAAAABAAAAAAUlRzy3/jxgaqqvR2Zr1KAAAAAASAAACgAAAAEAAAAPInlUmUzc4DlhL/5zuadpoQAAAAF/2XDrPPcG7IyAZANPQKBBQAAACc2p6H27okjHiMzl6b3h0ttllW9w=="
echo "Login to Server using password ${pass}"
...
```
At this point in the script `$pass` will be "pass1234", but if this script is somehow leaked or checked in to public repository, there is allegedly no way to determine that by inspecting just the information from the script.

For extra protection, define a `$EXTRA_ENTROPY_FOR_SECRET_PROTECTION` variable containing base 64 string with extra entropy. This enrtropy should be the same for both protect and unprotect, otherwise protected secret will be unrecoverable.
You can use `random` function from `get-csprngstring.ps1` to generate this extra entropy:
```
> random 16 base64
okS60AIW7nXM9RFNuFerdQ==
```
then put `$EXTRA_ENTROPY_FOR_SECRET_PROTECTION="okS60AIW7nXM9RFNuFerdQ=="` in your profile.

*Note.* There are 2 built-in Powershell functions, `ConvertTo-SecureString` and `ConvertFrom-SecureString`, which may be already doing exactly what I am trying to do here, but I have not figured out how to use them in this use scenario.
