local F = {}
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')
local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')
local addedPlayerToGame = bindableEvents:WaitForChild('AddedPlayerToGame')

function F.createButton(options)
  local button = Instance.new("TextButton")
	button.Parent = options.Parent or nil
	button.Text = options.Text
	button.Font = options.TextScale or "Arcade"
	button.Size = options.Size or UDim2.new(0.2, 0, 0.05, 0)
	button.Position = options.Position or UDim2.new(0.4, 0, 0.025, 0)
	button.TextScaled = options.TextScaled or true
	button.BackgroundColor3 = options.BackgroundColor3 or C.COLOR.BLUE_MUNSELL
	button.BackgroundTransparency = options.BackgroundTransparency or 0
	button.BorderColor3 = options.BorderColor3 or C.COLOR.MING
	button.BorderSizePixel = options.BorderSizePixel or 10
	button.TextColor3 = options.TextColor3 or Color3.fromRGB(255, 255, 255)
	if (options.Activated) then 
		button.Activated:Connect(options.Activated) 
	end
	return button
end

function F.makeButtonActive(button)
	button.BackgroundColor3 = C.COLOR.BLUE_MUNSELL
  button.BorderColor3 = C.COLOR.MING
end

function F.makeButtonInactive(button)
	button.BackgroundColor3 = C.COLOR.RUBY_RED
  button.BorderColor3 = C.COLOR.CATAWBA
end

function F.createTextLabel(options)
	local label = Instance.new("TextLabel")
	if options.Name then
		label.Name = options.Name
	end
	label.Text = options.Text or nil
	label.Font = options.Font or "Arcade"
	label.Parent = options.Parent or nil
	label.Size = options.Size or UDim2.new(0.2, 0, 0.1, 0)
	label.Position = options.Position or UDim2.new(0.4, 0, 0.4, 0)
	label.TextScaled = options.TextScaled or true
	label.BackgroundTransparency = options.BackgroundTransparency or 1
	return label
end

function F.createGameRow(options)
	local gameRowFrame = Instance.new("Frame")
	gameRowFrame.Parent = options.Parent
	gameRowFrame.Position = options.Position or UDim2.new(0, 0, options.Index * 0.05, 0)
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
		local response = remoteFunctions.AddPlayerToGame:InvokeServer(options.Game.Id)
    print("Game joined", response)
    addedPlayerToGame:Fire()
	end)

	return gameRowFrame
end

return F
