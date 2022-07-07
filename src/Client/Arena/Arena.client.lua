repeat task.wait() until game.Players.LocalPlayer.Character

local remoteEvents = game.ReplicatedStorage:WaitForChild('RemoteEvents')
local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')

local players = game:GetService('Players')
local localPlayer = players.LocalPlayer

local ControlModule = require(localPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))

local function nextRound(options)
  print('nextRound', options.Game)

  if (not localPlayer:GetAttribute("playerIsDead")) then
    local spawnLocations = remoteFunctions.GetSpawnLocations:InvokeServer()
    local team = localPlayer.Team.Name;
    local spawnLocations = spawnLocations[team]
    local hrp = localPlayer.Character:WaitForChild("HumanoidRootPart")
    hrp.CFrame = spawnLocations[1].CFrame
  end

  -- disable controls
  ControlModule:Disable()
  wait(5)
  ControlModule:Enable()
end

local function endGame(options)
  print('endGame', options.Game)
end

remoteEvents.NextRound.OnClientEvent:Connect(nextRound)
remoteEvents.EndGame.OnClientEvent:Connect(endGame)

print('Arena Player started')

-- ClientService.Exec()