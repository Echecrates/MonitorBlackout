# MonitorBlackout
This is a Powershell script that blacks out a (second) monitor. Users can disable/re-enable the script with a hotkey (Ctrl + Alt + B); a system tray icon shows whether it is enabled or disabled.
When enabled, after 6 seconds the chosen monitor is covered by a black window, giving the impression that the screen is dimmed or turned off. Users can undim the screen by right-clicking anywhere on it.

The script is useful if you would like to (for example) use only one monitor and keep your workspace as free from distractions as possible.

The script was created with help from Google Gemini and OpenAI ChatGPT.

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

# Current issues (v1.0, 09/01/2026)
- The screen does not always black out after 6 seconds; it seems to take a multiple of 6 seconds (can be 12, 18 or longer).
- The script does not always respond to the hotkey.
- The black window is a powershell and application-level window; it would be better if it was not visible this way.
- The system tray icon is not consistent. Sometimes it is a multicoloured shield, at other times it is a blue icon with an "i".
- The hotkey may conflict with the Ctrol + Alt + B "Toggle Radeon Boost" Hotkey in AMD's Graphics Software
