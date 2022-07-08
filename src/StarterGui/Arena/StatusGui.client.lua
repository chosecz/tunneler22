repeat task.wait() until game.Players.LocalPlayer.Character
repeat task.wait() until game.Players.LocalPlayer:WaitForChild("PlayerGui")

local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))

print("StatusGui started")

-- Instances:
local ScreenGui = Instance.new("ScreenGui")
local EnergyBackgroundFrame = Instance.new("Frame")
local EnergyStatusFrame = Instance.new("Frame")
local EnergyLabel = Instance.new("TextLabel")
local ShieldBackgroundFrame = Instance.new("Frame")
local ShieldStatusFrame = Instance.new("Frame")
local ShieldLabel = Instance.new("TextLabel")

--Properties:
ScreenGui.Name = "EnergyShieldStatus"
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ShieldBackgroundFrame.Name = "ShieldBackgroundFrame"
ShieldBackgroundFrame.Parent = ScreenGui
ShieldBackgroundFrame.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
ShieldBackgroundFrame.BorderSizePixel = 0
ShieldBackgroundFrame.Position = UDim2.new(0.05, 0, 0.7, 0)
ShieldBackgroundFrame.Size = UDim2.new(0.3, 0, 0.1, 0)

ShieldStatusFrame.Name = "ShieldStatusFrame"
ShieldStatusFrame.Parent = ShieldBackgroundFrame
ShieldStatusFrame.BackgroundColor3 = Color3.fromRGB(0, 213, 255)
ShieldStatusFrame.BorderSizePixel = 0
ShieldStatusFrame.Position = UDim2.new(0, 0, 0, 0)
ShieldStatusFrame.Size = UDim2.new(1, 0, 1, 0)

EnergyBackgroundFrame.Name = "EnergyBackgroundFrame"
EnergyBackgroundFrame.Parent = ScreenGui
EnergyBackgroundFrame.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
EnergyBackgroundFrame.BorderSizePixel = 0
EnergyBackgroundFrame.Position = UDim2.new(0.05, 0, 0.825, 0)
EnergyBackgroundFrame.Size = UDim2.new(0.3, 0, 0.1, 0)

EnergyStatusFrame.Name = "EnergyStatusFrame"
EnergyStatusFrame.Parent = EnergyBackgroundFrame
EnergyStatusFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
EnergyStatusFrame.BorderSizePixel = 0
EnergyStatusFrame.Position = UDim2.new(0, 0, 0, 0)
EnergyStatusFrame.Size = UDim2.new(1, 0, 1, 0)

local EnergyLabel = F.createTextLabel({
  Parent = EnergyBackgroundFrame,
  Text = "Energy",
  Size = UDim2.new(0.5, 0, 0.5, 0),
  Position = UDim2.new(0.25, 0, 0.25, 0),
  TextColor3 = Color3.fromRGB(0, 0, 0),
})

local ShieldLabel = F.createTextLabel({
  Parent = ShieldBackgroundFrame,
  Text = "Shield",
  Size = UDim2.new(0.5, 0, 0.5, 0),
  Position = UDim2.new(0.25, 0, 0.25, 0),
  TextColor3 = Color3.fromRGB(0, 0, 0),
})

print("StatusGui created")
