local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')
local remoteEvents = game.ReplicatedStorage:WaitForChild('RemoteEvents')
local teams = game:GetService("Teams")
local players = game:GetService("Players")

local GamesService = {}

-- holt information about game
local Game = nil

-- just fake game data for development
local fakeGame = {
  Id = "GID_-1",
  GameType = C.GAME_TYPE.PUBLIC,
  GameMode = C.GAME_MODE.ONE,
  GameStatus = C.GAME_STATUS.WAITING,
  Teams = {[C.GAME_TEAM.RED] = {
      [1] = {
        UserId = "-1",
        Name = "Player 1",
      }
    }, [C.GAME_TEAM.BLUE] = {
      [1] = {
        UserId = "-2",
        Name = "Player 2",
      }
    }
  }
}

local function waitForAllPlayerInGameToBeConnected()
  print("waitForAllPlayerInGameToBeConnected")
  local players = game:GetService("Players")
  local allPlayersConnected = true
  if (not Game) then return false end
  for i, player in pairs(Game.Teams[C.GAME_TEAM.RED]) do
    if (not players:FindFirstChild(player.UserId)) then
      allPlayersConnected = false
    end
  end
  for i, player in pairs(Game.Teams[C.GAME_TEAM.BLUE]) do
    if (not players:FindFirstChild(player.UserId)) then
      allPlayersConnected = false
    end
  end
  return allPlayersConnected
end

local function checkIfAllPlayersAreConnected()
  print("checkIfAllPlayersAreConnected")
  local MAX_WAIT_TIME = 30
  while (not waitForAllPlayerInGameToBeConnected()) do
    print("in while cycle")
    wait(1)
    MAX_WAIT_TIME = MAX_WAIT_TIME - 1
    if (MAX_WAIT_TIME == 0) then
      return false
    end
  end
  return true
end

local function init()
  print("init")
  if (checkIfAllPlayersAreConnected()) then
    print("all connected")
    -- run the game
  else
    print("timeout, some players did not connect to game")
    -- show error message and return to lobby
  end
end

local function onPlayerAdded(player)
  print("Player added: " .. player.Name)
  local joinData = player:GetJoinData()
  local teleportData = joinData.TeleportData

  if (not teleportData and not Game) then
    Game = fakeGame
  elseif (not Game) then
    Game = teleportData
  end
  
  if (Game) then
    print("game.Id", Game.Id)
    print("game.GameType", Game.GameType)
    print("game.GameMode", Game.GameMode)

    for i, team in pairs(Game.Teams) do
      print("i team", i, team)
      for j, player in pairs(team) do
        print("j player", j, player.UserId, player.Name)
      end
    end
  end
end

local function createTeams()
  print("creating teams")

  local redTeam = Instance.new("Team", teams)
  redTeam.TeamColor = BrickColor.new("Bright red")
  redTeam.AutoAssignable = false
  redTeam.Name = "Red Team"

  local blueTeam = Instance.new("Team", teams)
  blueTeam.TeamColor = BrickColor.new("Bright blue")
  blueTeam.AutoAssignable = false
  blueTeam.Name = "Blue Team"
end

function GamesService.Exec()
  print('GamesService.Exec')
  createTeams()
  init()
end

players.PlayerAdded:Connect(onPlayerAdded)

return GamesService
