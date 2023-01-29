local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')
local remoteEvents = game.ReplicatedStorage:WaitForChild('RemoteEvents')
local serviceTeams = game:GetService("Teams")
local servicePlayers = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local basePlate = game:GetService("Workspace"):WaitForChild("Parts"):WaitForChild("Baseplate")
local Rep = game:GetService("ReplicatedStorage")
local debris = game:GetService("Debris")

local GeneratorService = require(game.ServerScriptService:WaitForChild('GeneratorExtra'))

local GamesService = {}

local MAX_WAIT_TIME = 30
local MAX_X = basePlate.Size.X
local MAX_Z = basePlate.Size.Z
local SAVE_BORDER = 50

local MaxX = (MAX_X / 2) - SAVE_BORDER
local MinX = -MaxX
local MaxZ = (MAX_Z / 2) - SAVE_BORDER
local MinZ = -MaxZ

-- holt information about game
local Game = nil
local Teams = nil
local spawnLocations = {[C.TEAM.RED] = {}, [C.TEAM.BLUE] = {}}

local fireSound = Instance.new("Sound", game.Workspace)
fireSound.RollOffMinDistance = 150
fireSound.RollOffMode = Enum.RollOffMode.Linear
fireSound.SoundId = "rbxassetid://10146043055"

-- just fake game data for development
local fakeGame = {
  Id = "GID_-1",
  GameType = C.GAME_TYPE.PUBLIC,
  GameMode = C.GAME_MODE.ONE,
  Status = C.GAME_STATUS.WAITING,
  Wins = {
    [C.TEAM.RED] = 0,
    [C.TEAM.BLUE] = 0
  },
  Teams = {[C.TEAM.RED] = {
      [1] = {
        UserId = -1,
        Name = "Fake Player 1",
      }
    }, [C.TEAM.BLUE] = {
      [1] = {
        UserId = -2,
        Name = "Fake Player 2",
      }
    }
  }
}

local function killPlayer(player)
  player.Character:FindFirstChild("Humanoid").Health = 0
end

local function setDefaltPlayerAttributes(player)
  player:SetAttribute("PlayerShooting", false)
  player:SetAttribute("playerIsDead", false)
  player:SetAttribute("InRefuelStation", true)
  player:SetAttribute("Shields", 100)
  player:SetAttribute("Energy", 100)
end

local function resetPlayer(player)
  setDefaltPlayerAttributes(player)
end

local function updateEnergy(player)
  -- print("updateEnergy", player)
  local energy = player:GetAttribute("Energy")
  local shields = player:GetAttribute("Shields")

  local inRefuelStation = player:GetAttribute("InRefuelStation")
  if (inRefuelStation and energy < 100) then
    energy = energy + 1
  elseif (not inRefuelStation and energy > 0) then
    energy = energy - 1
  end
  
  -- update player attrs
  player:SetAttribute("Energy", energy);

  -- kill player, if energy is 0
  if (energy == 0 or shields == 0) then
    killPlayer(player)
  end

  -- return value
  return { Energy = energy, Shields = shields }
end

local function getGame()
  if (not Game) then
    return nil
  end
  return Game
end

local function getGameStatus()
  if (not Game) then
    return nil
  end
  return Game.Status
end

local function getWins()
  return Game.Wins
end

local function getSpawnLocations()
  return spawnLocations
end

local function waitForAllPlayerInGameToBeConnected()
  if (not Game) then return false end
  local StartGame = false
  local playersInGame = servicePlayers:GetPlayers()
  local playersInGameCount = #playersInGame
  
  -- for GAME_MODE.ONE
  local maxPlayers = 2
  
  -- for GAME_MODE.TWO
  if (Game.GameMode == C.GAME_MODE.TWO) then maxPlayers = 4 end

  -- check max number of player
  if (playersInGameCount == maxPlayers) then
    StartGame = true
    Game.Status = C.GAME_STATUS.RUNNING
  end

  return StartGame
end

local function checkIfAllPlayersAreConnected()
  while (not waitForAllPlayerInGameToBeConnected()) do
    print("Waiting for all players to be connected")
    wait(1)
    MAX_WAIT_TIME = MAX_WAIT_TIME - 1
    if (MAX_WAIT_TIME == 0) then
      return false
    end
  end
  return true
end

local function onPlayerDied(character)
  print("onPlayerDied")
  local player = game.Players:GetPlayerFromCharacter(character)
  local team = player.Team.Name

  -- attr
  player:SetAttribute("playerIsDead", true)
  
  local opositeTeam = C.TEAM.BLUE
  if (team == C.TEAM.BLUE) then
    opositeTeam = C.TEAM.RED
  end

  if (Game.GameMode == C.GAME_MODE.ONE) then 
    Game.Wins[opositeTeam] = Game.Wins[opositeTeam] + 1
    if (Game.Wins[opositeTeam] == 2) then
      Game.Status = C.GAME_STATUS.FINISHED
      remoteEvents.EndGame:FireAllClients({Game = Game })
    else
      Game.Status = C.GAME_STATUS.NEXT_ROUND
      remoteEvents.NextRound:FireAllClients({Game = Game })
      wait(5)
      Game.Status = C.GAME_STATUS.RUNNING
    end
  end

  if (Game.GameMode == C.GAME_MODE.TWO) then
    -- neco
  end
end

local function onCharactedAdded(character)
  print("onCharactedAdded", character)
  
  local player = game.Players:GetPlayerFromCharacter(character)
  setDefaltPlayerAttributes(player)

  character:WaitForChild("Humanoid").Died:Connect(function()
    onPlayerDied(character)
  end)
end

local function onPlayerAdded(player)
  print("Player added: " .. player.Name)

  -- characted added
  player.CharacterAdded:Connect(onCharactedAdded)

  local joinData = player:GetJoinData()
  local teleportData = joinData.TeleportData

  -- handling fake data
  if (not teleportData and not Game) then
    Game = fakeGame
  elseif (not Game) then
    Game = teleportData
  end

  print("Game data from teleport: ", Game)
  print("Game data from teleport Teams: ", Game.Teams)
  print("Game data from teleport Wins: ", Game.Wins)
  
  if (Game) then
    for teamColor, playersInTeam in pairs(Game.Teams) do
      for j, p in pairs(playersInTeam) do
        if (p.UserId == player.UserId) then
          if (teamColor == C.TEAM.RED) then
            player.Team = Teams[C.TEAM.RED]
          elseif (teamColor == C.TEAM.BLUE) then
            player.Team = Teams[C.TEAM.BLUE]
          end
        end
      end
    end
  end
end

local function createTeams()
  print("creating teams")

  local redTeam = Instance.new("Team", serviceTeams)
  redTeam.TeamColor = BrickColor.new("Bright red")
  redTeam.AutoAssignable = false
  redTeam.Name = C.TEAM.RED

  local blueTeam = Instance.new("Team", serviceTeams)
  blueTeam.TeamColor = BrickColor.new("Bright blue")
  blueTeam.AutoAssignable = false
  blueTeam.Name = C.TEAM.BLUE

  -- create teams
  Teams = {
    [C.TEAM.RED] = redTeam,
    [C.TEAM.BLUE] = blueTeam
  }
end

local function generateRandomPositionInMap(teamColor)
  if (teamColor == C.TEAM.RED) then
    return Vector3.new(math.random(MinX, 0), 0, math.random(MinZ, MaxZ))
  else
    return Vector3.new(math.random(0, MaxX), 0, math.random(MinZ, MaxZ))
  end
end

local function createSpawns()
  print("creating spawn locations")

  local spawnFolder = Instance.new("Folder")
  spawnFolder.Name = "Spawns"
  spawnFolder.Parent = game.Workspace
  
  local spawnLocationsCountPerTeam = 2

  -- create spawn locations
  local spawnLocationRed = generateRandomPositionInMap(C.TEAM.RED)
  for i = 1, spawnLocationsCountPerTeam do
    local spawnLocation = Instance.new("SpawnLocation")
    spawnLocation.CanCollide = false
    spawnLocation.Neutral = false
    spawnLocation.Transparency = 1
    spawnLocation.Anchored = true
    spawnLocation.Parent = spawnFolder
    spawnLocation.Position = spawnLocationRed + Vector3.new(i * 5, 2, 0)
    spawnLocation.Size = Vector3.new(1, 1, 1)
    spawnLocation.Name = "Spawn Location RED " .. i
    spawnLocation.TeamColor = BrickColor.new("Bright red")
    spawnLocation:SetAttribute("Team", C.TEAM.RED)
    spawnLocations[C.TEAM.RED][i] = spawnLocation
  end

  local spawnLocationBlue = generateRandomPositionInMap(C.TEAM.BLUE)
  for i = 1, spawnLocationsCountPerTeam do
    local spawnLocation = Instance.new("SpawnLocation")
    spawnLocation.CanCollide = false
    spawnLocation.Neutral = false
    spawnLocation.Transparency = 1
    spawnLocation.Anchored = true
    spawnLocation.Parent = spawnFolder
    spawnLocation.Position = spawnLocationBlue + Vector3.new(i * 5, 2, 0)
    spawnLocation.Size = Vector3.new(1, 1, 1)
    spawnLocation.Name = "Spawn Location BLUE " .. i
    spawnLocation.TeamColor = BrickColor.new("Bright blue")
    spawnLocation:SetAttribute("Team", C.TEAM.BLUE)
    spawnLocations[C.TEAM.BLUE][i] = spawnLocation
  end

  print("spawnLocations", spawnLocations)

  local Base = Rep.Meshes.PlayerBase

  --Red Base
  local CopyBaseRed = Base:Clone()
  CopyBaseRed.Parent = spawnFolder
  CopyBaseRed:moveTo(spawnLocationRed)
  CopyBaseRed.Name = "BaseRed"
  CopyBaseRed.MainPart.Name = "MainPartRed"

  -- Blue Base
  local CopyBaseBlue = Base:Clone()
  CopyBaseBlue.Parent = spawnFolder
  CopyBaseBlue:moveTo(spawnLocationBlue)
  CopyBaseBlue.Name = "BaseBlue"
  CopyBaseBlue.MainPart.Name = "MainPartBlue"

  print("done creating spawn locations")
end

local function generateMap()
  print("generating map")

  local mapFolder = Instance.new("Folder")
  mapFolder.Name = "Map"
  mapFolder.Parent = game.Workspace

  -- create map
  local partSize = 5
  local part = Instance.new("Part")
  part.Material = "Slate"
  part.BrickColor = BrickColor.new("Brown")
  part.Size = Vector3.new(partSize, 8, partSize)
  part.Position = Vector3.new(0, 0, 0)
  part.CanCollide = false
  
  for x = MinX/partSize, MaxX/partSize do
    for z = MinZ/partSize, MaxZ/partSize do
      -- print("create part at " .. x, z)
      local newPart = part:Clone()
      newPart.Anchored = true
      newPart.Parent = mapFolder
      newPart.Position = Vector3.new(x * partSize, 4, z * partSize)  
      newPart.Touched:Connect(function(hit)
        newPart:Destroy()
      end)
    end
  end

  GeneratorService.Exec()

  print("done generating map")
end

local function colorTank(player)
  print("colorTank", player)

  local tank = player.Character:FindFirstChild("Tank")
  local tankParts = tank:GetChildren()

  for i, child in ipairs(tankParts) do
    if child.Name == "ColorPart" then
      child.BrickColor = player.TeamColor
    end
  end
end

local function inRefuelStation(player, inRefuelStation)
  player:SetAttribute("InRefuelStation", inRefuelStation)
end

local function fireBullet(player)
  player:SetAttribute("PlayerShooting", true)
  local shootingPart = player.Character:FindFirstChild("Tank"):FindFirstChild("ColorPart")
  local direction = player.Character.HumanoidRootPart.CFrame.lookVector
	local position = shootingPart.Position + (direction * 2)

  local ball = Instance.new("Part")
  ball.Shape = Enum.PartType.Ball
  ball.Size = Vector3.new(1, 1, 1)
  ball.Parent = workspace
  ball.Anchored = false
  ball.CFrame = CFrame.new(position + direction)
  ball.Velocity = direction * 500
  ball.Touched:Connect(function(hit)
    print("hit", hit.Name)
    if (hit.Parent.Parent:FindFirstChild("Humanoid")) then
      print("player hit")
      local hittedPlayer = game.Players:GetPlayerFromCharacter(hit.Parent.Parent:FindFirstChild("Humanoid").Parent)
      local shields = hittedPlayer:GetAttribute("Shields")
      shields = shields - 10
      if (shields < 0) then
        shields = 0
      end
      hittedPlayer:SetAttribute("Shields", shields)
    end

    if not (hit.Name == "MainPartRed" or hit.Name == "MainPartBlue") then
      ball:Destroy()
    end
  end)

  fireSound:Play()
  wait(0.5)
  player:SetAttribute("PlayerShooting", false)
end

local function PlayerWantsFire(player)
  print("PlayerWantsFire", player)

  local playerShooting = player:GetAttribute("PlayerShooting")
  if (not playerShooting) then
    fireBullet(player)
  end
end

function deletemap()
  local children = workspace:GetChildren()

  for i = 1, #children do
    local child = children[i]
    if (child.Name == "Map" or child.Name == "Spawns" or child.Name == "BatteriesFolder" or child.Name == "BadrockFolder") then
      child:Destroy()
    end
  end

end

function startNewGame()
  print("STARTNEWGAME")
  local children = workspace:GetChildren()

  for i = 1, #children do
    local child = children[i]
    if (child.Name == "Map" or child.Name == "Spawns") then
      child:Destroy()
    end
  end

  createSpawns()
  generateMap()

  Game.Wins = {
    [C.TEAM.RED] = 0,
    [C.TEAM.BLUE] = 0
  }
  Game.Status = C.GAME_STATUS.RUNNING
  remoteEvents.NextGame:FireAllClients({Game = Game })
end

local function registerListeners()
  remoteFunctions.GetGame.OnServerInvoke = getGame
  remoteFunctions.GetGameStatus.OnServerInvoke = getGameStatus
  remoteFunctions.GetWins.OnServerInvoke = getWins
  remoteFunctions.GetSpawnLocations.OnServerInvoke = getSpawnLocations
  remoteFunctions.ColorTank.OnServerInvoke = colorTank
  remoteFunctions.InRefuelStation.OnServerInvoke = inRefuelStation
  remoteFunctions.UpdateEnergy.OnServerInvoke = updateEnergy
  remoteFunctions.ResetPlayer.OnServerInvoke = resetPlayer
  remoteFunctions.StartNewGame.OnServerInvoke = startNewGame
  

  remoteEvents.PlayerWantsFire.OnServerEvent:Connect(PlayerWantsFire)
  servicePlayers.PlayerAdded:Connect(onPlayerAdded)
end

local function init()
  print("init")
  if (checkIfAllPlayersAreConnected()) then
    print("all connected")
    -- run the game
    remoteEvents.StartGame:FireAllClients({ Game = Game })
  else
    print("timeout, some players did not connect to game")
    -- show error message and return to lobby
  end
end


function GamesService.Exec()
  print('GamesService.Exec')
  createTeams()
  createSpawns()
  generateMap()
  registerListeners()
  init()
end


return GamesService
