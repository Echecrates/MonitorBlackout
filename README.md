# MonitorBlackout
MonitorBlackout is a Powershell script that automatically dims a (second) monitor. Users can disable/re-enable the automatic dimming with a hotkey (Ctrl + Alt + B) and a system tray icon shows whether automatic dimming is enabled or disabled.
When enabled, the chosen monitor is covered by a black window after 6 seconds, giving the impression that the screen is dimmed or turned off. Users can undim the screen by right-clicking anywhere on it.

The script is useful if you would like to dim a specific monitor while keeping other monitor(s) on, thereby keeping your workspace free from distraction. It is more convenient than turning off the dimmed monitor, which requires a button press and potentially reorders windows.

The script was created with help from Google Gemini and OpenAI ChatGPT. Users are advised to make changes to the script with the help of Gemini, since it provided most of the code.

# How to
Users may have to edit the script for minor settings changes and tweaks, including setting the correct monitor to blackout and the location where logging should be done.

There are **(3) tested ways of launching the script.** 

**(1)** Run the script directly 

Save as MonitorBlackout.ps1 and launch in powershell.

**(2)** Advised: run with a VBScript Wrapper. This avoids several bugs.

VBScript Wrapper:

"Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "powershell.exe -ExecutionPolicy Bypass -File ""C:\LOCATION OF SCRIPT.PS1""", 0, False"

-> save as LaunchBlackout.vbs file and launch this file.

**(3)** Run the script from Task scheduler (with or without the VBScript Wrapper).

# Current issues (v1.0.0, 09/01/2026)
- The screen does not always black out after 6 seconds; it seems to take a multiple of 6 seconds (can be 12, 18 or longer) and sometimes requires disabling and re-enabling the automatic dimming with the hotkey.
- The script does not always respond to the hotkey.
- The black window is a powershell and application-level window, and consequently shows up when switching between windows using the Alt + Tab menu, and becomes undimmed when hovering over an active window on the screen in the taskbar. 
- The system tray icon is not consistent. Sometimes it is a multicoloured shield, at other times it is a blue icon with an "i".
- The hotkey may conflict with the Ctrl + Alt + B "Toggle Radeon Boost" Hotkey in AMD's Graphics Software
- "How to" should be updated and/or the launch options should be redone and better integrated into the software and repository.
