repeat task.wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local GF = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('GamesFunctions'))
local gamesGui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui'):WaitForChild('GamesGui')
local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')
local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')
local remoteEvents = game:GetService('ReplicatedStorage'):WaitForChild('RemoteEvents')

local publicGamesGui = Instance.new("Frame")
publicGamesGui.Name = "PublicGamesGui"
publicGamesGui.Parent = gamesGui
publicGamesGui.BackgroundTransparency = 1
publicGamesGui.Position = UDim2.new(0, 0, 0.15, 0)
publicGamesGui.Size = UDim2.new(1, 0, 0.85, 0)
publicGamesGui.Visible = true

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Parent = publicGamesGui
scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.BackgroundTransparency = 1

local function renderPublicGamesList(listOfPublicGames)
  print("renderPublicGamesList", listOfPublicGames)

  -- clear childrens from scrolling frame
  local list = scrollingFrame:GetChildren()
	for i, row in pairs(list) do
		row:Destroy()
	end

  local gamesCounter = 0
  for i, game in pairs(listOfPublicGames) do
    GF.createGameRow({
      Game = game,
      Parent = scrollingFrame,
      Index = gamesCounter,
    })
    gamesCounter += 1
  end

  if (gamesCounter == 0) then
    F.createTextLabel({
      Parent = scrollingFrame,
      Text = "No public games, go and create one!",
      Size = UDim2.new(0.5, 0, 0.05, 0),
      Position = UDim2.new(0.25, 0, 0, 0),
    })
  end
end

local function togglePublicGamesGui(visible)
  publicGamesGui.Visible = visible
end
local function show()
	publicGamesGui.Visible = true
end
local function hide()
	publicGamesGui.Visible = false
end
local function getListOfGames()
  return remoteFunctions.ListOfPublicGames:InvokeServer()
end
local function getAndRender()
  if (publicGamesGui.Visible) then
    renderPublicGamesList(getListOfGames())
  end
end

-- change visibility handler
publicGamesGui:GetPropertyChangedSignal("Visible"):Connect(getAndRender)

-- REMOTE EVENTS
F.listenToRemoteEvents({ "GameCreated", "PlayerJoinedGame", "PlayerLeftGame" }, getAndRender)

-- BINDABLE EVENTS
F.listenToBindableEvents({ "ShowPublicGamesGui" }, show)
F.listenToBindableEvents({ "ShowFriendGamesGui", "ShowCreateGameGui" }, hide)

-- fill on create
renderPublicGamesList(getListOfGames())
