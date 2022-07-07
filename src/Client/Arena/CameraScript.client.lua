repeat task.wait() until game.Players.LocalPlayer.Character
print("CamScript started")

local localPlayer = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

camera.CameraSubject = localPlayer.Character:WaitForChild("HumanoidRootPart")
camera.FieldOfView = 40
camera.CameraType = Enum.CameraType.Scriptable

game:GetService('RunService').Stepped:Connect(function()
	if (localPlayer.Character and localPlayer.Character.HumanoidRootPart) then
		local playerPosition = localPlayer.Character.HumanoidRootPart.Position
		local cameraPosition = playerPosition + Vector3.new(-0.1, 100, 0)
		camera.CFrame = CFrame.new(cameraPosition, playerPosition)
		camera.Focus = localPlayer.Character.HumanoidRootPart.CFrame
	end
end)

