local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')
local gamesGuiVisibilityChanged = bindableEvents:WaitForChild('GamesGuiVisibilityChanged')

-- blur effect
local lighting = game.Lighting
local blur = Instance.new("BlurEffect")
blur.Enabled = false
blur.Parent = lighting

gamesGuiVisibilityChanged.Event:Connect(function(enabled)
  blur.Enabled = enabled
end)