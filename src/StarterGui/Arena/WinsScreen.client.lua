repeat task.wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteEvents = game.ReplicatedStorage:WaitForChild('RemoteEvents')
local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')

local players = game:GetService("Players")

local localPlayer = players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local function renderWins()
  print("Creating Wins Screen")

  local wins = remoteFunctions.GetWins:InvokeServer()

  -- destroy if WinsSceen already exists
  if playerGui:FindFirstChild("WinsScreenGui") then
    playerGui.WinsScreenGui:Destroy()
  end

  local screenGui = Instance.new("ScreenGui")
  screenGui.Name = "WinsScreenGui"
  screenGui.Enabled = true
  screenGui.Parent = playerGui

  local winsScreenFrame = Instance.new("Frame")
  winsScreenFrame.Name = "WinsScreenFrame"
  winsScreenFrame.Size = UDim2.new(0.5, 0, 0.1, 0)
  winsScreenFrame.Position = UDim2.new(0.25, 0, 0.01, 0)
  winsScreenFrame.BackgroundTransparency = 1
  winsScreenFrame.Parent = screenGui

  local redWins = F.createTextLabel({
    Name = "RedWins",
    Parent = winsScreenFrame,
    Text = wins[C.TEAM.RED],
    Size = UDim2.new(0.4, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    TextColor3 = Color3.new(255, 0, 0),
  })

  local middle = F.createTextLabel({
    Parent = winsScreenFrame,
    Text = ":",
    Size = UDim2.new(0.2, 0, 1, 0),
    Position = UDim2.new(0.4, 0, 0, 0),
  })

  local blueWins = F.createTextLabel({
    Name = "BlueWins",
    Parent = winsScreenFrame,
    Text = wins[C.TEAM.BLUE],
    Size = UDim2.new(0.4, 0, 1, 0),
    Position = UDim2.new(0.6, 0, 0, 0),
    TextColor3 = Color3.new(0, 0, 255),
  })
end

renderWins()

remoteEvents.NextRound.OnClientEvent:Connect(renderWins)
remoteEvents.EndGame.OnClientEvent:Connect(renderWins)
remoteEvents.NextGame.OnClientEvent:Connect(renderWins)

print('Arena Wins Screen created')