repeat task.wait() until game.Players.LocalPlayer.Character

local remoteEvents = game.ReplicatedStorage:WaitForChild('RemoteEvents')
local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')

local players = game:GetService('Players')
local localPlayer = players.LocalPlayer

local ControlModule = require(localPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))

local function nextRound(options)
  print('nextRound', options.Game)
  -- disable controls
  ControlModule:Disable()
  wait(5)

  if (not localPlayer:GetAttribute("PlayerIsDead")) then
    local spawnLocations = remoteFunctions.GetSpawnLocations:InvokeServer()
    local team = localPlayer.Team.Name;
    local spawnLocations = spawnLocations[team]
    local hrp = localPlayer.Character:WaitForChild("HumanoidRootPart")
    hrp.CFrame = spawnLocations[1].CFrame

    -- reset player
    remoteFunctions.ResetPlayer:InvokeServer()
  end

  -- respawn players
  remoteEvents.RespawnEvent:FireServer();

  ControlModule:Enable()
end

local function endGame(options)
  print('endGame', options.Game)
  ControlModule:Disable()
end

local function nextGame()
  print('nextGame')

  ControlModule:Disable()
  
  local spawnLocations = remoteFunctions.GetSpawnLocations:InvokeServer()
  local team = localPlayer.Team.Name;
  local spawnLocations = spawnLocations[team]
  local hrp = localPlayer.Character:WaitForChild("HumanoidRootPart")
  hrp.CFrame = spawnLocations[1].CFrame

  -- reset player
  remoteFunctions.ResetPlayer:InvokeServer()

  -- enable controls again
  ControlModule:Enable()
end

remoteEvents.NextRound.OnClientEvent:Connect(nextRound)
remoteEvents.EndGame.OnClientEvent:Connect(endGame)
remoteEvents.NextGame.OnClientEvent:Connect(nextGame)

print('Arena Player started')

-- ClientService.Exec()