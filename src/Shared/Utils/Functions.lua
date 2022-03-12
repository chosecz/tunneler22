local F = {}
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local Wrapper = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Wrapper'))

local function customButtonFunctions(button)
	return {
		Select = function ()
			button.BackgroundColor3 = C.COLOR.RUBY_RED
			button.BorderColor3 = C.COLOR.CATAWBA
		end,
		Unselect = function ()
			button.BackgroundColor3 = C.COLOR.BLUE_MUNSELL
			button.BorderColor3 = C.COLOR.MING
		end,
	}
end

function F.createButton(options)
  local button = Instance.new("TextButton")
	button = Wrapper.new(button, customButtonFunctions(button))
	button.Parent = options.Parent or nil
	button.Text = options.Text or "Default"
	button.Font = options.Font or "Arcade"
	button.Size = options.Size or UDim2.new(0.2, 0, 0.05, 0)
	button.Position = options.Position or UDim2.new(0.4, 0, 0.025, 0)
	button.TextScaled = options.TextScaled or true
	button.BackgroundColor3 = options.BackgroundColor3 or C.COLOR.BLUE_MUNSELL
	button.BackgroundTransparency = options.BackgroundTransparency or 0
	button.BorderColor3 = options.BorderColor3 or C.COLOR.MING
	button.BorderSizePixel = options.BorderSizePixel or 10
	button.TextColor3 = options.TextColor3 or Color3.fromRGB(255, 255, 255)
	if (options.Activated) then
		button.Object.Activated:Connect(options.Activated)
	end
	if (options.Selected == true) then
		button.Select()
	end
	return button
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
	if options.BackgroundColor3 then
		label.BackgroundColor3 = options.BackgroundColor3
	end
	label.BackgroundTransparency = options.BackgroundTransparency or 1
end

return F
