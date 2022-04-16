local GF = {}
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')

function GF.createGameRow(options)
	local gameRowFrame = Instance.new("Frame")
	gameRowFrame.Parent = options.Parent
	gameRowFrame.Position = options.Position or UDim2.new(0, 0, options.Index * 0.05 + 0.01, 0)
	gameRowFrame.Size = UDim2.new(1, 0, 0.05, 0)
	gameRowFrame.BackgroundColor3 = C.COLOR.TURQUOISE

	local gameNameTextLabel = F.createTextLabel({
		Parent = gameRowFrame,
		Text = options.Game.Owner.DisplayName,
		Size = UDim2.new(0.74, 0, 1, 0),
		Position = UDim2.new(0.01, 0, 0, 0),
		TextXAlignment = "Left",
	})
	if (options.Game.GameMode == C.GAME_MODE.ONE) then
		gameNameTextLabel.Text = gameNameTextLabel.Text .. " | 1 vs 1"
	elseif (options.Game.GameMode == C.GAME_MODE.TWO) then
		gameNameTextLabel.Text = gameNameTextLabel.Text .. " | 2 vs 2"
	end

	local gameJoinButton = F.createButton({
		Parent = gameRowFrame,
		Text = "Join",
		Size = UDim2.new(0.25, 0, 1, 0),
		Position = UDim2.new(0.75, 0, 0, 0),
		BorderSizePixel = 0,
		Activated = function()
			remoteFunctions.JoinGame:InvokeServer(options.Game.Id)
		end
	})
	if (options.Game.Full) then
		gameJoinButton.TextColor3 = C.COLOR.RUBY_RED
		gameJoinButton.Text = "Full"
		gameJoinButton.Active = false
	end

	return gameRowFrame
end

return GF
