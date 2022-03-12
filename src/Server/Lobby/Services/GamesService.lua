local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')
local remoteEvents = game:GetService('ReplicatedStorage'):WaitForChild('RemoteEvents')
local GamesService = {}

-- holds list of all games
local games = {}

local function generateGameId(userId)
   return "GID_"..userId.."_"..math.random(0,999)
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
   local allPlayers = {table.unpack(redPlayers),table.unpack(bluePlayers)}

   -- for GAME_MODE.ONE
   local maxPlayers = 2

   -- for GAME_MODE.TWO
   if (game.GameMode == C.GAME_MODE.TWO) then
      maxPlayers = 4
   end

   -- check max number of player
   if (numberOfPlayers < maxPlayers) then
      game.Full = false
   else
      game.Full = true
   end

   -- everyboody left, so we can delete game
   if (numberOfPlayers == 0) then
      games[game.Id] = nil
   else
      -- we owner is fist player in list
      game.Owner = allPlayers[1]
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
   remoteEvents.PlayerJoinedGame:FireAllClients({ Game = game, Player = player })
   return gameId
end

local function LeaveGame(player, gameId)
   print("Server: LeaveGame", player, gameId)
   local game = games[gameId]

   local team = player:GetAttribute("team")
   local playersInTeam = game.Teams[team];

   for i, p in pairs(playersInTeam) do
		if (p.UserId == player.UserId) then
         table.remove(playersInTeam, i)
      end
	end

   player:SetAttribute("gameId", nil)
   player:SetAttribute("team", nil)
   player:SetAttribute("ready", nil)

   -- update status of game
   game = updateGameStatus(game)

   remoteEvents.PlayerLeftGame:FireAllClients({ Game = game, Player = player })

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
      Teams = {
         [C.GAME_TEAM.RED] = {},
         [C.GAME_TEAM.BLUE] = {},
      },
   }

   -- add to game list
   games[gameId] = game

   -- add player to game
   JoinGame(player, gameId)

   print("Server: Game created", gameId)

   -- notify all clients, that new game was created
   remoteEvents.GameCreated:FireAllClients({ Game = game, Player = player })
   return game
end

local function GetGame(player, gameId)
   return games[gameId]
end;

function GamesService.Exec()
   print('GamesService.Exec')
   remoteFunctions.CreateGame.OnServerInvoke = CreateGame
   remoteFunctions.JoinGame.OnServerInvoke = JoinGame
   remoteFunctions.LeaveGame.OnServerInvoke = LeaveGame
   remoteFunctions.ListOfPublicGames.OnServerInvoke = ListOfPublicGames
   remoteFunctions.GetGame.OnServerInvoke = GetGame

   remoteEvents.PlayerReadyChanged.OnServerEvent:Connect(function(player, options)
      print("on server", player)
      
      -- update player attrs
      player:SetAttribute("ready", options.Ready)

      remoteEvents.PlayerReadyChanged:FireAllClients(options)
      print("firing on clients", options)
   end)
end

return GamesService