repeat task.wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local GF = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('GamesFunctions'))
local gamesGui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui'):WaitForChild('GamesGui')
local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')
local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')

local friendGamesGui = Instance.new("Frame")
friendGamesGui.Name = "FriendGamesGui"
friendGamesGui.Parent = gamesGui
friendGamesGui.BackgroundTransparency = 1
friendGamesGui.Position = UDim2.new(0, 0, 0.15, 0)
friendGamesGui.Size = UDim2.new(1, 0, 0.85, 0)
friendGamesGui.Visible = false

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Parent = friendGamesGui
scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.BackgroundTransparency = 1

local function renderFriendsGameList(listOfFriendGames)
  print("renderFriendsGameList", listOfFriendGames)

  -- clear childrens from scrolling frame
  local list = scrollingFrame:GetChildren()
  for i, row in pairs(list) do
    row:Destroy()
  end

  local gamesCounter = 0
  for i, game in pairs(listOfFriendGames) do
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
      Text = "No friend games, go and create one!",
      Size = UDim2.new(0.5, 0, 0.05, 0),
      Position = UDim2.new(0.25, 0, 0, 0),
    })
  end
end
local function getListOfGames()
  return remoteFunctions.ListOfFriendGames:InvokeServer()
end
local function show()
  friendGamesGui.Visible = true
end
local function hide()
  friendGamesGui.Visible = false
end
local function getAndRender()
  if (friendGamesGui.Visible) then
    renderFriendsGameList(getListOfGames())
  end
end

-- change visibility handler
friendGamesGui:GetPropertyChangedSignal("Visible"):Connect(getAndRender)

-- REMOTE EVENTS
F.listenToRemoteEvents({ "GameCreated", "PlayerJoinedGame", "PlayerLeftGame" }, getAndRender)

-- BINDABLE EVENTS
F.listenToBindableEvents({ "ShowFriendGamesGui" }, show)
F.listenToBindableEvents({ "ShowPublicGamesGui", "ShowCreateGameGui" }, hide)

-- init
renderFriendsGameList(getListOfGames())