#InstallKeybdHook
#Requires AutoHotkey v1
CoordMode, Mouse, Screen

global Activated :=False
global XMovement := 0
global YMovement := 0
global Velocity := 0
global MaxVelocity := 30

MouseGetPos mX, mY
MsgBox % "ScreenHeight: " . A_ScreenHeight "`nScreenWidth: " . A_ScreenWidth "`nMouseX: " . mX "`nMouseY: " . mY


calcVelocity(){
    If(Velocity == 0){
        Return maxVelocity/10
    }
    If(Velocity < maxVelocity){
        Return Velocity + maxVelocity/10
    } Else {
        Return maxVelocity
    }
}

MoveMouse:
        Velocity := calcVelocity()
        XMovement := -1*GetKeyState("a", "P") + GetKeyState("d", "P")
        YMovement := -1*GetKeyState("w", "P") + GetKeyState("s", "P")
        
        If (XMovement != 0 && YMovement != 0){
        MouseMove XMovement*Velocity/2, YMovement*Velocity/2, 0, R  
        } Else If(XMovement == 0 && YMovement == 0){
            Velocity := 0
        } Else {
            MouseMove XMovement*Velocity, YMovement*Velocity, 0, R
        }
    Return




#If (Activated)
    w:: Return
    a:: Return
    s:: Return
    d:: Return
    Insert::
        Activated := False
        SetTimer, MoveMouse, Off
        MouseMove mX, mY
        Return

#If (!Activated)
    Insert::
        Activated := True
        SetTimer, MoveMouse, 20
        MouseMove mX, mY
        Return