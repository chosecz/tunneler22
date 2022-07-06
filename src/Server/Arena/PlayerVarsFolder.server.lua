--[[
game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)

		--player vars folder
		local playerVars = Instance.new("Folder")
		playerVars.Name = "PlayerVars"
		playerVars.Parent = player
		
		local inRefuelStation = Instance.new("BoolValue")
		inRefuelStation.Name = "InRefuelStation"
		inRefuelStation.Value = true
		inRefuelStation.Parent = playerVars
		
		local fuel = Instance.new("IntValue")
		fuel.Name = "Fuel"
		fuel.Value = 100
		fuel.Parent = playerVars
	end)
end)
]]