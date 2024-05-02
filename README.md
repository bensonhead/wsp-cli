# wsp-cli

## Powershell configuration

To allow powershell to run scripts, modify the execution policy (as admin):

```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
Get-ExecutionPolicy -List
```
