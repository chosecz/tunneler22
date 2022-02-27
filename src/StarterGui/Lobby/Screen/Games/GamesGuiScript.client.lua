repeat task.wait() until game.Players.LocalPlayer.Character

local FUNCTIONS = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local CONST = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local screenGui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui')
local BindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')
local gamesButtonPressed = BindableEvents:WaitForChild('GamesButtonPressed')
local gamesGuiFrameClosed = BindableEvents:WaitForChild('GamesGuiFrameClosed')
local createGameButtonPressed = BindableEvents:WaitForChild('CreateGameButtonPressed')
local publicGamesButtonPressed = BindableEvents:WaitForChild('PublicGamesButtonPressed')

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

local closeButton = FUNCTIONS.createButton({
  Text = "X",
  Parent = gamesGuiFrame,
  Size = UDim2.new(0.05, 0, 0.09, 0),
  Position = UDim2.new(0.95, 0, 0.01, 0),
  BackgroundTransparency = 1,
  TextColor3 = Color3.fromRGB(0, 0, 0),
  Activated = function()
    gamesGuiFrameClosed:Fire()
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
    -- fire bindable event
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
gamesGuiFrameClosed.Event:Connect(function()
  gamesGuiFrame.Visible = false
end)

createGameButtonPressed.Event:Connect(function()
  FUNCTIONS.makeButtonActive(createGameButton)
  FUNCTIONS.makeButtonInactive(publicGamesButton)
end)

publicGamesButtonPressed.Event:Connect(function()
  FUNCTIONS.makeButtonActive(publicGamesButton)
  FUNCTIONS.makeButtonInactive(createGameButton)
end)

print("GamesGui: Done")
