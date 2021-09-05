repeat wait() until game.Players.LocalPlayer.Character
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
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
local gamesButton = Instance.new("TextButton")
gamesButton.Parent = screenGui
gamesButton.Text = "List of Games"
gamesButton.Font = "Arcade"
gamesButton.Size = UDim2.new(0.2, 0, 0.05, 0)
gamesButton.Position = UDim2.new(0.4, 0, 0.025, 0)
gamesButton.TextScaled = true
gamesButton.BackgroundColor3 = C.BUTTON_BACKGROUND_COLOR3
gamesButton.BorderColor3 = Color3.fromRGB(0, 0, 163)
gamesButton.BorderSizePixel = 10
gamesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
gamesButton.Activated:Connect(onButtonActivated)
