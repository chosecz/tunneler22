repeat wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local gameGui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui'):WaitForChild('GamesGui')
local BindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')
local createGameButtonPressed = BindableEvents:WaitForChild('CreateGameButtonPressed')
local publicGamesButtonPressed = BindableEvents:WaitForChild('PublicGamesButtonPressed')

local publicGamesGui = Instance.new("Frame")
publicGamesGui.Name = "PublicGamesGui"
publicGamesGui.Parent = gameGui
-- good for debuging
publicGamesGui.BackgroundColor3 = C.COLOR.DARK_SLATE_GRAY
publicGamesGui.BackgroundTransparency = 0.5
publicGamesGui.Position = UDim2.new(0, 0, 0.15, 0)
publicGamesGui.Size = UDim2.new(1, 0, 0.85, 0)
publicGamesGui.Visible = true

-- BINDABLE EVENTS
createGameButtonPressed.Event:Connect(function()
  publicGamesGui.Visible = false
end)

publicGamesButtonPressed.Event:Connect(function()
  publicGamesGui.Visible = true
end)
