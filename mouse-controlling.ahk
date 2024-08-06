#InstallKeybdHook
#Requires AutoHotkey v1
CoordMode, Mouse, Screen

global Activated :=False
global XMovement := 0
global YMovement := 0
global Velocity := 0
global MaxVelocity := 30
global UserControl := True
global LeftClicking := False
global RightClicking := False
global draggingLeft := False


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
    CoordMode, Mouse, Screen
    If(UserControl==True){
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
    }
    Return




#If (Activated)
    w:: Return
    a:: Return
    s:: Return
    d:: Return
    j::
        If(LeftClicking==False){
            LeftClicking := True
            Click Down
            Click Up
            While (GetKeyState("j", "P")){
            }
            LeftClicking := False
        }
        Return
    +j::
        if(draggingLeft==False){
            draggingLeft := True
            LeftClicking := True
            Click Down
        } Else {
            Click Up
            draggingLeft := False
            LeftClicking := False
        }        
        Return
    k::
        If(RightClicking==False){
            RightClicking := True
            Click Down Right
            Click Up Right
            While (GetKeyState("j", "P")){
            }
            RightClicking := False
        }
        Return
    \::
        Activated := False
        SetTimer, MoveMouse, Off
        MouseMove A_ScreenWidth/2, A_ScreenHeight/2
        Return    
    m::
        CoordMode, Mouse, Screen
        UserControl := False
        MouseGetPos currentX, currentY
        While(GetKeyState("m", "P")){
            XMovement := -1*GetKeyState("a", "P") + GetKeyState("d", "P")
            YMovement := -1*GetKeyState("w", "P") + GetKeyState("s", "P")
            ;if the m key is pressed and a combination of wasd takes place
            If(XMovement != 0 || YMovement != 0){
                Sleep, 50
                XMovement := -1*GetKeyState("a", "P") + GetKeyState("d", "P")
                YMovement := -1*GetKeyState("w", "P") + GetKeyState("s", "P")
                break
            }
        }
        if (XMovement!=0 || YMovement!=0) {
            leftSize := currentX
            rightSize := A_ScreenWidth - currentX
            topSize := currentY
            bottomSize := A_ScreenHeight - currentY
            
            distanceX := 0
            distanceY := 0
            
            If(XMovement == 1){
                distanceX := rightSize/2
            } Else If(XMovement == -1){
                distanceX := -1*leftSize/2
            }
            If(YMovement == 1){
                distanceY := bottomSize/2
            } Else If(YMovement == -1){
                distanceY := -1*topSize/2
            }
            ;the mouse will move to the center in relation to its position and the direction that wasd goes
            If(distanceX == 0 && distanceY == 0){
                MouseMove A_ScreenWidth/2, A_ScreenHeight/2
            } Else {
                MouseMove distanceX, distanceY, 0, R
            }

        } else {
            ;if m is released with no wasd press, then the mouse will move to the center of the screen
            MouseMove A_ScreenWidth/2, A_ScreenHeight/2
        }
        Sleep, 50
        UserControl := True
        Return
#If (!Activated)
    Insert::
        Activated := True
        SetTimer, MoveMouse, 20
        MouseMove A_ScreenWidth/2, A_ScreenHeight/2
        Return