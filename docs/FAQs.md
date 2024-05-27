<h1 align="center">
  <br>
  <!--<a href=""><img src="" alt="Markdownify" width="200"></a>-->
  <br>
  Frequently Asked Questions
  <br>
</h1>

## Troubleshooting

### CouldNotAutoloadMatchingModule
The following error occurs when the Execution Policy is set to a restricted value.

You can fix this by running `Set-ExecutionPolicy -ExecutionPolicy Unrestricted`

```powershell
Get-ibPSVersion : The 'Get-ibPSVersion' command was found in the module 'ibPS', but the module could not be loaded.
For more information, run 'Import-Module ibPS'.
At line:1 char:1
+ Get-ibPSVersion
+ ~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (Get-ibPSVersion:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CouldNotAutoloadMatchingModule
```