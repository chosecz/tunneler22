local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')

-- blur effect
local lighting = game.Lighting
local blur = Instance.new("BlurEffect")
blur.Enabled = false
blur.Parent = lighting

bindableEvents.ShowGamesGui.Event:Connect(function()
  blur.Enabled = true
end)

bindableEvents.HideGamesGui.Event:Connect(function()
  blur.Enabled = false
end)