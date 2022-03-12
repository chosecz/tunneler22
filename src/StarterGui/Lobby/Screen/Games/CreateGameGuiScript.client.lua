repeat task.wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local localPlayer = game:GetService('Players').LocalPlayer
local gamesGui = localPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui'):WaitForChild('GamesGui')
local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')
local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')

local createGameGui = Instance.new("Frame")
createGameGui.Name = "CreateGameGui"
createGameGui.Parent = gamesGui
createGameGui.BackgroundTransparency = 1
createGameGui.Position = UDim2.new(0, 0, 0.15, 0)
createGameGui.Size = UDim2.new(1, 0, 0.85, 0)
createGameGui.Visible = false

local gameType = nil
local gameMode = nil
local friendsOnlyButton = nil
local publicGameButton = nil
local button1vs1 = nil
local button2vs2 = nil

local function ChangeGameType(type)
  if (type == C.GAME_TYPE.PUBLIC) then
    publicGameButton.Select()
    friendsOnlyButton.Unselect()
  elseif (type == C.GAME_TYPE.FRIENDS) then
    publicGameButton.Unselect()
    friendsOnlyButton.Select()
  end
  gameType = type
end

local function ChangeGameMode(mode)
  if (mode == C.GAME_MODE.ONE) then
    button1vs1.Select()
    button2vs2.Unselect()
  elseif (mode == C.GAME_MODE.TWO) then
    button1vs1.Unselect()
    button2vs2.Select()
  end
  gameMode = mode
end

local chooseGameType = F.createTextLabel({
  Parent = createGameGui,
  Text = "Choose game type",
  Size = UDim2.new(0.3, 0, 0.1, 0),
  Position = UDim2.new(0.35, 0, 0.05, 0),
})

publicGameButton = F.createButton({
  Text = "Public Game",
  Position = UDim2.new(0.55, 0, 0.2, 0),
  Parent = createGameGui,
  Activated = function()
    ChangeGameType(C.GAME_TYPE.PUBLIC)
  end
})

friendsOnlyButton = F.createButton({
  Text = "Friends Only",
  Position = UDim2.new(0.25, 0, 0.2, 0),
  Parent = createGameGui,
  Activated = function()
    ChangeGameType(C.GAME_TYPE.FRIENDS)
  end
})

local chooseGameType = F.createTextLabel({
  Parent = createGameGui,
  Text = "Choose game mode",
  Size = UDim2.new(0.3, 0, 0.1, 0),
  Position = UDim2.new(0.35, 0, 0.35, 0),
})

button1vs1 = F.createButton({
  Text = "1 vs 1",
  Position = UDim2.new(0.55, 0, 0.5, 0),
  Parent = createGameGui,
  Activated = function()
    ChangeGameMode(C.GAME_MODE.ONE)
  end
})

button2vs2 = F.createButton({
  Text = "2 vs 2",
  Position = UDim2.new(0.25, 0, 0.5, 0),
  Parent = createGameGui,
  Activated = function()
    ChangeGameMode(C.GAME_MODE.TWO)
  end
})

-- preselect game type Public
ChangeGameType(C.GAME_TYPE.PUBLIC)

-- preselect game mode 1 VS 1
ChangeGameMode(C.GAME_MODE.ONE)

F.createButton({
  Text = "Continue",
  Position = UDim2.new(0.4, 0, 0.7, 0),
  Parent = createGameGui,
  Activated = function()
    local game = remoteFunctions.CreateGame:InvokeServer({
      GameType = gameType,
      GameMode = gameMode,
    })
    print("Game successfully created", game)

    -- fire bindable event
    bindableEvents.GameCreated:Fire(game)
  end
})

-- BINDABLE EVENTS
bindableEvents.PublicGamesButtonPressed.Event:Connect(function()
  createGameGui.Visible = false
end)

bindableEvents.FriendGamesButtonPressed.Event:Connect(function()
  createGameGui.Visible = false
end)

bindableEvents.CreateGameButtonPressed.Event:Connect(function()
  createGameGui.Visible = true
end)
