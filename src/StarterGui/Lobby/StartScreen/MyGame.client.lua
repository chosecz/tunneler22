repeat task.wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local LocalPlayer = game:GetService('Players').LocalPlayer
local screenGui = LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui')
local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')
local remoteEvents = game:GetService('ReplicatedStorage'):WaitForChild('RemoteEvents')
local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')

-- create button
print("MyGameGui: Creating")

local myGameGui = Instance.new("Frame")
myGameGui.Name = "MyGameGui"
myGameGui.BackgroundColor3 = C.COLOR.TURQUOISE
myGameGui.BackgroundTransparency = 0.5
myGameGui.Position = UDim2.new(0.1, 0, 0, 0)
myGameGui.Size = UDim2.new(0.8, 0, 0.9, 0)
myGameGui.Visible = false
myGameGui.Parent = screenGui
myGameGui:GetPropertyChangedSignal("Visible"):Connect(function()
  -- gamesGuiVisibilityChanged:Fire(myGameGui.Visible)
end)

function RenderMyGameGui(game)
  print("creating my game gui")

  local gameId = game.Id

  -- clear if exists
  local list = myGameGui:GetChildren()
	for i, row in pairs(list) do
		row:Destroy()
	end

  local UICorner = Instance.new("UICorner")
  UICorner.CornerRadius = UDim.new(0.01, 0)
  UICorner.Parent = myGameGui

  local countDownLabel = F.createTextLabel({
    Parent = myGameGui,
    Text = "Game will start when all players are ready",
    Size = UDim2.new(0.8, 0, 0.075, 0),
    Position = UDim2.new(0.1, 0, 0.05, 0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 255, 255),
  })
  
  -- show my game gui
  myGameGui.Visible = true

  local leaveButton = F.createButton({
    Parent = myGameGui,
    Text = "Leave Game",
    Size = UDim2.new(0.8, 0, 0.05, 0),
    Position = UDim2.new(0.1, 0, 0.8, 0),
    Activated = function()
      remoteFunctions.LeaveGame:InvokeServer(gameId)
      bindableEvents.ShowGamesButton:Fire()
      myGameGui.Visible = false
    end
  })

  local readyButton = F.createButton({
    Parent = myGameGui,
    Text = "Ready?",
    Size = UDim2.new(0.8, 0, 0.05, 0),
    Position = UDim2.new(0.1, 0, 0.9, 0),
  })
  readyButton.Activated(function()
    local ready = LocalPlayer:GetAttribute("ready")
    -- not ready will invert value of ready
    ready = not ready
    -- send remote event
    remoteEvents.PlayerReadyChanged:FireServer({ Game = game, Ready = ready })
  end)

  if LocalPlayer:GetAttribute("ready") then
    readyButton.Select()
    readyButton.Text = "Yes, I am ready!"
  else
    readyButton.Unselect()
    readyButton.Text = "Ready?"
  end

  local STEP = 0.1

  local function updateCountDown(countDown)
    countDownLabel.Text = "Game will start in " .. countDown .. " seconds"
    if countDown == 0 then
      countDownLabel.Text = "Game is starting..."
    end
    if countDown < 0 then
      countDownLabel.Text = "Game will start when all players are ready"
    end
  end

  local function createGameOwnerIcon(Index)
    -- game Owner label
    local gameOwner = F.createTextLabel({
      Parent = myGameGui,
      Text = "👑",
      Size = UDim2.new(0.1, 0, 0.05, 0),
      Position = UDim2.new(0.45, 0, 0.075 + Index * STEP, 0),
      BackgroundTransparency = 1,
    })
  end

  local function isPlayerGameOwner(Player)
    return Player.UserId == game.Owner.UserId
  end

  local function createPlayerRow(Index, Color, Player)
    
    local name = F.createTextLabel({
      Parent = myGameGui,
      Text = "Waiting for player",
      Size = UDim2.new(0.6, 0, 0.075, 0),
      Position = UDim2.new(0.2, 0, 0.1 + Index * STEP, 0),
      BackgroundColor3 = Color,
      BackgroundTransparency = 0,
      TextColor3 = Color3.fromRGB(255, 255, 255),
    })
    local ready = F.createTextLabel({
      Parent = myGameGui,
      Text = "?",
      Size = UDim2.new(0.05, 0, 0.075, 0),
      Position = UDim2.new(0.1, 0, 0.1 + Index * STEP, 0),
    })
    local kick = F.createButton({
      Parent = myGameGui,
      Text = "X",
      Size = UDim2.new(0.05, 0, 0.075, 0),
      Position = UDim2.new(0.85, 0, 0.1 + Index * STEP, 0),
      BorderSizePixel = 0,
      LineHeight = 1.1,
    })
    if (Player) then
      name.Text = Player.DisplayName
      if (Player:GetAttribute("ready")) then
        ready.Text = "✅"
      else
        ready.Text = "?"
      end
      if (isPlayerGameOwner(Player)) then
        createGameOwnerIcon(Index)
      end
    end
  end

  

  -- for 1 vs 1
  if (game.GameMode == C.GAME_MODE.ONE) then
    
    createPlayerRow(1, Color3.fromRGB(255, 0, 0), game.Teams[C.GAME_TEAM.RED][1])
    createPlayerRow(4, Color3.fromRGB(0, 0, 255), game.Teams[C.GAME_TEAM.BLUE][1])
    
  end

  -- for 2 vs 2
  if (game.GameMode == C.GAME_MODE.TWO) then
    
    createPlayerRow(1, Color3.fromRGB(255, 0, 0), game.Teams[C.GAME_TEAM.RED][1])
    createPlayerRow(2, Color3.fromRGB(255, 0, 0), game.Teams[C.GAME_TEAM.RED][2])
    
    createPlayerRow(4, Color3.fromRGB(0, 0, 255), game.Teams[C.GAME_TEAM.BLUE][1])
    createPlayerRow(5, Color3.fromRGB(0, 0, 255), game.Teams[C.GAME_TEAM.BLUE][2])

  end
  
  if (game.ReadyToStart) then
    for i = 5, 0, -1 do
      updateCountDown(i)
      if (i == 0 and isPlayerGameOwner(LocalPlayer)) then
        -- teleport players to arena
        print("Owner is ready to teleport players")
        remoteFunctions.TeleportPlayersToArena:InvokeServer(game)
      end
      wait(1)
    end
  else
    updateCountDown(-1)
  end
end

local function checkAndRenderMyGameScreen(options)
  print("checkAndRenderMyGameScreen", options)
  if (F.isMyGame(options.Game)) then
    RenderMyGameGui(options.Game)
  end
end

-- REMOTE EVENTS
F.listenToRemoteEvents({ "PlayerJoinedGame", "PlayerLeftGame", "PlayerReadyChanged", "GameStarting" }, checkAndRenderMyGameScreen)

print("MyGameGui: Done")