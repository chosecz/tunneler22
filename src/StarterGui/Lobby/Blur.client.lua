local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')

-- blur effect
local lighting = game.Lighting
local blur = Instance.new("BlurEffect")
blur.Enabled = false
blur.Parent = lighting

bindableEvents.GamesGuiVisibilityChanged.Event:Connect(function(enabled)
  blur.Enabled = enabled
end)