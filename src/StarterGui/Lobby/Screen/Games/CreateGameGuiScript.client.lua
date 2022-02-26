repeat wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local Players = game:GetService('Players')
local gameGui = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):WaitForChild("GamesGui")

local createGameGui = Instance.new("Frame")
createGameGui.Name = "CreateGameGui"
createGameGui.Parent = gameGui
createGameGui.BackgroundColor3 = C.COLOR.DARK_SLATE_GRAY
createGameGui.BackgroundTransparency = 0.5
createGameGui.Position = UDim2.new(0, 0, 0.15, 0)
createGameGui.Size = UDim2.new(1, 0, 0.85, 0)

local gameType = nil
local gameMode = nil
local friendsOnlyButton = nil
local publicGameButton = nil
local button1vs1 = nil
local button2vs2 = nil

local function ChangeGameType(type)
  if (type == C.GAME_TYPE.PUBLIC) then
    F.makeButtonActive(publicGameButton);
    F.makeButtonInactive(friendsOnlyButton);
  elseif (type == C.GAME_TYPE.FRIENDS) then
    F.makeButtonInactive(publicGameButton);
    F.makeButtonActive(friendsOnlyButton);
  end
  gameType = type
end

local function ChangeGameMode(mode)
  if (mode == C.GAME_MODE.ONE) then
    F.makeButtonActive(button1vs1);
    F.makeButtonInactive(button2vs2);
  elseif (mode == C.GAME_MODE.TWO) then
    F.makeButtonInactive(button1vs1);
    F.makeButtonActive(button2vs2);
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

-- preselect game type Public
ChangeGameType(C.GAME_TYPE.PUBLIC)

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

-- preselect game mode 1 VS 1
ChangeGameMode(C.GAME_MODE.ONE)

local continueButton = F.createButton({
  Text = "Continue",
  Position = UDim2.new(0.4, 0, 0.7, 0),
  Parent = createGameGui,
  Activated = function()
    print('continueButtonPressed', gameType, gameMode)
  end
})