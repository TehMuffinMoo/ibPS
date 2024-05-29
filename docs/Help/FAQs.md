<h1 align="center">
  <br>
  <!--<a href=""><img src="" alt="Markdownify" width="200"></a>-->
  <br>
  Frequently Asked Questions
  <br>
</h1>

### Enable menu based auto-complete (Tab-completion)
In Powershell v5, auto-complete is set to only resolve individual commands/parameters at a time instead of providing a full interactive list.

In Powershell v7, this behaviour has changed to be much more favourable.

You can enable the enhanced auto-complete by using the following command.

```powershell
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
```