repeat task.wait() until game.Players.LocalPlayer.Character

local remoteEvents = game.ReplicatedStorage:WaitForChild('RemoteEvents')
local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')

local players = game:GetService('Players')
local localPlayer = players.LocalPlayer

local function nextRound(options)
  print('nextRound', options.Game)
end

local function endGame(options)
  print('endGame', options.Game)
end

remoteEvents.NextRound.OnClientEvent:Connect(nextRound)
remoteEvents.EndGame.OnClientEvent:Connect(endGame)

print('Arena Player started')

-- ClientService.Exec()