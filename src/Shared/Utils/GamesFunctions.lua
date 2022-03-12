local GF = {}
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')

function GF.createGameRow(options)
	local gameRowFrame = Instance.new("Frame")
	gameRowFrame.Parent = options.Parent
	gameRowFrame.Position = options.Position or UDim2.new(0, 0, options.Index * 0.05 + 0.01, 0)
	gameRowFrame.Size = UDim2.new(1, 0, 0.05, 0)
	gameRowFrame.BackgroundColor3 = C.COLOR.TURQUOISE

	local gameNameTextLabel = Instance.new("TextLabel")
	gameNameTextLabel.Parent = gameRowFrame
	gameNameTextLabel.Position = UDim2.new(0.01, 0, 0, 0)
	gameNameTextLabel.Size = UDim2.new(0.74, 0, 1, 0)
	gameNameTextLabel.BackgroundColor3 = C.COLOR.BLUE_MUNSELL
	-- gameNameTextLabel.BackgroundTransparency = 1
	gameNameTextLabel.Text = options.Game.Owner.DisplayName.."|"..options.Game.GameMode
	gameNameTextLabel.TextXAlignment = "Left"

	local gameJoinButton = Instance.new("TextButton")
	gameJoinButton.Parent = gameRowFrame
	gameJoinButton.Position = UDim2.new(0.75, 0, 0, 0)
	gameJoinButton.Size = UDim2.new(0.25, 0, 1, 0)
	gameJoinButton.Text = "Join"
	gameJoinButton.Activated:Connect(function()
		print("Going join to game")
		local response = remoteFunctions.JoinGame:InvokeServer(options.Game.Id)
    print("Game joined", response)
	end)

	return gameRowFrame
end

return GF
