repeat task.wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local screenGui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui')
local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')

-- create button
print("GamesButton: Creating")
local gamesButton = F.createButton({
	Text = 'Games',
	Parent = screenGui,
	Activated = function()
		bindableEvents.GamesButtonPressed:Fire()
	end
})
print("GamesButton: Done")

bindableEvents.GamesButtonPressed.Event:Connect(function()
  gamesButton.Visible = false
end)

-- Show Games button when party screen is closed
bindableEvents.GamesCloseButtonPressed.Event:Connect(function()
  gamesButton.Visible = true
end)
