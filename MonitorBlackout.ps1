Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ================= USER SETTINGS =================
$IdleMinutes = 0.1               
$TargetMonitorIndex = 0        
$CheckIntervalMs = 150        # Slightly faster for better hotkey feel
$HotkeyDebounceMs = 800
$WakeCooldownMs = 3000        # 3 seconds before it can blackout again
$LogPath = "$env:USERPROFILE\Documents\MonitorBlackout.log"
# =================================================

$ErrorActionPreference = 'SilentlyContinue'

function Write-Log {
    param($Message)
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$TimeStamp] $Message" | Out-File -FilePath $LogPath -Append
}

# ---------------- State flags ----------------
$Script:Enabled = $true
$Script:Active = $false
$Script:LastHotkeyTime = 0
$Script:LastWakeTime = 0

# ---------------- Monitor Setup ----------------
$monitors = [System.Windows.Forms.Screen]::AllScreens
if ($TargetMonitorIndex -ge $monitors.Count) { exit }
$bounds = $monitors[$TargetMonitorIndex].Bounds

# ---------------- WIN32 API --------------
# Using a more robust definition for LASTINPUTINFO
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Win32 {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);

    [StructLayout(LayoutKind.Sequential)]
    public struct LASTINPUTINFO {
        public uint cbSize;
        public uint dwTime;
    }

    [DllImport("user32.dll")]
    public static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

    public static uint GetIdleTime() {
        LASTINPUTINFO lii = new LASTINPUTINFO();
        lii.cbSize = (uint)Marshal.SizeOf(lii);
        if (GetLastInputInfo(ref lii)) {
            return (uint)Environment.TickCount - lii.dwTime;
        }
        return 0;
    }
}
"@ | Out-Null

$idleThreshold = $IdleMinutes * 60000

# ---------------- Black Window (WPF) ----------------
$window = New-Object Windows.Window
$window.WindowStyle = 'None'
$window.ResizeMode = 'NoResize'
$window.Topmost = $true
$window.ShowInTaskbar = $false
$window.Background = 'Black'
$window.Left   = $bounds.Left
$window.Top    = $bounds.Top
$window.Width  = $bounds.Width
$window.Height = $bounds.Height

# WAKE LOGIC: Right-Click
$window.add_MouseDown({
    if ($_.RightButton -eq 'Pressed') {
        $Script:Active = $false
        $window.Hide()
        $Script:LastWakeTime = [Environment]::TickCount
        Write-Log "Wake: Right-click detected."
    }
})

# ---------------- Tray Icon ----------------
$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Icon = [System.Drawing.SystemIcons]::Shield
$notify.Text = "Monitor Blackout: Enabled"
$notify.Visible = $true

$menu = New-Object System.Windows.Forms.ContextMenu
$exitItem = New-Object System.Windows.Forms.MenuItem "Exit"
$exitItem.add_Click({
    $notify.Visible = $false
    $notify.Dispose()
    $window.Close()
    [Environment]::Exit(0)
})
$menu.MenuItems.Add($exitItem)
$notify.ContextMenu = $menu

# ---------------- Main Loop ----------------
Write-Log "Monitoring started..."

while ($true) {
    [System.Windows.Forms.Application]::DoEvents()
    Start-Sleep -Milliseconds $CheckIntervalMs

    $now = [Environment]::TickCount

    # 1. ALWAYS CHECK HOTKEY (Regardless of toggle state)
    $ctrl = [Win32]::GetAsyncKeyState(0x11) -band 0x8000
    $alt  = [Win32]::GetAsyncKeyState(0x12) -band 0x8000
    $bKey = [Win32]::GetAsyncKeyState(0x42) -band 0x8000

    if ($ctrl -and $alt -and $bKey) {
        if ($now - $Script:LastHotkeyTime -gt $HotkeyDebounceMs) {
            $Script:Enabled = -not $Script:Enabled
            $notify.Text = "Monitor Blackout: $(if($Script:Enabled){'Enabled'}else{'Disabled'})"
            
            if (-not $Script:Enabled -and $Script:Active) {
                $window.Hide()
                $Script:Active = $false
                $Script:LastWakeTime = $now
            }
            
            $Script:LastHotkeyTime = $now
            Write-Log "Hotkey: Toggle to $Script:Enabled"
        }
    }

    # 2. SKIP BLACKOUT LOGIC IF DISABLED
    if (-not $Script:Enabled) { continue }

    # 3. IDLE DETECTION & TRIGGER
    $idleTime = [Win32]::GetIdleTime()

    if (-not $Script:Active) {
        # Only trigger if idle long enough AND outside the cooldown window
        if ($idleTime -ge $idleThreshold -and ($now - $Script:LastWakeTime -gt $WakeCooldownMs)) {
            $window.Show()
            $Script:Active = $true
            Write-Log "Blackout Triggered."
        }
    }
}
