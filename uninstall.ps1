# 移除右键菜单 / Removes the right-click menu entry
$exts = '.zip','.rar','.7z','.tar','.gz','.tgz','.bz2','.xz','.zst','.iso','.cab','.lzh','.alz','.egg','.001'
foreach ($e in $exts) {
    Remove-Item -Path "HKCU:\Software\Classes\SystemFileAssociations\$e\shell\ExtractWithDate" -Recurse -ErrorAction SilentlyContinue
}
Write-Host '已移除右键菜单 / Context menu removed'
