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
local gamesButton = F.createButton({
	Text = 'Games',
	Parent = screenGui,
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