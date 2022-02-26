repeat wait() until game.Players.LocalPlayer.Character

local FUNCTIONS = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local screenGui = game:GetService('Players').LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local bindableEvents = game:GetService("ReplicatedStorage"):WaitForChild('BindableEvents')
local blur = game:GetService('Lighting'):WaitForChild("Blur")

local gamesButtonPressed = bindableEvents:WaitForChild('GamesButtonPressed')
local gamesGuiFrameClosed = bindableEvents:WaitForChild('GamesGuiFrameClosed')

-- create button
print("GamesButton: Creating")
local gamesButton = FUNCTIONS.createButton({Text="Games"})
gamesButton.Parent = screenGui
gamesButton.Activated:Connect(function()
	gamesButton.Visible = false
	blur.Enabled = true
	gamesButtonPressed:Fire()
end)
print("GamesButton: Done")

-- Show Games button when party screen is closed
gamesGuiFrameClosed.Event:Connect(function()
  gamesButton.Visible = true
	blur.Enabled = false
end)