repeat task.wait() until game.Players.LocalPlayer.Character

local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local remoteEvents = game.ReplicatedStorage:WaitForChild('RemoteEvents')
local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')

local servicePlayers = game:GetService("Players")

local player = servicePlayers.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screen = nil
local rematchLabel = nil
local rematchButton = nil

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
  frame.BackgroundColor3 = Color3.new(0.133333, 0.133333, 0.133333)
  frame.Parent = screen

  local text = Instance.new("TextLabel")
  text.Text = "End Game..."
  text.Size = UDim2.new(1, 0, 1, 0)
  text.Position = UDim2.new(0, 0, 0, 0)
  text.BackgroundTransparency = 1
  text.Font = Enum.Font.Arcade
  text.FontSize = Enum.FontSize.Size36
  text.TextColor3 = Color3.new(1, 1, 1)
  text.TextStrokeTransparency = 0
  text.Parent = frame

  rematchLabel = Instance.new("TextLabel")
  rematchLabel.Name = "RematchText"
  rematchLabel.Text = "this text how to generate it here??????"
  rematchLabel.Size = UDim2.new(1, 0, 1, 0)
  rematchLabel.Position = UDim2.new(0, 0, 0, 0)
  rematchLabel.BackgroundTransparency = 1
  rematchLabel.Font = Enum.Font.Arcade
  rematchLabel.FontSize = Enum.FontSize.Size36
  rematchLabel.TextColor3 = Color3.new(1, 1, 1)
  rematchLabel.TextStrokeTransparency = 0
  rematchLabel.Parent = frame
  rematchLabel.Visible = true

  local function hideRematchButton()
    rematchButton.Visible = false
  end

  local function isRematchButtonVisible()
    print("inside isRematchButtonVisible")
    if (player:GetAttribute("WantRematch") == true) then
      return false
    end
    return true
  end

  print("isRematchButtonVisible", isRematchButtonVisible())

  rematchButton = F.createButton({
    Parent = frame,
    Visible = isRematchButtonVisible(),
    Text = "Rematch",
    Size = UDim2.new(0.25, 0, 0.05, 0),
    Position = UDim2.new(0.25, 0, 0.75, 0),
    Activated = function()
      remoteFunctions.RematchGame:InvokeServer()
      hideRematchButton()
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
  rematchButton.Visible = true
  rematchLabel.Visible = false
end

local function hide()
  screen.Enabled = false
end

local function updateRematchText(text)
  print('updateRematchText', text)
  rematchLabel.Text = text
  rematchLabel.Position = UDim2.new(0.37, 0, 0.6, 0)
  rematchLabel.Visible = true
  rematchLabel.Size = UDim2.new(0.2, 0, 0.1, 0)
end

createEndGameScreen()

remoteEvents.EndGame.OnClientEvent:Connect(show)
remoteEvents.NextGame.OnClientEvent:Connect(hide)
remoteEvents.UpdateRematchText.OnClientEvent:Connect(updateRematchText)

print('End Game Screen script created')