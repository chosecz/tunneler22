repeat task.wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local LocalPlayer = game:GetService('Players').LocalPlayer
local screenGui = LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui')
local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')
local remoteEvents = game:GetService('ReplicatedStorage'):WaitForChild('RemoteEvents')

-- party screen
print("GamesGui: Creating")
local gamesGuiFrame = Instance.new("Frame")
gamesGuiFrame.Name = "GamesGui"
gamesGuiFrame.BackgroundColor3 = C.COLOR.LIGHT_BLACK
gamesGuiFrame.BackgroundTransparency = 0.5
gamesGuiFrame.Position = UDim2.new(0.1, 0, 0, 0)
gamesGuiFrame.Size = UDim2.new(0.8, 0, 0.9, 0)
gamesGuiFrame.Visible = false
gamesGuiFrame.Parent = screenGui
gamesGuiFrame:GetPropertyChangedSignal("Visible"):Connect(function()
  bindableEvents.GamesGuiVisibilityChanged:Fire(gamesGuiFrame.Visible)
end)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.01, 0)
UICorner.Parent = gamesGuiFrame

local function show()
  gamesGuiFrame.Visible = true
end

local function hide()
  gamesGuiFrame.Visible = false
end

local closeButton = F.createButton({
  Text = "X",
  Parent = gamesGuiFrame,
  Size = UDim2.new(0.05, 0, 0.09, 0),
  Position = UDim2.new(0.95, 0, 0.01, 0),
  BackgroundTransparency = 1,
  TextColor3 = Color3.fromRGB(0, 0, 0),
  Activated = function()
    bindableEvents.HideGamesGui:Fire()
  end
})

local publicGamesButton = F.createButton({
  Parent = gamesGuiFrame,
  Text = "Public Games",
  Size = UDim2.new(0.2, 0, 0.05, 0),
  Position = UDim2.new(0.1, 0, 0.05, 0),
  TextColor3 = Color3.fromRGB(255, 255, 255),
  Activated = function()
    bindableEvents.ShowPublicGamesGui:Fire()
  end,
  Selected = true,
})

local friendGamesButton = F.createButton({
  Parent = gamesGuiFrame,
  Text = "Friend Games",
  Size = UDim2.new(0.2, 0, 0.05, 0),
  Position = UDim2.new(0.4, 0, 0.05, 0),
  TextColor3 = Color3.fromRGB(255, 255, 255),
  Activated = function()
    bindableEvents.ShowFriendGamesGui:Fire()
  end,
})

local createGameButton = F.createButton({
  Parent = gamesGuiFrame,
  Text = "Create Game",
  Size = UDim2.new(0.2, 0, 0.05, 0),
  Position = UDim2.new(0.7, 0, 0.05, 0),
  TextColor3 = Color3.fromRGB(255, 255, 255),
  Activated = function()
    bindableEvents.ShowCreateGameGui:Fire()
  end,
})

-- Shows party gui frame when user click on Games Button
bindableEvents.ShowGamesGui.Event:Connect(show)

-- Hides party gui when user clicks on Close Button
bindableEvents.HideGamesGui.Event:Connect(hide)

-- buttons toggl
bindableEvents.ShowCreateGameGui.Event:Connect(function()
  createGameButton.Select()
  publicGamesButton.Unselect()
  friendGamesButton.Unselect()
end)

bindableEvents.ShowPublicGamesGui.Event:Connect(function()
  publicGamesButton.Select()
  createGameButton.Unselect()
  friendGamesButton.Unselect()
end)

bindableEvents.ShowFriendGamesGui.Event:Connect(function()
  friendGamesButton.Select()
  createGameButton.Unselect()
  publicGamesButton.Unselect()
end)

-- hide games when player created a game
bindableEvents.GameCreated.Event:Connect(hide)

-------------------
-- REMOTE EVENTS --
-------------------
-- game games when player connected to a game
remoteEvents.PlayerJoinedGame.OnClientEvent:Connect(function(options)
  if (F.isMyGame(options.Game)) then
    hide()
  end
end)

print("GamesGui: Done")
