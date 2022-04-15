repeat task.wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local gamesGui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui'):WaitForChild('GamesGui')
local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')

local friendGamesGui = Instance.new("Frame")
friendGamesGui.Name = "FriendGamesGui"
friendGamesGui.Parent = gamesGui
-- good for debuging
friendGamesGui.BackgroundColor3 = C.COLOR.RUBY_RED
friendGamesGui.BackgroundTransparency = 0.5
friendGamesGui.Position = UDim2.new(0, 0, 0.15, 0)
friendGamesGui.Size = UDim2.new(1, 0, 0.85, 0)
friendGamesGui.Visible = false

-- BINDABLE EVENTS
bindableEvents.ShowPublicGamesGui.Event:Connect(function()
  friendGamesGui.Visible = false
end)

bindableEvents.ShowFriendGamesGui.Event:Connect(function()
  friendGamesGui.Visible = true
end)

bindableEvents.ShowCreateGameGui.Event:Connect(function()
  friendGamesGui.Visible = false
end)
