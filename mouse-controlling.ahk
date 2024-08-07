#InstallKeybdHook
#Requires AutoHotkey v1
CoordMode, Mouse, Screen

global bActivated :=False
global xMovement := 0
global yMovement := 0
global velocity := 0
global maxVelocity := 30
global userControl := True
global leftClicking := False
global rightClicking := False
global draggingLeft := False
global stepDistance := 120

MouseGetPos mX, mY
MsgBox % "ScreenHeight: " . A_ScreenHeight "`nScreenWidth: " . A_ScreenWidth "`nMouseX: " . mX "`nMouseY: " . mY


calcVelocity(){
    If(velocity == 0){
        Return maxVelocity/10
    }
    If(velocity < maxVelocity){
        Return velocity + maxVelocity/10
    } Else {
        Return maxVelocity
    }
}

moveMouse:
    CoordMode, Mouse, Screen
    If(userControl==True){
        velocity := calcVelocity()
        xMovement := -1*GetKeyState("a", "P") + GetKeyState("d", "P")
        yMovement := -1*GetKeyState("w", "P") + GetKeyState("s", "P")
        
        If (xMovement != 0 && yMovement != 0){
        MouseMove xMovement*velocity/2, yMovement*velocity/2, 0, R  
        } Else If(xMovement == 0 && yMovement == 0){
            velocity := 0
        } Else {
            MouseMove xMovement*velocity, yMovement*velocity, 0, R
        }
    }
    Return




#If (bActivated)
    w:: Return
    a:: Return
    s:: Return
    d:: Return
    j::
        If(draggingLeft==True){
            If(leftClicking==False){
                leftClicking := True
                Click Down    
            } Else {
                leftClicking := False
                Click Up
            }
            Return
        }
        If(leftClicking==False){
            leftClicking := True
            Click Down
            Click Up
            While (GetKeyState("j", "P")){
            }
            leftClicking := False
        }
        Return
    +j::
        draggingLeft := !draggingLeft
        Return
    ,::
        CoordMode, Mouse, Screen
        userControl := False
        MouseGetPos currentX, currentY
        While(GetKeyState(",", "P")){
            xMovement := -1*GetKeyState("a", "P") + GetKeyState("d", "P")
            yMovement := -1*GetKeyState("w", "P") + GetKeyState("s", "P")
            ;if the m key is pressed and a combination of wasd takes place
            If(xMovement != 0 || yMovement != 0){
                Sleep, 50
                xMovement := -1*GetKeyState("a", "P") + GetKeyState("d", "P")
                yMovement := -1*GetKeyState("w", "P") + GetKeyState("s", "P")
                break
            }
        }
        if (xMovement!=0 || yMovement!=0) {
            distanceX := 0
            distanceY := 0
            
            If(xMovement == 1){
                distanceX := stepDistance
            } Else If(xMovement == -1){
                distanceX := -1*stepDistance
            }
            If(yMovement == 1){
                distanceY := stepDistance
            } Else If(yMovement == -1){
                distanceY := -1*stepDistance
            }
            ;the mouse will move to the center in relation to its position and the direction that wasd goes
            If(distanceX != 0 && distanceY != 0){
                MouseMove distanceX/2, distanceY/2, 0, R
            } Else {
                MouseMove distanceX, distanceY, 0, R
            }

        }
        Sleep, 50
        userControl := True
        Return
    k::
        If(rightClicking==False){
            rightClicking := True
            Click Down Right
            Click Up Right
            While (GetKeyState("j", "P")){
            }
            rightClicking := False
        }
        Return
    \::
        bActivated := False
        SetTimer, moveMouse, Off
        MouseMove A_ScreenWidth/2, A_ScreenHeight/2
        Return    
    m::
        CoordMode, Mouse, Screen
        userControl := False
        MouseGetPos currentX, currentY
        While(GetKeyState("m", "P")){
            xMovement := -1*GetKeyState("a", "P") + GetKeyState("d", "P")
            yMovement := -1*GetKeyState("w", "P") + GetKeyState("s", "P")
            ;if the m key is pressed and a combination of wasd takes place
            If(xMovement != 0 || yMovement != 0){
                Sleep, 50
                xMovement := -1*GetKeyState("a", "P") + GetKeyState("d", "P")
                yMovement := -1*GetKeyState("w", "P") + GetKeyState("s", "P")
                break
            }
        }
        if (xMovement!=0 || yMovement!=0) {
            leftSize := currentX
            rightSize := A_ScreenWidth - currentX
            topSize := currentY
            bottomSize := A_ScreenHeight - currentY
            
            distanceX := 0
            distanceY := 0
            
            If(xMovement == 1){
                distanceX := rightSize/2
            } Else If(xMovement == -1){
                distanceX := -1*leftSize/2
            }
            If(yMovement == 1){
                distanceY := bottomSize/2
            } Else If(yMovement == -1){
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
        userControl := True
        Return
#If (!bActivated)
    Insert::
        bActivated := True
        SetTimer, moveMouse, 20
        MouseMove A_ScreenWidth/2, A_ScreenHeight/2
        Return