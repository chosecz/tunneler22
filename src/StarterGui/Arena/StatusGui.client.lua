repeat task.wait() until game.Players.LocalPlayer.Character
--[[
repeat task.wait() until game.Players.LocalPlayer.PlayerGui.WaitingScreen.Enabled == false
-- Instances:

local ScreenGui = Instance.new("ScreenGui")
local EnergyFrame = Instance.new("Frame")
local Frame = Instance.new("Frame")
local EnergyLabel = Instance.new("TextLabel")
local ShieldFrame = Instance.new("Frame")
local Frame_2 = Instance.new("Frame")
local ShieldLabel = Instance.new("TextLabel")

--Properties:
ScreenGui.Name = "EnergyShieldStatus"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

EnergyFrame.Name = "EnergyFrame"
EnergyFrame.Parent = ScreenGui
EnergyFrame.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
EnergyFrame.BorderSizePixel = 0
EnergyFrame.Position = UDim2.new(0.0543900542, 0, 0.849624038, 0)
EnergyFrame.Size = UDim2.new(0, 380, 0, 80)

Frame.Parent = EnergyFrame
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.0526315793, 0, 0.25, 0)
Frame.Size = UDim2.new(0, 340, 0, 40)

EnergyLabel.Name = "EnergyLabel"
EnergyLabel.Parent = Frame
EnergyLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
EnergyLabel.BackgroundTransparency = 1.000
EnergyLabel.BorderSizePixel = 0
EnergyLabel.Size = UDim2.new(0, 340, 0, 40)
EnergyLabel.Font = Enum.Font.Arcade
EnergyLabel.Text = "Energy"
EnergyLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
EnergyLabel.TextScaled = true
EnergyLabel.TextSize = 14.000
EnergyLabel.TextWrapped = true

ShieldFrame.Name = "ShieldFrame"
ShieldFrame.Parent = ScreenGui
ShieldFrame.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
ShieldFrame.BorderSizePixel = 0
ShieldFrame.Position = UDim2.new(0.0543900542, 0, 0.711779475, 0)
ShieldFrame.Size = UDim2.new(0, 380, 0, 80)

Frame_2.Parent = ShieldFrame
Frame_2.BackgroundColor3 = Color3.fromRGB(0, 213, 255)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0.0526315793, 0, 0.25, 0)
Frame_2.Size = UDim2.new(0, 340, 0, 40)

ShieldLabel.Name = "ShieldLabel"
ShieldLabel.Parent = Frame_2
ShieldLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ShieldLabel.BackgroundTransparency = 1.000
ShieldLabel.BorderSizePixel = 0
ShieldLabel.Size = UDim2.new(0, 340, 0, 40)
ShieldLabel.Font = Enum.Font.Arcade
ShieldLabel.Text = "Shield"
ShieldLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
ShieldLabel.TextScaled = true
ShieldLabel.TextSize = 14.000
ShieldLabel.TextWrapped = true

]]