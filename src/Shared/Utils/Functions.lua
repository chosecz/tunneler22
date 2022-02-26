local CONST = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local F = {}

function F.createButton(options)
  local button = Instance.new("TextButton")
	button.Parent = options.Parent or nil
	button.Text = options.Text
	button.Font = options.TextScale or "Arcade"
	button.Size = options.Size or UDim2.new(0.2, 0, 0.05, 0)
	button.Position = options.Position or UDim2.new(0.4, 0, 0.025, 0)
	button.TextScaled = options.TextScaled or true
	button.BackgroundColor3 = options.BackgroundColor3 or CONST.COLOR.BLUE_MUNSELL
	button.BackgroundTransparency = options.BackgroundTransparency or 0
	button.BorderColor3 = options.BorderColor3 or CONST.COLOR.MING
	button.BorderSizePixel = options.BorderSizePixel or 10
	button.TextColor3 = options.TextColor3 or Color3.fromRGB(255, 255, 255)
	if (options.Activated) then 
		button.Activated:Connect(options.Activated) 
	end
	return button
end

function F.makeButtonActive(button)
	button.BackgroundColor3 = CONST.COLOR.BLUE_MUNSELL
  button.BorderColor3 = CONST.COLOR.MING
end

function F.makeButtonInactive(button)
	button.BackgroundColor3 = CONST.COLOR.RUBY_RED
  button.BorderColor3 = CONST.COLOR.CATAWBA
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

return F
