local CONST = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local Functions = {}

function Functions.createButton(options)
  local button = Instance.new("TextButton")
	button.Text = options.title
	button.Font = "Arcade"
	button.Size = options.size or UDim2.new(0.2, 0, 0.05, 0)
	button.Position = options.position or UDim2.new(0.4, 0, 0.025, 0)
	button.TextScaled = true
	button.BackgroundColor3 = CONST.BUTTON_BACKGROUND_COLOR3
	button.BorderColor3 = Color3.fromRGB(0, 0, 163)
	button.BorderSizePixel = 10
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	return button
end

return Functions
