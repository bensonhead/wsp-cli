# Function: tclip -- put object as a table on a clipboard (ready to paste to xl) {{{
function tclip() {
  $input | convertto-csv -NoTypeInformation -Delimiter "`t" | Set-Clipboard
}
# }}}

