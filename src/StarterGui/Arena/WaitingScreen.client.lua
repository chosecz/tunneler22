repeat task.wait() until game.Players.LocalPlayer.Character

local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteEvents = game.ReplicatedStorage:WaitForChild('RemoteEvents')
local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')

local servicePlayers = game:GetService("Players")

local player = servicePlayers.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function createWaitingScreen()
  print("creating waiting screen")

  local gameStatus = remoteFunctions.GetGameStatus:InvokeServer()

  local waitingScreen = Instance.new("ScreenGui")
  waitingScreen.DisplayOrder = 100
  waitingScreen.Name = "WaitingScreenGui"
  waitingScreen.Parent = playerGui
  waitingScreen.IgnoreGuiInset = true
  if (gameStatus == C.GAME_STATUS.WAITING) then
    waitingScreen.Enabled = true
  else
    waitingScreen.Enabled = false
  end

  local waitingScreenFrame = Instance.new("Frame")
  waitingScreenFrame.Name = "WaitingScreenFrame"
  waitingScreenFrame.Size = UDim2.new(1, 0, 1, 0)
  waitingScreenFrame.Position = UDim2.new(0, 0, 0, 0)
  waitingScreenFrame.BackgroundTransparency = 0
  waitingScreenFrame.BackgroundColor3 = Color3.new(0, 0, 255)
  waitingScreenFrame.BackgroundTransparency = 0
  waitingScreenFrame.Parent = waitingScreen

  local waitingScreenText = Instance.new("TextLabel")
  waitingScreenText.Name = "WaitingScreenText"
  waitingScreenText.Text = "Waiting for players to connect"
  waitingScreenText.Size = UDim2.new(1, 0, 1, 0)
  waitingScreenText.Position = UDim2.new(0, 0, 0, 0)
  waitingScreenText.BackgroundTransparency = 1
  waitingScreenText.Font = Enum.Font.SourceSans
  waitingScreenText.FontSize = Enum.FontSize.Size36
  waitingScreenText.TextColor3 = Color3.new(1, 1, 1)
  waitingScreenText.TextStrokeTransparency = 0
  waitingScreenText.Parent = waitingScreenFrame

  remoteEvents.StartGame.OnClientEvent:Connect(function(options)
    waitingScreen.Enabled = false
  end)
end

createWaitingScreen()

print('Arena Waiting Screen created')