# MonitorBlackout
This is a Powershell script that blacks out a (second) monitor. The script can be disabled/re-enabled with a hotkey (ctrl + alt + b) and it has a sytem tray icon that shows whether it is enabled or disabled.
When the script is running and enabled, the chosen monitor goes black (is covered by a black window) after 6 seconds. You can "unblacken" the screen by right clicking anywhere on it.

The script is useful if you (for example) would like to use only one monitor and keep your workspace as free from distractions as possible.

Created with the help of Google Gemini and ChatGPT.

# How to
It is possible that you have to edit the script for minor setting changes and tweaks, including setting the correct monitor to blackout and the log location.

There are currently several (3) options whereby you can use this script. Method(s) 1+2 is/are recommended, the other methods may require further tinkering by yourself.

(1) Run the script directly (save as MonitorBlackout.ps1 and launch in powershell)

(2) Tested and working: powershell script (with VBScript Wrapper).
(2A) VBScript Wrapper:

Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "powershell.exe -ExecutionPolicy Bypass -File ""C:\LOCATION OF SCRIPT.PS1""", 0, False

-> save as LaunchBlackout.vbs file

(3) Run the script from Task scheduler (with or without the VBScript Wrapper).

# Current issues (v1.0)
- The screen does not always black out after 6 seconds; it seems to take a multiple of 6 seconds (can be 12, 18 or longer).
- The script does not always respond to the hotkey.
- The black window is a powershell and application-level window; it would be better if it was not visible this way.
- The system tray icon is not consistent. Sometimes it is a multicoloured shield, at other times it is a blue icon with an "i".
