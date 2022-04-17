repeat task.wait() until game.Players.LocalPlayer.Character

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

player.Character:WaitForChild("HumanoidRootPart")

camera.CameraSubject = player.Character.HumanoidRootPart
camera.FieldOfView = 40
camera.CameraType = Enum.CameraType.Scriptable

game:GetService('RunService').Stepped:Connect(function()
	if (player.Character and player.Character.HumanoidRootPart) then
		local playerPosition = player.Character.HumanoidRootPart.Position
		local cameraPosition = playerPosition + Vector3.new(-0.1, 100, 0)
		camera.CFrame = CFrame.new(cameraPosition, playerPosition)
		camera.Focus = player.Character.HumanoidRootPart.CFrame
	end
end)

print("CamScript")