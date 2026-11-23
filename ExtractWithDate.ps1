# ExtractWithDate.ps1
# 使用 Bandizip 解压，目标文件夹名 = 压缩包名_日期，例如 report_2026-11-23
# 用法: powershell -File ExtractWithDate.ps1 "D:\a\report.zip" ["D:\b\more.rar" ...]

param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Archives)

# ===== 可调设置 =====
$DateFormat  = 'yyyy-MM-dd'   # 日期格式，可改成 'yyyyMMdd' 等
$Flatten     = $true          # 压缩包里只有一个顶层文件夹时，去掉多余的一层
$BandizipExe = 'C:\Program Files\Bandizip\Bandizip.exe'  # 图形界面（需要密码时用）
$BzExe       = 'C:\Program Files\Bandizip\bz.exe'        # 命令行版，静默解压
# ====================

Add-Type -AssemblyName System.Windows.Forms
function Show-Error($msg) {
    [System.Windows.Forms.MessageBox]::Show($msg, '解压失败', 'OK', 'Error') | Out-Null
}

if (-not (Test-Path $BandizipExe)) { Show-Error "找不到 Bandizip：$BandizipExe"; exit 1 }
if (-not $Archives) { Show-Error '没有传入压缩包。把压缩包拖到 ExtractWithDate.bat 上，或右键使用。'; exit 1 }

function Get-BaseName([string]$file) {
    $name = [IO.Path]::GetFileName($file)
    # 分卷: x.part1.rar / x.7z.001 / x.zip.001
    $name = $name -replace '(?i)\.part0*1\.rar$', ''
    $name = $name -replace '(?i)\.(7z|zip|rar)\.0*1$', ''
    # 双扩展名: x.tar.gz / x.tar.bz2 / x.tar.xz / x.tar.zst
    $name = $name -replace '(?i)\.tar\.(gz|bz2|xz|zst|lz|lzma)$', ''
    # 普通扩展名
    if ($name -match '\.[^.]{1,5}$' -and $name -notmatch '^\.') { $name = [IO.Path]::GetFileNameWithoutExtension($name) }
    return $name
}

$date = Get-Date -Format $DateFormat

foreach ($archive in $Archives) {
    if (-not (Test-Path -LiteralPath $archive -PathType Leaf)) { Show-Error "文件不存在：$archive"; continue }
    $archive = (Resolve-Path -LiteralPath $archive).Path
    $parent  = Split-Path -Parent $archive
    $base    = "$(Get-BaseName $archive)_$date"

    # 重名时自动加序号: name_date, name_date (2), name_date (3)...
    $target = Join-Path $parent $base
    $i = 2
    while (Test-Path -LiteralPath $target) { $target = Join-Path $parent "$base ($i)"; $i++ }

    # 先用 bz.exe 静默解压；失败（如需要密码）再用 Bandizip 窗口，可输入密码
    $proc = Start-Process -FilePath $BzExe -ArgumentList @('x', '-y', '-aoa', "-o:`"$target`"", "`"$archive`"") -Wait -PassThru -WindowStyle Hidden
    if ($proc.ExitCode -ne 0) {
        if (Test-Path -LiteralPath $target) { Remove-Item -LiteralPath $target -Recurse -Force }
        $proc = Start-Process -FilePath $BandizipExe -ArgumentList @('x', "-o:`"$target`"", "`"$archive`"") -Wait -PassThru
    }
    if ($proc.ExitCode -ne 0 -or -not (Test-Path -LiteralPath $target)) {
        Show-Error "Bandizip 解压出错（退出码 $($proc.ExitCode)）：`n$archive"
        continue
    }

    # 只有一个顶层文件夹时，把里面的内容提上来
    if ($Flatten) {
        $items = @(Get-ChildItem -LiteralPath $target -Force)
        if ($items.Count -eq 1 -and $items[0].PSIsContainer) {
            # 先改成临时名，避免内层有同名子项时冲突
            $inner = Join-Path $target ('__tmp_' + [guid]::NewGuid().ToString('N'))
            Rename-Item -LiteralPath $items[0].FullName -NewName (Split-Path -Leaf $inner)
            Get-ChildItem -LiteralPath $inner -Force | ForEach-Object {
                Move-Item -LiteralPath $_.FullName -Destination $target
            }
            Remove-Item -LiteralPath $inner -Force -Recurse
        }
    }
}
