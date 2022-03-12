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
		bindableEvents.ShowGamesGui:Fire()
	end
})
print("GamesButton: Done")

local function show()
	gamesButton.Visible = true
end
local function hide()
	gamesButton.Visible = false
end

function listenToBindableEvents(list, f)
	for i, event in pairs(list) do
		bindableEvents[event].Event:Connect(f)
	end
end

-- Show Games button
listenToBindableEvents({ "HideGamesGui", "ShowGamesButton" }, show)

-- Hide Games button
listenToBindableEvents({ "ShowGamesGui", "HideGamesButton" }, hide)