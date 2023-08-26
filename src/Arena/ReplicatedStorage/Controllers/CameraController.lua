local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local CameraController = Knit.CreateController {
    Name = "CameraController",
    State = "FollowPlayer",
    Distance = 40
}

function CameraController:KnitInit()
    print("CameraController initialized")
    repeat task.wait() until game.Players.LocalPlayer.Character

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local camera = game.Workspace.CurrentCamera

    -- Set the camera's CFrame for a top-down view
    local cameraOffset = Vector3.new(0, self.Distance, 0)
    local cameraLookAtOffset = Vector3.new(0, 0, 0)
    camera.CFrame = CFrame.new(character.HumanoidRootPart.Position +
                                   cameraOffset, character.HumanoidRootPart
                                   .Position + cameraLookAtOffset)

    -- Function to update the camera position and rotation
    local function updateCamera()
        print("updateCamera", self.State)
        if character and character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = character.HumanoidRootPart.Position +
                                       cameraOffset
            local lookAtPosition = character.HumanoidRootPart.Position +
                                       cameraLookAtOffset
            camera.CFrame = CFrame.new(targetPosition, lookAtPosition)
        end
    end

    -- Connect the function to be called every frame
    game:GetService("RunService").RenderStepped:Connect(updateCamera)
end

function CameraController:KnitStart() print("CameraController started") end

return CameraController

