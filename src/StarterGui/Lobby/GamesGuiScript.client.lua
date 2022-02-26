repeat wait() until game.Players.LocalPlayer.Character

local FUNCTIONS = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local screenGui = game:GetService('Players').LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local BindableEvents = game:GetService("ReplicatedStorage"):WaitForChild('BindableEvents')
local gamesButtonPressed = BindableEvents:WaitForChild('GamesButtonPressed')
local gamesGuiFrameClosed = BindableEvents:WaitForChild('GamesGuiFrameClosed')

-- party screen
print("GamesGui: Creating")
local gamesGuiFrame = Instance.new("Frame")
gamesGuiFrame.Name = "GamesGui"
gamesGuiFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
gamesGuiFrame.BackgroundTransparency = 0.5
gamesGuiFrame.Position = UDim2.new(0.1, 0, 0, 0)
gamesGuiFrame.Size = UDim2.new(0.8, 0, 0.9, 0)
gamesGuiFrame.Visible = false
gamesGuiFrame.Parent = screenGui

local closeButton = FUNCTIONS.createButton({
  Text = "X",
  Size = UDim2.new(0.05, 0, 0.09, 0),
  Position = UDim2.new(0.95, 0, 0.01, 0),
  BackgroundTransparency = 1,
  TextColor3 = Color3.fromRGB(0, 0, 0)
})
closeButton.Parent = gamesGuiFrame
closeButton.Activated:Connect(function()
  gamesGuiFrameClosed:Fire()
end)
print("GamesGui: Done")

-- Shows party gui frame when user click on Games Button
gamesButtonPressed.Event:Connect(function()
  gamesGuiFrame.Visible = true
end)

-- Hides party gui when user clicks on Close Button
gamesGuiFrameClosed.Event:Connect(function()
  gamesGuiFrame.Visible = false
end)
