print("RespawnServerScript")

local players = game:GetService("Players")
local rep = game:GetService("ReplicatedStorage")
local remoteEvents = game.ReplicatedStorage:WaitForChild('RemoteEvents')

function loadPlayer(plr)
    plr:LoadCharacter()
end

players.CharacterAdded:Connect(loadPlayer)

-- kde a kdy se tohle vola?
remoteEvents.RespawnEvent.OnServerEvent:Connect(loadPlayer)