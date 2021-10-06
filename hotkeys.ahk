
; *********************** Header - some configuration  ***********************
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors. (disabled by default)
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
setTitleMatchMode, 2 ; set title match mode to "contains"

; *********************** Configured region - selected functions ************


;CTRL + Alt + n = notepad++
^!n::ActivateOrOpen("- Notepad++", "notepad++.exe")


;CTRL + Alt + c = chrome (internet)
^!c::ActivateOrOpen("- Google Chrome", "chrome.exe")

; Alt + Q = Qbittorrent
!q::ActivateOrOpen("- Qbittorrent", "C:\Program Files\qBittorrent\qbittorrent.exe")

;CTRL + Alt +  b = chrome (internet)
#b::ActivateOrOpen("- Brave", "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe")

url=www.google.com ; <-- place url here.
^!z::
run % "chrome.exe" ( winExist("ahk_class Chrome_WidgetWin_1") ? " -new " : " " ) url
return

;CTRL + Alt + w = Word
^!w::ActivateOrOpen("- Word", "WINWORD")


;CTRL + Alt + e = Excel
^!e::ActivateOrOpen("- Excel", "excel.exe")


;CTRL + Alt + v = Visual Studio Code
^!v::ActivateOrOpen("Visual Code", "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk")

^#x::toggleWindow("ahk_exe WindowsTerminal.exe", "wt")


#x::ActivateOrOpen("Windows Terminal", "wt")


^!f::ActivateOrOpen("Firfox", "firefox.exe")

^!k::ActivateOrOpen("Kerbal Space Program", "C:\Games\Kerbal Space Program\Launcher.exe")

;Close Active Windows
#q:: ; Windows and Q closes actice window
WinGetTitle, Title, A
PostMessage, 0x112, 0xF060,,, %Title%
return



; *********************** Provided Functions ********************************
OpenConfig()
{
    Run, "https://www.ahkgen.com/?indexes=0`%2C1`%2C2`%2C3`%2C4`%2C5`%2C6`%2C7&comment0=CTRL+`%2B+Alt+`%2B+c+`%3D+command+prompt&func0=KEY&skey0`%5B`%5D=CTRL&skey0`%5B`%5D=ALT&skeyValue0=c&Window0=ahk_exe+cmd.exe&Program0=cmd&option0=ActivateOrOpen&comment1=CTRL+`%2B+Alt+`%2B+n+`%3D+notepad`%2B`%2B&func1=KEY&skey1`%5B`%5D=CTRL&skey1`%5B`%5D=ALT&skeyValue1=n&Window1=-+Notepad`%2B`%2B&Program1=notepad`%2B`%2B.exe&option1=ActivateOrOpen&comment2=CTRL+`%2B+Alt+`%2B+i+`%3D+chrome+`%28internet`%29&func2=KEY&skey2`%5B`%5D=CTRL&skey2`%5B`%5D=ALT&skeyValue2=i&Window2=-+Google+Chrome&Program2=chrome.exe&option2=ActivateOrOpen&comment3=CTRL+`%2B+Alt+`%2B+w+`%3D+Word&func3=KEY&skey3`%5B`%5D=CTRL&skey3`%5B`%5D=ALT&skeyValue3=w&Window3=-+Word&Program3=WINWORD&option3=ActivateOrOpen&comment4=CTRL+`%2B+Alt+`%2B+e+`%3D+Excel&func4=KEY&skey4`%5B`%5D=CTRL&skey4`%5B`%5D=ALT&skeyValue4=e&Window4=-+Excel&Program4=excel.exe&option4=ActivateOrOpen&comment5=CTRL+`%2B+Alt+`%2B+v+`%3D+Visual+Studio&func5=KEY&skey5`%5B`%5D=CTRL&skey5`%5B`%5D=ALT&skeyValue5=v&Window5=Visual+Code&Program5=C`%3A`%5CProgramData`%5CMicrosoft`%5CWindows`%5CStart+Menu`%5CPrograms`%5CVisual+Studio+Code`%5CVisual+Studio+Code.lnk&option5=ActivateOrOpen&comment6=&func6=KEY&skey6`%5B`%5D=WIN&skeyValue6=x&Window6=Windows+Terminal&Program6=wt&option6=ActivateOrOpen&comment7=&func7=KEY&skey7`%5B`%5D=CTRL&skey7`%5B`%5D=ALT&skeyValue7=f&Window7=Firfox&Program7=firefox.exe&option7=ActivateOrOpen"
}

LockWorkStation()
{
    DllCall("LockWorkStation")
}

TurnMonitorsOff()
{
    ; from http://autohotkey.com/board/topic/105261-turn-monitor-off-even-when-using-the-computer/?p=642266
    SendMessage,0x112,0xF170,2,,Program Manager
}

ActivateOrOpen(window, program)
{
	; check if window exists
	if WinExist(window)
	{
		WinActivate  ; Uses the last found window.
	}
	else
	{   ; else start requested program
		 Run cmd /c "start ^"^" ^"%program%^"",, Hide ;use cmd in hidden mode to launch requested program
		 WinWait, %window%,,5		; wait up to 5 seconds for window to exist
		 IfWinNotActive, %window%, , WinActivate, %window%
		 {
			  WinActivate  ; Uses the last found window.
		 }
	}
	return
}

toggleWindow(winTitle, path) 
{
    WinGet, winState, MinMax, %winTitle%

    if !WinExist(winTitle)
    {
        Run *Runas %path%
    }

    if (winState === -1)
    { ; if window is minimized, activate it
        WinActivate, %winTitle%
        return
    } 
    else if (winState === 1)
    { ; if window is maximized, minimize it
        WinMinimize, %winTitle%
        return
    }

    if !WinActive(winTitle) 
    {
        WinActivate, %winTitle%
        return
    } 
    else
    {
        WinMinimize, %winTitle%
        return
    }
}

ActivateOrOpenChrome(tab, url)
{
    Transform, url, Deref, "%url%" ;expand variables inside url
    Transform, tab, Deref, "%tab%" ;expand variables inside tab
    chrome := "- Google Chrome"
    found := "false"
    tabSearch := tab
    curWinNum := 0

    SetTitleMatchMode, 2
    if WinExist(Chrome)
	{
		WinGet, numOfChrome, Count, %chrome% ; Get the number of chrome windows
		WinActivateBottom, %chrome% ; Activate the least recent window
		WinWaitActive %chrome% ; Wait until the window is active

		ControlFocus, Chrome_RenderWidgetHostHWND1 ; Set the focus to tab control ???

		; Loop until all windows are tried, or until we find it
		while (curWinNum < numOfChrome and found = "false") {
			WinGetTitle, firstTabTitle, A ; The initial tab title
			title := firstTabTitle
			Loop
			{
				if(InStr(title, tabSearch)>0){
					found := "true"
					break
				}
				Send {Ctrl down}{Tab}{Ctrl up}
				Sleep, 50
				WinGetTitle, title, A  ;get active window title
				if(title = firstTabTitle){
					break
				}
			}
			WinActivateBottom, %chrome%
			curWinNum := curWinNum + 1
		}
	}

    ; If we did not find it, start it
    if(found = "false"){
        Run chrome.exe "%url%"
    }
	return
}

; from https://stackoverflow.com/a/28448693
SendUnicodeChar(charCode)
{
    ; if in unicode mode, use Send, {u+####}, else, use the encode method.
    if A_IsUnicode = 1
    {
        Send, {u+%charCode%}
    }
    else
    {
        VarSetCapacity(ki, 28 * 2, 0)
        EncodeInteger(&ki + 0, 1)
        EncodeInteger(&ki + 6, charCode)
        EncodeInteger(&ki + 8, 4)
        EncodeInteger(&ki +28, 1)
        EncodeInteger(&ki +34, charCode)
        EncodeInteger(&ki +36, 4|2)

        DllCall("SendInput", "UInt", 2, "UInt", &ki, "Int", 28)
    }
}

EncodeInteger(ref, val)
{
	DllCall("ntdll\RtlFillMemoryUlong", "Uint", ref, "Uint", 4, "Uint", val)
}