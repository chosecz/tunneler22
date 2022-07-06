repeat task.wait() until game.Players.LocalPlayer.Character

local players = game:GetService("Players")
local player = players.LocalPlayer
local char = player.Character
local shieldBar = player.PlayerGui.EnergyShieldStatus.ShieldFrame.Frame

char:WaitForChild("Humanoid"):GetPropertyChangedSignal("Health"):Connect(function()
	print("Health changed")
	local data = UDim2.new(0,(char.Humanoid.Health / char.Humanoid.MaxHealth * 340), 0, 40)
	shieldBar.Size = data
end)
