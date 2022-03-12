repeat task.wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local screenGui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui')
local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')

-- party screen
print("GamesGui: Creating")
local gamesGuiFrame = Instance.new("Frame")
gamesGuiFrame.Name = "GamesGui"
gamesGuiFrame.BackgroundColor3 = C.COLOR.TURQUOISE
gamesGuiFrame.BackgroundTransparency = 0.5
gamesGuiFrame.Position = UDim2.new(0.1, 0, 0, 0)
gamesGuiFrame.Size = UDim2.new(0.8, 0, 0.9, 0)
gamesGuiFrame.Visible = false
gamesGuiFrame.Parent = screenGui
gamesGuiFrame:GetPropertyChangedSignal("Visible"):Connect(function()
  bindableEvents.GamesGuiVisibilityChanged:Fire(gamesGuiFrame.Visible)
end)

local function hideGamesGui()
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
    bindableEvents.GamesCloseButtonPressed:Fire()
  end
})

local publicGamesButton = F.createButton({
  Parent = gamesGuiFrame,
  Text = "Public Games",
  Size = UDim2.new(0.2, 0, 0.05, 0),
  Position = UDim2.new(0.1, 0, 0.05, 0),
  TextColor3 = Color3.fromRGB(255, 255, 255),
  Activated = function()
    bindableEvents.PublicGamesButtonPressed:Fire()
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
    bindableEvents.FriendGamesButtonPressed:Fire()
  end,
})

local createGameButton = F.createButton({
  Parent = gamesGuiFrame,
  Text = "Create Game",
  Size = UDim2.new(0.2, 0, 0.05, 0),
  Position = UDim2.new(0.7, 0, 0.05, 0),
  TextColor3 = Color3.fromRGB(255, 255, 255),
  Activated = function()
    bindableEvents.CreateGameButtonPressed:Fire()
  end,
})

-- Shows party gui frame when user click on Games Button
bindableEvents.GamesButtonPressed.Event:Connect(function()
  gamesGuiFrame.Visible = true
end)

-- Hides party gui when user clicks on Close Button
bindableEvents.GamesCloseButtonPressed.Event:Connect(function()
  gamesGuiFrame.Visible = false
end)

bindableEvents.CreateGameButtonPressed.Event:Connect(function()
  createGameButton.Select()
  publicGamesButton.Unselect()
  friendGamesButton.Unselect()
end)

bindableEvents.PublicGamesButtonPressed.Event:Connect(function()
  publicGamesButton.Select()
  createGameButton.Unselect()
  friendGamesButton.Unselect()
end)

bindableEvents.FriendGamesButtonPressed.Event:Connect(function()
  friendGamesButton.Select()
  createGameButton.Unselect()
  publicGamesButton.Unselect()
end)

bindableEvents.GameCreated.Event:Connect(hideGamesGui)
bindableEvents.AddedPlayerToGame.Event:Connect(hideGamesGui)

print("GamesGui: Done")
