repeat task.wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local LocalPlayer = game:GetService('Players').LocalPlayer
local screenGui = LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui')

local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')
local getGame = remoteFunctions:WaitForChild('GetGame')

local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')

-- create button
print("MyGameGui: Creating")

function CreateMyGameGui()
  print("creating my game gui")
  local gameId = LocalPlayer:getAttribute("gameId")

  local game = getGame:InvokeServer(gameId)
  print("game from server", game)

  local myGameGui = Instance.new("Frame")
  myGameGui.Name = "MyGameGui"
  myGameGui.BackgroundColor3 = C.COLOR.TURQUOISE
  myGameGui.BackgroundTransparency = 0.5
  myGameGui.Position = UDim2.new(0.8, 0, 0.3, 0)
  myGameGui.Size = UDim2.new(0.2, 0, 0.6, 0)
  myGameGui.Visible = true
  myGameGui.Parent = screenGui
  myGameGui:GetPropertyChangedSignal("Visible"):Connect(function()
    -- gamesGuiVisibilityChanged:Fire(myGameGui.Visible)
  end)

  local leaveButton = F.createButton({
    Parent = myGameGui,
    Text = "Leave Game",
    Size = UDim2.new(0.8, 0, 0.05, 0),
    Position = UDim2.new(0.1, 0, 0.8, 0),
    Activated = function()
      print("leaveButton")
      -- publicGamesButtonPressed:Fire()
    end
  })
  leaveButton.Unselect()

  local readyButton = F.createButton({
    Parent = myGameGui,
    Text = "Ready",
    Size = UDim2.new(0.8, 0, 0.05, 0),
    Position = UDim2.new(0.1, 0, 0.9, 0),
    Activated = function()
      print("ready")
    end
  })

  -- for 1 vs 1
  if (game.GameMode == C.GAME_MODE.ONE) then
    local red1name = F.createTextLabel({
      Parent = myGameGui,
      Text = "Waiting for player",
      Size = UDim2.new(0.7, 0, 0.1, 0),
      Position = UDim2.new(0.25, 0, 0.05, 0),
      BackgroundColor3 = Color3.fromRGB(255, 0, 0),
      BackgroundTransparency = 0,
    })
    local red1Ready = F.createTextLabel({
      Parent = myGameGui,
      -- Text = "✅",
      Text = "?",
      Size = UDim2.new(0.2, 0, 0.1, 0),
      Position = UDim2.new(0.05, 0, 0.2, 0),
    })
    local blue1name = F.createTextLabel({
      Parent = myGameGui,
      Text = "Waiting for player",
      Size = UDim2.new(0.7, 0, 0.1, 0),
      Position = UDim2.new(0.25, 0, 0.2, 0),
      BackgroundColor3 = Color3.fromRGB(0, 0, 255),
      BackgroundTransparency = 0,
    })
    local blue1Ready = F.createTextLabel({
      Parent = myGameGui,
      -- Text = "✅",
      Text = "?",
      Size = UDim2.new(0.2, 0, 0.1, 0),
      Position = UDim2.new(0.05, 0, 0.05, 0),
    })

    if (#game.Teams[C.GAME_TEAM.RED] > 0) then
      red1name.Text = game.Teams[C.GAME_TEAM.RED][1].DisplayName
    end
    if (#game.Teams[C.GAME_TEAM.BLUE] > 0) then
      blue1name.Text = game.Teams[C.GAME_TEAM.BLUE][1].DisplayName
    end
  end

  -- for 2 vs 2
  if (game.GameMode == C.GAME_MODE.TWO) then
    local red2name = F.createTextLabel({
      Parent = myGameGui,
      Text = "Waiting for player",
      Size = UDim2.new(0.7, 0, 0.1, 0),
      Position = UDim2.new(0.25, 0, 0.2, 0),
      BackgroundColor3 = Color3.fromRGB(255, 0, 0),
      BackgroundTransparency = 0,
    })
    local red2Ready = F.createTextLabel({
      Parent = myGameGui,
      -- Text = "✅",
      Text = "?",
      Size = UDim2.new(0.2, 0, 0.1, 0),
      Position = UDim2.new(0.05, 0, 0.2, 0),
    })
  end

end

-- BINDABLE EVENTS
bindableEvents.GameCreated.Event:Connect(CreateMyGameGui)
bindableEvents.AddedPlayerToGame.Event:Connect(CreateMyGameGui)

-- for debug
-- CreateMyGameGui()

print("MyGameGui: Done")
