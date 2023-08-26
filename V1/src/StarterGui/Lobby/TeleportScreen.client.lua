repeat task.wait() until game.Players.LocalPlayer.Character

local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Get remote event created by the teleport module
local teleportEvent = ReplicatedStorage:WaitForChild("TeleportEvent")

local teleportScreenGui = Instance.new("ScreenGui", playerGui)
teleportScreenGui.IgnoreGuiInset = true
teleportScreenGui.Enabled = false
teleportScreenGui.Name = "TeleportScreen"

local textLabel = Instance.new("TextLabel", teleportScreenGui)
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
textLabel.Font = Enum.Font.GothamSemibold
textLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
textLabel.Text = "Teleporting..."
textLabel.TextSize = 28

-- Set the teleport GUI in preparation for teleport
TeleportService:SetTeleportGui(teleportScreenGui)

teleportEvent.OnClientEvent:Connect(function(playersTable, enable)
	-- Enable or disable teleport GUI for valid players
	if table.find(playersTable, player) then
		teleportScreenGui.Enabled = enable
	end
end)

print("TeleportScreen ready")