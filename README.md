# ExtractWithDate

[中文](#中文) | [English](#english)

```
report.zip  →  report_2026-11-23\
```

---

## 中文

借助 [Bandizip](https://www.bandisoft.com/bandizip/) 解压压缩包，并自动在解压文件夹名末尾加上日期。

### 功能

- 右键菜单「解压到 名字_日期」，或把压缩包拖到 `ExtractWithDate.bat` 上（可多选）
- 同名文件夹已存在时自动加序号：`name_date (2)`
- 正确处理分卷和双扩展名：`x.part1.rar`、`x.7z.001`、`x.tar.gz` → `x_日期`
- 压缩包里只有一个顶层文件夹时自动去掉多余一层
- 默认用 `bz.exe` 静默解压；失败（如需要密码）时改用 Bandizip 窗口

### 安装

1. 安装 Bandizip（默认路径 `C:\Program Files\Bandizip`）
2. 下载本仓库到任意位置，运行：

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

只写入当前用户注册表（HKCU），无需管理员权限。Win11 中菜单位于「显示更多选项」。移动文件夹后需重新运行 `install.ps1`。

卸载：

```powershell
powershell -ExecutionPolicy Bypass -File uninstall.ps1
```

### 设置

在 `ExtractWithDate.ps1` 开头修改：

| 变量 | 默认值 | 说明 |
|---|---|---|
| `$DateFormat` | `yyyy-MM-dd` | 日期格式，如 `yyyyMMdd` |
| `$Flatten` | `$true` | 是否去掉多余的一层文件夹 |
| `$BandizipExe` / `$BzExe` | `C:\Program Files\Bandizip\...` | Bandizip 路径 |

---

## English

Extract archives with [Bandizip](https://www.bandisoft.com/bandizip/) and automatically append the date to the output folder name.

### Features

- Right-click menu "Extract to name_date", or drag archives onto `ExtractWithDate.bat` (multiple files supported)
- If the folder already exists, a number is added: `name_date (2)`
- Handles multi-volume and double extensions: `x.part1.rar`, `x.7z.001`, `x.tar.gz` → `x_date`
- If the archive contains a single top-level folder, the redundant level is removed
- Extracts silently with `bz.exe`; if that fails (e.g. a password is required), falls back to the Bandizip window

### Install

1. Install Bandizip (default path `C:\Program Files\Bandizip`)
2. Download this repository anywhere and run:

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

Only writes to the current user's registry (HKCU); no admin rights needed. On Windows 11 the entry is under "Show more options". Re-run `install.ps1` if you move the folder.

Uninstall:

```powershell
powershell -ExecutionPolicy Bypass -File uninstall.ps1
```

### Settings

Edit the top of `ExtractWithDate.ps1`:

| Variable | Default | Description |
|---|---|---|
| `$DateFormat` | `yyyy-MM-dd` | Date format, e.g. `yyyyMMdd` |
| `$Flatten` | `$true` | Remove the redundant folder level |
| `$BandizipExe` / `$BzExe` | `C:\Program Files\Bandizip\...` | Bandizip paths |
