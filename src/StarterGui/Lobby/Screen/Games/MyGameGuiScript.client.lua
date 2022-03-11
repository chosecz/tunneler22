repeat task.wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local screenGui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui')
local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')
local gameCreated = bindableEvents:WaitForChild('GameCreated')
local addedPlayerToGame = bindableEvents:WaitForChild('AddedPlayerToGame')

-- local gamesButtonPressed = bindableEvents:WaitForChild('GamesButtonPressed')
-- local gamesCloseButtonPressed = bindableEvents:WaitForChild('GamesCloseButtonPressed')

-- create button
print("MyGameGui: Creating")

function CreateMyGameGui()
  print("creating my game gui")
  local gamesGuiFrame = Instance.new("Frame")
  gamesGuiFrame.Name = "MyGameGui"
  gamesGuiFrame.BackgroundColor3 = C.COLOR.TURQUOISE
  gamesGuiFrame.BackgroundTransparency = 0.5
  gamesGuiFrame.Position = UDim2.new(0.8, 0, 0.3, 0)
  gamesGuiFrame.Size = UDim2.new(0.2, 0, 0.6, 0)
  gamesGuiFrame.Visible = true
  gamesGuiFrame.Parent = screenGui
  gamesGuiFrame:GetPropertyChangedSignal("Visible"):Connect(function()
    -- gamesGuiVisibilityChanged:Fire(gamesGuiFrame.Visible)
  end)

end

gameCreated.Event:Connect(CreateMyGameGui)
addedPlayerToGame.Event:Connect(CreateMyGameGui)

-- CreateMyGameGui()

print("MyGameGui: Done")
