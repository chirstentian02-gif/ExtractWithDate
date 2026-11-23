' Launch ExtractWithDate.ps1 without a console window (used by the right-click menu)
' Keep this file ASCII-only (wscript reads it in the system ANSI code page)
Set sh = CreateObject("WScript.Shell")
dir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
args = ""
For Each a In WScript.Arguments
    args = args & " """ & a & """"
Next
sh.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -File """ & dir & "\ExtractWithDate.ps1""" & args, 0, False
