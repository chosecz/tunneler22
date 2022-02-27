repeat task.wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local gameGui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui'):WaitForChild('GamesGui')
local BindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')
local createGameButtonPressed = BindableEvents:WaitForChild('CreateGameButtonPressed')
local publicGamesButtonPressed = BindableEvents:WaitForChild('PublicGamesButtonPressed')
local friendGamesButtonPressed = BindableEvents:WaitForChild('FriendGamesButtonPressed')

local GamesService = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('GamesService'))
local listOfPublicGames = GamesService.GetListOfPublicGames()

local publicGamesGui = Instance.new("Frame")
publicGamesGui.Name = "PublicGamesGui"
publicGamesGui.Parent = gameGui
-- good for debuging
publicGamesGui.BackgroundColor3 = C.COLOR.DARK_SLATE_GRAY
publicGamesGui.BackgroundTransparency = 0.5
publicGamesGui.Position = UDim2.new(0, 0, 0.15, 0)
publicGamesGui.Size = UDim2.new(1, 0, 0.85, 0)
publicGamesGui.Visible = true

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Parent = publicGamesGui
scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)

local gamesCounter = 0
for gameId, game in pairs(listOfPublicGames) do
  print("gameId", gameId)
  print("game", game)

  local gameRowFrame = F.createGameRow({
    Parent = scrollingFrame,
    Name = game.gameType,
    Index = gamesCounter,
  })
  gamesCounter += 1
end

print("gamesCounter", gamesCounter)

-- BINDABLE EVENTS
publicGamesButtonPressed.Event:Connect(function()
  listOfPublicGames = GamesService.GetListOfPublicGames()
  print('listOfPublicGames', listOfPublicGames)
  publicGamesGui.Visible = true
end)

friendGamesButtonPressed.Event:Connect(function()
  publicGamesGui.Visible = false
end)

createGameButtonPressed.Event:Connect(function()
  publicGamesGui.Visible = false
end)

-- debug print
print(listOfPublicGames)