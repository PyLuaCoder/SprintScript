--Speed values
local sprintSpeed = 30
local defaultSpeed = 16
 
--Camera FOV values
local defaultFOV = 70
local fovMultiplier = 0.1
 
--Streaks particles settings
local windStreaksMinimumSpeed = 20
local windStreaksMinimumRate = 1500
 
--Sprinting buttons
local sprintInputs = {Enum.KeyCode.LeftControl, Enum.KeyCode.LeftShift}
 
--Sprint toggle enabled or not
local toggle = false
 
 
local cas = game:GetService("ContextActionService")
 
local camera = workspace.CurrentCamera
 
local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
 
local windStreaks = camera:FindFirstChild(character.Name .. "'s wind streaks") or game.ReplicatedStorage:FindFirstChild(character.Name .. "'s wind streaks") or game.ReplicatedStorage:WaitForChild("SprintReplicatedStorage"):WaitForChild("StreaksPart"):Clone()
windStreaks.Name = character.Name .. "'s wind streaks"
 
 
function lerp(a, b, t)
    return a + (b - a) * t
end
 
 
function sprintAction(actionName, inputState, inputObject)
    
    if actionName == "SPRINT" then
        
        if inputState == Enum.UserInputState.Begin then
            
            if toggle then
                humanoid.WalkSpeed = humanoid.WalkSpeed == defaultSpeed and sprintSpeed or defaultSpeed
                
            else
                humanoid.WalkSpeed = sprintSpeed
            end
            
        elseif inputState == Enum.UserInputState.End then
            if not toggle then
                humanoid.WalkSpeed = defaultSpeed
            end
        end
    end
end
 
cas:BindAction("SPRINT", sprintAction, true, unpack(sprintInputs))
 
 
 
function handleWindStreaks()
    
    local currentFOV = camera.FieldOfView
    
    if (humanoid.WalkSpeed > defaultSpeed and humanoid.MoveDirection.Magnitude > 0) then
        
        local goalFOV = (humanoid.WalkSpeed / defaultSpeed) * defaultFOV
        goalFOV = defaultFOV + ((goalFOV - defaultFOV) * fovMultiplier)
        
        camera.FieldOfView = lerp(currentFOV, goalFOV, 0.2)
        
    else
        camera.FieldOfView = lerp(currentFOV, defaultFOV, 0.2)
    end
    
    if (humanoid.WalkSpeed >= windStreaksMinimumSpeed and humanoid.MoveDirection.Magnitude > 0) then
        
        windStreaks.CFrame = camera.CFrame + camera.CFrame.LookVector * (13 / (camera.FieldOfView / defaultFOV))
        
        windStreaks.Attachment.ParticleEmitter.Rate = (humanoid.WalkSpeed / windStreaksMinimumSpeed) * windStreaksMinimumRate
        
        windStreaks.Parent = camera
        
    else
        windStreaks.Parent = game.ReplicatedStorage
    end
end
 
game:GetService("RunService").RenderStepped:Connect(handleWindStreaks)
