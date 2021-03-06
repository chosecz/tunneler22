repeat task.wait() until game.Players.LocalPlayer.Character

local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local remoteEvents = game.ReplicatedStorage:WaitForChild('RemoteEvents')
local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')

local servicePlayers = game:GetService("Players")

local player = servicePlayers.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screen = nil

local function createEndGameScreen()
  print("Creating End Game screen")

  local gameStatus = remoteFunctions.GetGameStatus:InvokeServer()

  screen = Instance.new("ScreenGui")
  screen.Name = "EndGameScreenGui"
  screen.DisplayOrder = 100
  screen.Parent = playerGui
  screen.IgnoreGuiInset = true
  if (gameStatus == C.GAME_STATUS.FINISHED) then
    screen.Enabled = true
  else
    screen.Enabled = false
  end

  local frame = Instance.new("Frame")
  frame.Size = UDim2.new(1, 0, 1, 0)
  frame.Position = UDim2.new(0, 0, 0, 0)
  frame.BackgroundTransparency = 0
  frame.BackgroundColor3 = Color3.new(0, 0, 255)
  frame.Parent = screen

  local text = Instance.new("TextLabel")
  text.Text = "End Game..."
  text.Size = UDim2.new(1, 0, 1, 0)
  text.Position = UDim2.new(0, 0, 0, 0)
  text.BackgroundTransparency = 1
  text.Font = Enum.Font.SourceSans
  text.FontSize = Enum.FontSize.Size36
  text.TextColor3 = Color3.new(1, 1, 1)
  text.TextStrokeTransparency = 0
  text.Parent = frame

  local rematchButton = F.createButton({
    Parent = frame,
    Text = "Rematch",
    Size = UDim2.new(0.25, 0, 0.05, 0),
    Position = UDim2.new(0.25, 0, 0.75, 0),
    Activated = function()
      remoteFunctions.StartNewGame:InvokeServer()
    end
  })
  local lobbyButton = F.createButton({
    Parent = frame,
    Text = "Lobby",
    Size = UDim2.new(0.25, 0, 0.05, 0),
    Position = UDim2.new(0.5, 0, 0.75, 0),
    Activated = function()
      remoteFunctions.StartNewGame:InvokeServer()
    end
  })
end

local function show()
  screen.Enabled = true
end

local function hide()
  screen.Enabled = false
end

createEndGameScreen()

remoteEvents.EndGame.OnClientEvent:Connect(show)
remoteEvents.NextGame.OnClientEvent:Connect(hide)

print('End Game Screen script created')