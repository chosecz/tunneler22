repeat task.wait() until game.Players.LocalPlayer.Character

local FUNCTIONS = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local CONST = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local screenGui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui')
local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')
local gamesButtonPressed = bindableEvents:WaitForChild('GamesButtonPressed')
local gamesCloseButtonPressed = bindableEvents:WaitForChild('GamesCloseButtonPressed')
local createGameButtonPressed = bindableEvents:WaitForChild('CreateGameButtonPressed')
local publicGamesButtonPressed = bindableEvents:WaitForChild('PublicGamesButtonPressed')
local friendGamesButtonPressed = bindableEvents:WaitForChild('FriendGamesButtonPressed')
local gamesGuiVisibilityChanged = bindableEvents:WaitForChild('GamesGuiVisibilityChanged')
local gameCreated = bindableEvents:WaitForChild('GameCreated')
local addedPlayerToGame = bindableEvents:WaitForChild('AddedPlayerToGame')

-- party screen
print("GamesGui: Creating")
local gamesGuiFrame = Instance.new("Frame")
gamesGuiFrame.Name = "GamesGui"
gamesGuiFrame.BackgroundColor3 = CONST.COLOR.TURQUOISE
gamesGuiFrame.BackgroundTransparency = 0.5
gamesGuiFrame.Position = UDim2.new(0.1, 0, 0, 0)
gamesGuiFrame.Size = UDim2.new(0.8, 0, 0.9, 0)
gamesGuiFrame.Visible = false
gamesGuiFrame.Parent = screenGui
gamesGuiFrame:GetPropertyChangedSignal("Visible"):Connect(function()
  gamesGuiVisibilityChanged:Fire(gamesGuiFrame.Visible)
end)

local closeButton = FUNCTIONS.createButton({
  Text = "X",
  Parent = gamesGuiFrame,
  Size = UDim2.new(0.05, 0, 0.09, 0),
  Position = UDim2.new(0.95, 0, 0.01, 0),
  BackgroundTransparency = 1,
  TextColor3 = Color3.fromRGB(0, 0, 0),
  Activated = function()
    gamesCloseButtonPressed:Fire()
  end
})

local publicGamesButton = FUNCTIONS.createButton({
  Parent = gamesGuiFrame,
  Text = "Public Games",
  Size = UDim2.new(0.2, 0, 0.05, 0),
  Position = UDim2.new(0.1, 0, 0.05, 0),
  TextColor3 = Color3.fromRGB(255, 255, 255),
  Activated = function()
    publicGamesButtonPressed:Fire()
  end
})

local friendGamesButton = FUNCTIONS.createButton({
  Parent = gamesGuiFrame,
  Text = "Friend Games",
  Size = UDim2.new(0.2, 0, 0.05, 0),
  Position = UDim2.new(0.4, 0, 0.05, 0),
  TextColor3 = Color3.fromRGB(255, 255, 255),
  Activated = function()
    friendGamesButtonPressed:Fire()
  end
})
FUNCTIONS.makeButtonInactive(friendGamesButton)

local createGameButton = FUNCTIONS.createButton({
  Parent = gamesGuiFrame,
  Text = "Create Game",
  Size = UDim2.new(0.2, 0, 0.05, 0),
  Position = UDim2.new(0.7, 0, 0.05, 0),
  TextColor3 = Color3.fromRGB(255, 255, 255),
  Activated = function()
    createGameButtonPressed:Fire()
  end
})
FUNCTIONS.makeButtonInactive(createGameButton)

-- Shows party gui frame when user click on Games Button
gamesButtonPressed.Event:Connect(function()
  gamesGuiFrame.Visible = true
end)

-- Hides party gui when user clicks on Close Button
gamesCloseButtonPressed.Event:Connect(function()
  gamesGuiFrame.Visible = false
end)

createGameButtonPressed.Event:Connect(function()
  FUNCTIONS.makeButtonActive(createGameButton)
  FUNCTIONS.makeButtonInactive(publicGamesButton)
  FUNCTIONS.makeButtonInactive(friendGamesButton)
end)

publicGamesButtonPressed.Event:Connect(function()
  FUNCTIONS.makeButtonActive(publicGamesButton)
  FUNCTIONS.makeButtonInactive(createGameButton)
  FUNCTIONS.makeButtonInactive(friendGamesButton)
end)

friendGamesButtonPressed.Event:Connect(function()
  FUNCTIONS.makeButtonActive(friendGamesButton)
  FUNCTIONS.makeButtonInactive(createGameButton)
  FUNCTIONS.makeButtonInactive(publicGamesButton)
end)

function hideGamesGui()
  gamesGuiFrame.Visible = false
end

gameCreated.Event:Connect(hideGamesGui)
addedPlayerToGame.Event:Connect(hideGamesGui)

print("GamesGui: Done")
