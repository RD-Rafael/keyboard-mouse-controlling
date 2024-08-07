#InstallKeybdHook
#Requires AutoHotkey v1
CoordMode, Mouse, Screen

;Constants
;Change them to alter script behavior
global maxVelocity := 30
;Distance traveled when using blink teleport
global stepDistance := 120
;//////

;These change as the script is running
global bActivated :=False
global userControl := True
global leftClicking := False
global rightClicking := False
global draggingLeft := False
global xMovement := 0
global yMovement := 0
global velocity := 0
;//////

;Used for updating the cursors velocity
calcVelocity(){
    If(velocity == 0){
        Return maxVelocity/10
    }
    If(velocity < maxVelocity){
        ;It scales linearly
        Return velocity + maxVelocity/10
    } Else {
        Return maxVelocity
    }
}

;The routine that runs constantly when mouse movement is activated
moveMouse:
    CoordMode, Mouse, Screen

    ;Works only when user is in control of the cursor movement
    If(userControl==True){
        ;Updating velocity
        velocity := calcVelocity()
        xMovement := -1*GetKeyState("a", "P") + GetKeyState("d", "P")
        yMovement := -1*GetKeyState("w", "P") + GetKeyState("s", "P")
        
        ;Move the cursor
        If (xMovement != 0 && yMovement != 0){
            ;If user wants to move diagonally, movement is halved in both axis for constant velocity
            MouseMove xMovement*velocity/2, yMovement*velocity/2, 0, R  
        } Else If(xMovement == 0 && yMovement == 0){
            velocity := 0
        } Else {
            MouseMove xMovement*velocity, yMovement*velocity, 0, R
        }
    }
    Return



;Hotkeys that are active when mouse movement is activated
#If (bActivated)
    ;This is to prevent you from accidentally typing
    w:: Return
    a:: Return
    s:: Return
    d:: Return

    ;Hotkey for deactivating mouse movement
    \::
        bActivated := False
        SetTimer, moveMouse, Off
        MouseMove A_ScreenWidth/2, A_ScreenHeight/2
        Return    
    
    ;Left click hotkey
    j::
        ;Dragging left click behavior
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
        ;Regular single left click behavior
        If(leftClicking==False){
            leftClicking := True
            Click Down
            Click Up
            While (GetKeyState("j", "P")){
            }
            leftClicking := False
        }
        Return
    
    ;Hotkey to toggle between regular left click and drag left click
    +j::
        draggingLeft := !draggingLeft
        Return
    
    ;Hotkey to teleport the cursor a fixed distance, blink style
    ,::
        CoordMode, Mouse, Screen
        
        ;Deactivates user control while it executes
        userControl := False

        ;Gets cursor position
        MouseGetPos currentX, currentY
        
        ;While pressing the teleport key, it waits for wasd input
        While(GetKeyState(",", "P")){
            xMovement := -1*GetKeyState("a", "P") + GetKeyState("d", "P")
            yMovement := -1*GetKeyState("w", "P") + GetKeyState("s", "P")
            ;If the ',' key is pressed and a combination of wasd takes place
            If(xMovement != 0 || yMovement != 0){
                ;Delay to account for imperfect timing
                Sleep, 50
                ;read wasd again
                xMovement := -1*GetKeyState("a", "P") + GetKeyState("d", "P")
                yMovement := -1*GetKeyState("w", "P") + GetKeyState("s", "P")
                break
            }
        }
        
        ;If there is movement in either axis
        if (xMovement!=0 || yMovement!=0) {
            distanceX := 0
            distanceY := 0
            
            ;Calculate x and y direction
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
            
            ;Check for diagonal movement and move cursor
            If(distanceX != 0 && distanceY != 0){
                MouseMove distanceX/2, distanceY/2, 0, R
            } Else {
                MouseMove distanceX, distanceY, 0, R
            }

        }
        Sleep, 50
        ;Gets the user to move the cursor again
        userControl := True
        Return
    
    ;Right click hotkey
    k::
        ;If not already right clicking
        If(rightClicking==False){
            rightClicking := True
            Click Down Right
            Click Up Right
            
            ;Waits for user to stop pressing the right click key
            While (GetKeyState("j", "P")){
            }
            rightClicking := False
        }
        Return

    ;Center movement Hotkey
    m::
        CoordMode, Mouse, Screen

        ;Removes user control while executing (should probably change this variable name)
        userControl := False

        MouseGetPos currentX, currentY

        ;While the key is being pressed
        While(GetKeyState("m", "P")){
            xMovement := -1*GetKeyState("a", "P") + GetKeyState("d", "P")
            yMovement := -1*GetKeyState("w", "P") + GetKeyState("s", "P")
            ;If the key is pressed and a combination of wasd takes place
            If(xMovement != 0 || yMovement != 0){
                ;Delay to account for imperfect timing
                Sleep, 50
                ;Read wasd keys again
                xMovement := -1*GetKeyState("a", "P") + GetKeyState("d", "P")
                yMovement := -1*GetKeyState("w", "P") + GetKeyState("s", "P")
                break
            }
        }

        ;If there is movement in either axis
        if (xMovement!=0 || yMovement!=0) {

            ;Calculate cursor's distance from each edge of the screen
            leftSize := currentX
            rightSize := A_ScreenWidth - currentX
            topSize := currentY
            bottomSize := A_ScreenHeight - currentY
            
            distanceX := 0
            distanceY := 0
            
            ;Calculate x and y distances and directions
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


            If(distanceX == 0 && distanceY == 0){
                ;The mouse will move to the center of the screen
                MouseMove A_ScreenWidth/2, A_ScreenHeight/2
            } Else {
                ;The mouse will move to the center in relation to its position and the direction that wasd goes
                MouseMove distanceX, distanceY, 0, R
            }

        } else {
            ;If key released with no wasd press, then the mouse will move to the center of the screen
            MouseMove A_ScreenWidth/2, A_ScreenHeight/2
        }
        Sleep, 50
        ;Restores user cursor control
        userControl := True
        Return

;Hotkeys for when cursor movement is deacivated
#If (!bActivated)
    ;Hotkey to activate cursor movement
    Insert::
        bActivated := True
        SetTimer, moveMouse, 20
        MouseMove A_ScreenWidth/2, A_ScreenHeight/2
        Return