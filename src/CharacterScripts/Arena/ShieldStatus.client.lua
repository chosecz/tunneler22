repeat task.wait() until game.Players.LocalPlayer.Character

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local char = localPlayer.Character
local shieldBar = localPlayer.PlayerGui:WaitForChild('EnergyShieldStatus').ShieldFrame.Frame

print('ShieldStatus started')

-- I think this can be removed
char:WaitForChild("Humanoid"):GetPropertyChangedSignal("Health"):Connect(function()
	local data = UDim2.new(0,(char.Humanoid.Health / char.Humanoid.MaxHealth * 340), 0, 40)
	shieldBar.Size = data
end)
