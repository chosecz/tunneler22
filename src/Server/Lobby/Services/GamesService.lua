local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')
local remoteEvents = game:GetService('ReplicatedStorage'):WaitForChild('RemoteEvents')
local GamesService = {}

-- holds list of all games
local games = {}

local function generateGameId(userId)
   return "GID_"..userId
end

local function ListOfPublicGames()
   -- TODO: filter only public games
   return games
end

local function updateGameStatus(game)
   local gameId = game.Id
   local gameMode = games[gameId].GameMode
   local redPlayers = game.Teams[C.GAME_TEAM.RED]
   local bluePlayers = game.Teams[C.GAME_TEAM.BLUE]
   local players = #redPlayers + #bluePlayers
   -- for GAME_MODE.TWO
   local maxPlayers = 2

   if (gameMode == C.GAME_MODE.TWO) then
      maxPlayers = 4
   end

   if (players < maxPlayers) then
      games[gameId].Full = false
   else
      games[gameId].Full = true
   end
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

local function AddPlayerToGame(player, gameId)
   print("GamesService.AddPlayerToGame", player, gameId)
   local game = games[gameId]
   local team = resolveTeamForPlayer(game)

   -- add player to list
   table.insert(game.Teams[team], player)

   -- update status of game
   updateGameStatus(game)

   -- set gameId for player
   player:SetAttribute("gameId", gameId)
   player:SetAttribute("ready", false)

   print("GamesService.AddPlayerToGame:", game)
   remoteEvents.PlayerJoinedGame:FireAllClients({ Game = game, Player = player })
   return gameId
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
   AddPlayerToGame(player, gameId)
   print("Server: Game created", gameId)

   -- notify all clients, that new game was created
   remoteEvents.GameCreated:FireAllClients({ Game = game, Player = player })
   return gameId
end

local function GetGame(player, gameId)
   return games[gameId]
end;

function GamesService.Exec()
   print('GamesService.Exec')
   remoteFunctions.CreateGame.OnServerInvoke = CreateGame
   remoteFunctions.AddPlayerToGame.OnServerInvoke = AddPlayerToGame
   remoteFunctions.ListOfPublicGames.OnServerInvoke = ListOfPublicGames
   remoteFunctions.GetGame.OnServerInvoke = GetGame
end

return GamesService