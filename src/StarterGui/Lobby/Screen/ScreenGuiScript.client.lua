repeat task.wait() until game.Players.LocalPlayer.Character

local Players = game:GetService('Players')
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- create screen gui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.Enabled = true

print('ScreenGuid ready')