local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

player.CharacterAdded:Wait()
player.Character:WaitForChild("HumanoidRootPart")

camera.CameraSubject = player.Character.HumanoidRootPart
camera.CameraType = Enum.CameraType.Follow
camera.FieldOfView = 40

game:GetService('RunService').Stepped:Connect(function()
	if (player.Character) then
		local playerPosition = player.Character.HumanoidRootPart.Position
		local cameraPosition = playerPosition + Vector3.new(-0.1, 100, 0)
		camera.CFrame = CFrame.new(cameraPosition, playerPosition)
		camera.Focus = player.Character.HumanoidRootPart.CFrame	
	end
end)

print("CamScript")