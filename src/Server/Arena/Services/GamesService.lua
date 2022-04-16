local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')
local remoteEvents = game.ReplicatedStorage:WaitForChild('RemoteEvents')
local serviceTeams = game:GetService("Teams")
local servicePlayers = game:GetService("Players")
local basePlate = game:GetService("Workspace"):WaitForChild("Parts"):WaitForChild("Baseplate")

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

-- just fake game data for development
local fakeGame = {
  Id = "GID_-1",
  GameType = C.GAME_TYPE.PUBLIC,
  GameMode = C.GAME_MODE.ONE,
  GameStatus = C.GAME_STATUS.WAITING,
  Teams = {[C.GAME_TEAM.RED] = {
      [1] = {
        UserId = -1,
        Name = "Player 1",
      }
    }, [C.GAME_TEAM.BLUE] = {
      [1] = {
        UserId = -2,
        Name = "Player 2",
      }
    }
  }
}

local function waitForAllPlayerInGameToBeConnected()
  if (not Game) then return false end
  local allPlayersConnected = false
  local playersInGame = servicePlayers:GetPlayers()
  local playersInGameCount = #playersInGame
  
  -- for GAME_MODE.ONE
  local maxPlayers = 2
  
  -- for GAME_MODE.TWO
  if (Game.GameMode == C.GAME_MODE.TWO) then maxPlayers = 4 end

  -- check max number of player
  if (playersInGameCount == maxPlayers) then
    allPlayersConnected = true
  end

  return allPlayersConnected
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

local function onPlayerAdded(player)
  print("Player added: " .. player.Name)
  local joinData = player:GetJoinData()
  local teleportData = joinData.TeleportData

  -- handling fake data
  if (not teleportData and not Game) then
    Game = fakeGame
  elseif (not Game) then
    Game = teleportData
  end
  
  if (Game) then
    for teamColor, playersInTeam in pairs(Game.Teams) do
      for j, p in pairs(playersInTeam) do
        if (p.UserId == player.UserId) then
          if (teamColor == C.GAME_TEAM.RED) then
            player.Team = Teams[C.GAME_TEAM.RED]
          elseif (teamColor == C.GAME_TEAM.BLUE) then
            player.Team = Teams[C.GAME_TEAM.BLUE]
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
  redTeam.Name = "Red Team"

  local blueTeam = Instance.new("Team", serviceTeams)
  blueTeam.TeamColor = BrickColor.new("Bright blue")
  blueTeam.AutoAssignable = false
  redTeam.Name = "Blue Team"

  -- create teams
  Teams = {
    [C.GAME_TEAM.RED] = redTeam,
    [C.GAME_TEAM.BLUE] = blueTeam
  }
end

local function generateRandomSpawnLocation(teamColor)
  if (teamColor == C.GAME_TEAM.RED) then
    return Vector3.new(math.random(MinX, 0), 0, math.random(MinZ, MaxZ))
  else
    return Vector3.new(math.random(0, MaxX), 0, math.random(MinZ, MaxZ))
  end
end

local function createSpawnLocations()
  print("creating spawn locations")
  local spawnLocations = {}
  local spawnLocationsCount = 0
  local spawnLocationsCountPerTeam = 1

  while (not Game) do
    print("Waiting for game data...")
    wait(1)
  end

  -- create spawn locations for each team
  if (Game.GameMode == C.GAME_MODE.TWO) then
    spawnLocationsCountPerTeam = 2
  end

  -- create spawn locations
  local spawnLocationRed = generateRandomSpawnLocation(C.GAME_TEAM.RED)
  for i = 1, spawnLocationsCountPerTeam do
    local spawnLocation = Instance.new("SpawnLocation")
    spawnLocation.Neutral = false
    spawnLocation.Anchored = true
    spawnLocation.Parent = workspace
    spawnLocation.Position = spawnLocationRed + Vector3.new(i * 5, 0, 0)
    spawnLocation.Size = Vector3.new(1, 1, 1)
    spawnLocation.Name = "Spawn Location RED " .. i
    spawnLocation.TeamColor = BrickColor.new("Bright red")
    spawnLocations[i] = spawnLocation
    spawnLocationsCount = spawnLocationsCount + 1
  end

  local spawnLocationBlue = generateRandomSpawnLocation(C.GAME_TEAM.BLUE)
  for i = 1, spawnLocationsCountPerTeam do
    local spawnLocation = Instance.new("SpawnLocation")
    spawnLocation.Neutral = false
    spawnLocation.Anchored = true
    spawnLocation.Parent = workspace
    spawnLocation.Position = spawnLocationBlue + Vector3.new(i * 5, 0, 0)
    spawnLocation.Size = Vector3.new(1, 1, 1)
    spawnLocation.Name = "Spawn Location BLUE " .. i
    spawnLocation.TeamColor = BrickColor.new("Bright blue")
    spawnLocations[i + spawnLocationsCountPerTeam] = spawnLocation
  end

  print("done creating spawn locations")
  return spawnLocations
end

local function generateMap()
  print("generating map")

  -- create map
  local part = Instance.new("Part")
  part.Parent = workspace.Parts
  part.Anchored = true
  part.Size = Vector3.new(10, 8, 10)
  part.Position = Vector3.new(0, 1, 0)

  for x = MinX/10, MaxX/10 do
    for z = MinZ/10, MaxZ/10 do
      -- print("create part at " .. x, z)
      local newPart = part:Clone()
      newPart.Anchored = true
      newPart.Parent = workspace.Parts
      newPart.Position = Vector3.new(x * 10, 1, z * 10)  
    end
  end
end

local function init()
  print("init")
  if (checkIfAllPlayersAreConnected()) then
    print("all connected")
    -- run the game
    remoteEvents.AllPlayersConnected:FireAllClients({ Game = Game })
  else
    print("timeout, some players did not connect to game")
    -- show error message and return to lobby
  end
end

function GamesService.Exec()
  print('GamesService.Exec')
  createTeams()
  createSpawnLocations()
  generateMap()
  init()
end

servicePlayers.PlayerAdded:Connect(onPlayerAdded)

return GamesService
