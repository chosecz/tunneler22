local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')
local remoteEvents = game.ReplicatedStorage:WaitForChild('RemoteEvents')
local TM = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('TeleportModule'))
local AS = game:GetService("AssetService")
local arenaPlaceId = 9375479344

local GamesService = {}

-- holds list of all games
local games = {}

local function generateGameId(userId)
  return "GID_" .. userId .. "_" .. math.random(0, 999)
end

local function ListOfPublicGames()
  -- filter only public games
  local publicGames = {}
  for i, game in pairs(games) do
    if (game.GameType == C.GAME_TYPE.PUBLIC) then
      table.insert(publicGames, game)
    end
  end
  return publicGames
end

local function ListOfFriendGames()
  -- filter only games where owner is friend
  local friendGames = {}
  for i, game in pairs(games) do
    if (game.GameType == C.GAME_TYPE.FRIENDS) then
      table.insert(friendGames, game)
    end
  end
  return friendGames
end

local function updateGameStatus(game)
  local redPlayers = game.Teams[C.TEAM.RED]
  local bluePlayers = game.Teams[C.TEAM.BLUE]
  local numberOfPlayers = #redPlayers + #bluePlayers
  local allPlayers = {table.unpack(redPlayers), table.unpack(bluePlayers)}
  local allPlayersReady = false

  -- for GAME_MODE.ONE
  local maxPlayers = 2

  -- for GAME_MODE.TWO
  if (game.GameMode == C.GAME_MODE.TWO) then maxPlayers = 4 end

  -- check max number of player
  if (numberOfPlayers < maxPlayers) then
    game.Full = false
  else
    game.Full = true
  end

  -- everyboody left, so we can delete game
  if (numberOfPlayers == 0) then
    print("Deleting game")
    games[game.Id] = nil
  elseif (not game.Owner) then
    print("Setting new owner", allPlayers)
    -- set new owner of game
    for i, p in pairs(allPlayers) do
      if (p) then
        game.Owner = p.UserId
        break
      end
    end
  end

  if (game.Full) then
    for i, p in pairs(allPlayers) do
      if (p.Player:GetAttribute("ready")) then
        allPlayersReady = true
      else
        allPlayersReady = false
        break
      end
    end
  end

  if (allPlayersReady) then
    print("All players ready")
    game.ReadyToStart = true
  else
    print("Not all players ready")
    game.ReadyToStart = false
  end

  print("Server: updateGameStatus", game)
  return game
end

local function resolveTeamForPlayer(game)
  local gameMode = game.GameMode
  local redPlayers = game.Teams[C.TEAM.RED]
  local team = nil
  -- 1vs1
  if (gameMode == C.GAME_MODE.ONE) then
    -- 1vs1
    if (#redPlayers < 1) then
      team = C.TEAM.RED
    else
      team = C.TEAM.BLUE
    end
  end

  -- 2vs2
  if (gameMode == C.GAME_MODE.TWO) then
    if (#redPlayers < 2) then
      team = C.TEAM.RED
    else
      team = C.TEAM.BLUE
    end
  end
  return team
end

local function JoinGame(player, gameId)
  print("Server: JoinGame", player, gameId)
  local game = games[gameId]
  local team = resolveTeamForPlayer(game)

  -- add player to list
  table.insert(game.Teams[team], { UserId = player.UserId, Name = player.DisplayName, Player = player })

  -- update status of game
  game = updateGameStatus(game)

  -- set gameId for player
  player:SetAttribute("gameId", gameId)
  player:SetAttribute("team", team)
  player:SetAttribute("ready", false)

  print("Server: PlayerJoinedGame:", game, player)
  remoteEvents.PlayerJoinedGame:FireAllClients({Game = game, Player = player})
  return gameId
end

local function LeaveGame(player, gameId)
  print("Server: LeaveGame", player, gameId)
  local game = games[gameId]

  local team = player:GetAttribute("team")
  local playersInTeam = game.Teams[team];

  for i, p in pairs(playersInTeam) do
    if (p.UserId == player.UserId) then
      -- if leaving player is owner, set new owner
      if (p.UserId == game.Owner) then game.Owner = nil end
      table.remove(playersInTeam, i)
    end
  end

  player:SetAttribute("gameId", nil)
  player:SetAttribute("team", nil)
  player:SetAttribute("ready", nil)

  -- update status of game
  game = updateGameStatus(game)

  remoteEvents.PlayerLeftGame:FireAllClients({Game = game, Player = player})

  return true
end

local function CreateGame(player, options)
  print("Server: CreateGame", options)
  local gameId = generateGameId(player.UserId);
  local game = {
    Id = gameId,
    GameType = options.GameType,
    GameMode = options.GameMode,
    Status = C.GAME_STATUS.WAITING,
    Wins = {
      [C.TEAM.RED] = 0,
      [C.TEAM.BLUE] = 0
    },
    Owner = player.UserId,
    Full = false,
    ReadyToStart = false,
    Teams = {[C.TEAM.RED] = {}, [C.TEAM.BLUE] = {}}
  }

  -- add to game list
  games[gameId] = game

  -- add player to game
  JoinGame(player, gameId)

  print("Server: Game created", gameId)

  -- notify all clients, that new game was created
  remoteEvents.GameCreated:FireAllClients({Game = game, Player = player})
  return game
end

local function PlayerReadyChanged(player, options)
  print("on server", player)

  -- update player attrs
  player:SetAttribute("ready", options.Ready)

  -- update status of game
  local game = options.Game
  game = updateGameStatus(game)

  remoteEvents.PlayerReadyChanged:FireAllClients(options)
  print("firing on clients", options)
end

local function TeleportPlayersToArena(player, game)
  print("Server: TeleportPlayersToArena", player, game)

  local redPlayers = game.Teams[C.TEAM.RED]
  local bluePlayers = game.Teams[C.TEAM.BLUE]
  local allPlayers = {table.unpack(redPlayers), table.unpack(bluePlayers)}
  print("allPlayers", allPlayers)

  -- create list of players for teleport
  local listOfPlayers = {}
  for i, p in pairs(allPlayers) do
    if (p) then
      table.insert(listOfPlayers, p.Player)
    end
  end
  
  -- create arena
  local NewPlaceId = AS:CreatePlaceAsync("Arena", arenaPlaceId)
  print("NewPlaceId", NewPlaceId)

  -- set game data to teleport options
  local teleportOptions = Instance.new("TeleportOptions")
  teleportOptions:SetTeleportData(game)

  -- teleport players
  local teleportResult = TM.teleportWithRetry(NewPlaceId, listOfPlayers, teleportOptions)

  print("teleport done")

end

local function GetGame(player, gameId) return games[gameId] end

local function KickPlayer(player, gameId, playerId)
  print("Server: KickPlayer", player, gameId, playerId)
  local game = games[gameId]
  local playerToKick = nil
  for i, p in pairs(game.Teams[C.TEAM.RED]) do
    if (p.UserId == playerId) then
      playerToKick = p.Player
      break
    end
  end
  for i, p in pairs(game.Teams[C.TEAM.BLUE]) do
    if (p.UserId == playerId) then
      playerToKick = p.Player
      break
    end
  end
  if (playerToKick) then
    LeaveGame(playerToKick, gameId)
  end
end

local Players = game:GetService("Players")
Players.PlayerRemoving:Connect(function(player)
  if (player:GetAttribute("gameId")) then
    LeaveGame(player, player:GetAttribute("gameId"))
  end
  print(player.Name .. " left the game!")
end)

function GamesService.Exec()
  print('GamesService.Exec')
  remoteFunctions.CreateGame.OnServerInvoke = CreateGame
  remoteFunctions.JoinGame.OnServerInvoke = JoinGame
  remoteFunctions.LeaveGame.OnServerInvoke = LeaveGame
  remoteFunctions.ListOfPublicGames.OnServerInvoke = ListOfPublicGames
  remoteFunctions.ListOfFriendGames.OnServerInvoke = ListOfFriendGames
  remoteFunctions.GetGame.OnServerInvoke = GetGame
  remoteFunctions.TeleportPlayersToArena.OnServerInvoke = TeleportPlayersToArena
  remoteFunctions.KickPlayer.OnServerInvoke = KickPlayer

  remoteEvents.PlayerReadyChanged.OnServerEvent:Connect(PlayerReadyChanged)
end

return GamesService
