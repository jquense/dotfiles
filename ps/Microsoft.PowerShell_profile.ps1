
function prompt {
    $origLastExitCode = $LASTEXITCODE
    $prefix = $env:UserName + ' '

    $curPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path
    if ($curPath.ToLower().StartsWith($Home.ToLower()))
    {
        $curPath = "~" + $curPath.SubString($Home.Length)
    }

    Write-Host $prefix -ForegroundColor Green -NoNewline

    Write-Host $curPath -ForegroundColor Blue -NoNewline
    Write-VcsStatus
    $LASTEXITCODE = $origLastExitCode
    "`n$('$' * ($nestedPromptLevel + 1)) "
}


Import-Module posh-git

$global:GitPromptSettings.DefaultPromptPrefix = '$env:UserName '
$global:GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
$global:GitPromptSettings.BeforeText = ' ('
$global:GitPromptSettings.AfterText  = ')'
$global:GitPromptSettings.BranchBehindAndAheadDisplay = 'compact'
$global:GitPromptSettings.BranchIdenticalStatusToSymbol = $null

Set-PSReadlineKeyHandler -Key Tab -Function Complete

#
# Ctrl+Shift+j then type a key to mark the current directory.
# Ctrj+j then the same key will change back to that directory without
# needing to type cd and won't change the command line.

#
$global:PSReadlineMarks = @{}

Set-PSReadlineKeyHandler -Key Ctrl+Shift+j `
                         -BriefDescription MarkDirectory `
                         -LongDescription "Mark the current directory" `
                         -ScriptBlock {
    param($key, $arg)

    $key = [Console]::ReadKey($true)
    $global:PSReadlineMarks[$key.KeyChar] = $pwd
}

Set-PSReadlineKeyHandler -Key Ctrl+j `
                         -BriefDescription JumpDirectory `
                         -LongDescription "Goto the marked directory" `
                         -ScriptBlock {
    param($key, $arg)

    $key = [Console]::ReadKey()
    $dir = $global:PSReadlineMarks[$key.KeyChar]
    if ($dir)
    {
        Set-Location $dir
        [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
    }
}


Function Get-Formatted-Command { Get-Command $args | Format-Table Path, Name }
    New-Alias which Get-Formatted-Command    

Function Get-IP4 {Ipconfig | Select-String IPv4}
    New-Alias IP Get-IP4

New-Alias g git
New-Alias n npm
