# Adds "解压到 名字_日期" to the right-click menu (current user only, no admin needed)
$exts = '.zip','.rar','.7z','.tar','.gz','.tgz','.bz2','.xz','.zst','.iso','.cab','.lzh','.alz','.egg','.001'
$vbs  = Join-Path $PSScriptRoot 'run-hidden.vbs'
$label = "解压到 名字_日期 (Bandizip)"
foreach ($e in $exts) {
    $key = "HKCU:\Software\Classes\SystemFileAssociations\$e\shell\ExtractWithDate"
    New-Item -Path "$key\command" -Force | Out-Null
    Set-ItemProperty -Path $key -Name '(default)' -Value $label
    Set-ItemProperty -Path $key -Name 'Icon' -Value 'C:\Program Files\Bandizip\Bandizip.exe,0'
    Set-ItemProperty -Path "$key\command" -Name '(default)' -Value "wscript.exe `"$vbs`" `"%1`""
}
Write-Host "已安装右键菜单：$($exts -join ' ')"
