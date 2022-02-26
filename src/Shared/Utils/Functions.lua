local CONST = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local Functions = {}

function Functions.createButton(options)
  local button = Instance.new("TextButton")
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
	return button
end

function Functions.makeButtonActive(button)
	button.BackgroundColor3 = CONST.COLOR.BLUE_MUNSELL
  button.BorderColor3 = CONST.COLOR.MING
	return button
end

function Functions.makeButtonInactive(button)
	button.BackgroundColor3 = CONST.COLOR.RUBY_RED
  button.BorderColor3 = CONST.COLOR.CATAWBA
	return button
end

return Functions
