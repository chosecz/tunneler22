local F = {}
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local Wrapper = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Wrapper'))
local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')
local remoteEvents = game:GetService('ReplicatedStorage'):WaitForChild('RemoteEvents')
local LocalPlayer = game:GetService('Players').LocalPlayer

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
		Activated = function(...)
			button.Activated:Connect(...)
		end,
	}
end

function F.listenToBindableEvents(list, f)
	for i, event in pairs(list) do
		bindableEvents[event].Event:Connect(f)
	end
end

function F.listenToRemoteEvents(list, f)
	for i, event in pairs(list) do
		remoteEvents[event].OnClientEvent:Connect(f)
	end
end

function F.isMyGame(game)
  if (game.Id == LocalPlayer:getAttribute("gameId")) then
    return true
  end
  return false
end

function F.createButton(options)
  local button = Instance.new("TextButton")
	local wrapper = Wrapper.new(button, customButtonFunctions(button))
	wrapper.Parent = options.Parent or nil
	wrapper.Text = options.Text or "Default"
	wrapper.Font = options.Font or "Arcade"
	wrapper.Size = options.Size or UDim2.new(0.2, 0, 0.05, 0)
	wrapper.Position = options.Position or UDim2.new(0.4, 0, 0.025, 0)
	wrapper.TextScaled = options.TextScaled or true
	wrapper.BackgroundColor3 = options.BackgroundColor3 or C.COLOR.BLUE_MUNSELL
	wrapper.BackgroundTransparency = options.BackgroundTransparency or 0
	wrapper.BorderColor3 = options.BorderColor3 or C.COLOR.MING
	wrapper.BorderSizePixel = options.BorderSizePixel or 5
	wrapper.LineHeight = options.LineHeight or 1
	wrapper.TextColor3 = options.TextColor3 or Color3.fromRGB(255, 255, 255)
	if (options.Activated) then
		wrapper.Activated(options.Activated)
	end
	if (options.Selected == true) then
		wrapper.Select()
	end
	return wrapper
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
	label.BorderSizePixel = options.BorderSizePixel or 0
	if options.BackgroundColor3 then
		label.BackgroundColor3 = options.BackgroundColor3
	end
	if options.TextColor3 then
		label.TextColor3 = options.TextColor3
	end
	label.BackgroundTransparency = options.BackgroundTransparency or 1
	return label
end

return F
