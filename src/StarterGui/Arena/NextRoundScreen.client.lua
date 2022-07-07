repeat task.wait() until game.Players.LocalPlayer.Character

local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteEvents = game.ReplicatedStorage:WaitForChild('RemoteEvents')
local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')

local servicePlayers = game:GetService("Players")

local player = servicePlayers.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local nextRoundScreen = nil

local function createNextRoundScreen()
  print("Creating Next Round screen")

  local gameStatus = remoteFunctions.GetGameStatus:InvokeServer()

  nextRoundScreen = Instance.new("ScreenGui")
  nextRoundScreen.Name = "NextRoundScreenGui"
  nextRoundScreen.DisplayOrder = 100
  nextRoundScreen.Parent = playerGui
  nextRoundScreen.IgnoreGuiInset = true
  nextRoundScreen.Enabled = false

  local frame = Instance.new("Frame")
  frame.Size = UDim2.new(1, 0, 1, 0)
  frame.Position = UDim2.new(0, 0, 0, 0)
  frame.BackgroundTransparency = 0
  frame.BackgroundColor3 = Color3.new(0, 0, 255)
  frame.BackgroundTransparency = 0.8
  frame.Parent = nextRoundScreen

  local text = Instance.new("TextLabel")
  text.Text = "Next round..."
  text.Size = UDim2.new(1, 0, 1, 0)
  text.Position = UDim2.new(0, 0, 0, 0)
  text.BackgroundTransparency = 1
  text.Font = Enum.Font.SourceSans
  text.FontSize = Enum.FontSize.Size36
  text.TextColor3 = Color3.new(1, 1, 1)
  text.TextStrokeTransparency = 0
  text.Parent = frame

  remoteEvents.StartGame.OnClientEvent:Connect(function(options)
    nextRoundScreen.Enabled = false
  end)
end

local function showNextRoundScreen()
  local gameStatus = remoteFunctions.GetGameStatus:InvokeServer()
  if (gameStatus == C.GAME_STATUS.NEXT_ROUND) then
    nextRoundScreen.Enabled = true
    wait(5)
    nextRoundScreen.Enabled = false
  end
end

createNextRoundScreen()

remoteEvents.NextRound.OnClientEvent:Connect(showNextRoundScreen)

print('Next Round Screen script created')