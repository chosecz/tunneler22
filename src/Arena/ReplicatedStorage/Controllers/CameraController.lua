local Packages = game:GetService("ReplicatedStorage").Packages
local Knit = require(Packages.Knit)
local EnumList = require(Packages.EnumList)

local cameraState = EnumList.new("CameraState", {
	"FollowPlayer",
	"SpectatePlayer",
})

local CameraController = Knit.CreateController {
    Name = "CameraController",
    State = cameraState.FollowPlayer,
    Distance = 40
}

function CameraController:KnitInit()
    print("CameraController initialized")
end

function CameraController:KnitStart() 
    print("CameraController started")

    repeat  
        task.wait() 
    until game.Players.LocalPlayer.Character

    local player = game.Players.LocalPlayer
    local character = player.Character
    local camera = game.Workspace.CurrentCamera

    -- Set the camera's CFrame for a top-down view
    local cameraOffset = Vector3.new(0, self.Distance, 0)
    local cameraLookAtOffset = Vector3.new(0, 0, 0)
    camera.CFrame = CFrame.new(character.HumanoidRootPart.Position +
                                   cameraOffset, character.HumanoidRootPart
                                   .Position + cameraLookAtOffset)

    -- Function to update the camera position and rotation
    local function updateCamera()
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

return CameraController

