print("RespawnServerScript")

local players = game:GetService("Players")
local rep = game:GetService("ReplicatedStorage")
local remoteEvents = game.ReplicatedStorage:WaitForChild('RemoteEvents')

function loadPlayer(plr)
    plr:LoadCharacter()
end

remoteEvents.RespawnEvent.OnServerEvent:Connect(loadPlayer)