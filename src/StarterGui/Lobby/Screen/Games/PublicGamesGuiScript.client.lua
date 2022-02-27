repeat task.wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local gameGui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui'):WaitForChild('GamesGui')
local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')
local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')
local createGameButtonPressed = bindableEvents:WaitForChild('CreateGameButtonPressed')
local publicGamesButtonPressed = bindableEvents:WaitForChild('PublicGamesButtonPressed')
local friendGamesButtonPressed = bindableEvents:WaitForChild('FriendGamesButtonPressed')
-- local GamesService = require(game.ServerScriptService:WaitForChild('Services'):WaitForChild('GamesService'))

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

local function generatePublicGamesList(listOfPublicGames)
  -- clear childrens from scrolling frame
  local list = scrollingFrame:GetChildren()
	for i, row in pairs(list) do
		row:Destroy()
	end

  local gamesCounter = 0
  for gameId, game in pairs(listOfPublicGames) do
    F.createGameRow({
      Parent = scrollingFrame,
      Name = game.Owner.DisplayName.."|"..game.GameMode,
      Index = gamesCounter,
    })
    gamesCounter += 1
  end
  print("gamesCounter", gamesCounter)
end

-- BINDABLE EVENTS
publicGamesButtonPressed.Event:Connect(function()
  generatePublicGamesList(remoteFunctions.ListOfPublicGames:InvokeServer())
  publicGamesGui.Visible = true
end)

friendGamesButtonPressed.Event:Connect(function()
  publicGamesGui.Visible = false
end)

createGameButtonPressed.Event:Connect(function()
  publicGamesGui.Visible = false
end)

-- generate list of games
generatePublicGamesList(remoteFunctions.ListOfPublicGames:InvokeServer())
