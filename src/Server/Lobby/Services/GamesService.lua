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
  -- TODO: filter only public games
  return games
end

local function combine(a1, a2)
  local new = table.create(#a1 + #a2)
  table.move(a1, 1, #a1, 1, new)
  table.move(a2, 1, #a2, 1, new)
  return new
end

local function updateGameStatus(game)
  local redPlayers = game.Teams[C.GAME_TEAM.RED]
  local bluePlayers = game.Teams[C.GAME_TEAM.BLUE]
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
        game.Owner = p
        break
      end
    end
  end

  if (game.Full) then
    for i, p in pairs(allPlayers) do
      if (p:GetAttribute("ready")) then
        allPlayersReady = true
      else
        allPlayersReady = false
        break
      end
    end
  end

  if (allPlayersReady) then
    -- remoteEvents.GameStarting:FireAllClients({ Game = game, ReadyToStart = true })
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
  local redPlayers = game.Teams[C.GAME_TEAM.RED]
  local team = nil
  -- 1vs1
  if (gameMode == C.GAME_MODE.ONE) then
    -- 1vs1
    if (#redPlayers < 1) then
      team = C.GAME_TEAM.RED
    else
      team = C.GAME_TEAM.BLUE
    end
  end

  -- 2vs2
  if (gameMode == C.GAME_MODE.TWO) then
    if (#redPlayers < 2) then
      team = C.GAME_TEAM.RED
    else
      team = C.GAME_TEAM.BLUE
    end
  end
  return team
end

local function JoinGame(player, gameId)
  print("Server: JoinGame", player, gameId)
  local game = games[gameId]
  local team = resolveTeamForPlayer(game)

  -- add player to list
  table.insert(game.Teams[team], player)

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
      if (p.UserId == game.Owner.UserId) then game.Owner = nil end
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
    Owner = player,
    Full = false,
    ReadyToStart = false,
    Teams = {[C.GAME_TEAM.RED] = {}, [C.GAME_TEAM.BLUE] = {}}
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

  local redPlayers = game.Teams[C.GAME_TEAM.RED]
  local bluePlayers = game.Teams[C.GAME_TEAM.BLUE]
  local allPlayers = {table.unpack(redPlayers), table.unpack(bluePlayers)}
  print("allPlayers", allPlayers)
  
  -- create arena
  local NewPlaceId = AS:CreatePlaceAsync("Arena", arenaPlaceId)
  print("NewPlaceId", NewPlaceId)

  -- teleport players
  local teleportResult = TM.teleportWithRetry(NewPlaceId, allPlayers)

  print("teleport done")

end

local function GetGame(player, gameId) return games[gameId] end

function GamesService.Exec()
  print('GamesService.Exec')
  remoteFunctions.CreateGame.OnServerInvoke = CreateGame
  remoteFunctions.JoinGame.OnServerInvoke = JoinGame
  remoteFunctions.LeaveGame.OnServerInvoke = LeaveGame
  remoteFunctions.ListOfPublicGames.OnServerInvoke = ListOfPublicGames
  remoteFunctions.GetGame.OnServerInvoke = GetGame
  remoteFunctions.TeleportPlayersToArena.OnServerInvoke = TeleportPlayersToArena

  remoteEvents.PlayerReadyChanged.OnServerEvent:Connect(PlayerReadyChanged)
end

return GamesService
