local players = game:GetService("Players")
local rep = game:GetService("ReplicatedStorage")
local respawnevent = Instance.New("RemoteEvents")
respawnevent.Parent = rep.RemoteEvents
respawnevent.Name = "RespawnEvent"

-- players.CharacterAutoLoads = false

print("RespawnServerScript")

function loadplayer(plr)
    plr:LoadCharacter()
end

players.CharacterAdded:Connect(loadplayer)

loadplayer()

respawnevent.OnServerEvent:Connect(loadplayer)