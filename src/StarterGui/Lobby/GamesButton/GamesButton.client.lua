repeat wait() until game.Players.LocalPlayer.Character
local CONST = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local FUNCTIONS = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local Players = game:GetService('Players')
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local function onButtonActivated()
	print("button pressed!")
end

-- create screen gui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.Enabled = true

-- create button
local gamesButton = FUNCTIONS.createButton({title="List of games"})
gamesButton.Parent = screenGui
gamesButton.Activated:Connect(onButtonActivated)
