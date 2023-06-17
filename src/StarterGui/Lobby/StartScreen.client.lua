repeat task.wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')

local Players = game:GetService('Players')
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- create screen gui
print('ScreenGui: Creating')
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.Enabled = true

-- create button
print("GamesButton: Creating")
local gamesButton = F.createImgButton({
	Name = "Button",
	ResampleMode = "Pixelated",
	Parent = screenGui,
	Size = UDim2.new(0.12,0, 0.09, 0),
	Position = UDim2.new(0.015, 0, 0.4, 0),
	Image = "rbxassetid://13776910126",
	ScaleType = "Stretch",
	Activated = function()
		bindableEvents.ShowGamesGui:Fire()
	end
})

print("ShopButton: Creating")
local shopButton = F.createImgButton({
	Name = "Button",
	ResampleMode = "Pixelated",
	Parent = screenGui,
	Size = UDim2.new(0.12,0, 0.09, 0),
	Position = UDim2.new(0.015, 0, 0.4, 0),
	Image = "rbxassetid://13776910126",
	ScaleType = "Stretch",
	Activated = function()
		bindableEvents.ShowGamesGui:Fire()
	end
})
print("GamesButton: Done")

local function showButton()
	gamesButton.Visible = true
end
local function hideButton()
	gamesButton.Visible = false
end

-- Show Games button
F.listenToBindableEvents({ "HideGamesGui", "ShowGamesButton" }, showButton)

-- Hide Games button
F.listenToBindableEvents({ "ShowGamesGui", "HideGamesButton" }, hideButton)

print('ScreenGui: Done')