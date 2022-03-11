local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')
local remoteEvents = game:GetService('ReplicatedStorage'):WaitForChild('RemoteEvents')
local GamesService = {}

GamesService.Games = {}

local function generateGameId(userId)
   return "GID_"..userId
end

function GamesService.ListOfPublicGames()
   -- TODO: filter only public games
   return GamesService.Games
end

function GamesService.AddPlayerToGame(player, gameId)
   print("GamesService.AddPlayerToGame", player, gameId)
   local game = GamesService.Games[gameId]
   local gameMode = GamesService.Games[gameId].GameMode
   local team = nil
   local redPlayers = game.Teams[C.GAME_TEAM.RED]
   local bluePlayers = game.Teams[C.GAME_TEAM.BLUE]

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

   -- add player to list
   table.insert(game.Teams[team], {
      Player = player,
      Ready = false,
   })

   print("gameMode", gameMode)
   print("redPlayers", #redPlayers)
   print("bluePlayers", #bluePlayers)

   -- set gameId for player
   player:SetAttribute("gameId", gameId)

   print("GamesService.AddPlayerToGame:", game)
   return gameId
end

function GamesService.CreateGame(player, options)
   print("Server: CreateGame", options)
   local gameId = generateGameId(player.UserId);
   local game = {
      Id = gameId,
      GameType = options.GameType,
      GameMode = options.GameMode,
      Owner = player,
      Teams = {
         [C.GAME_TEAM.RED] = {},
         [C.GAME_TEAM.BLUE] = {},
      },
   }

   -- add to game list
   GamesService.Games[gameId] = game

   -- add player to game
   GamesService.AddPlayerToGame(player, gameId)
   print("Server: Game created", gameId)

   -- notify all clients, that new game was created
   remoteEvents.GameCreated:FireAllClients()
   return gameId
end

function GamesService.Exec()
   print('GamesService.Exec')
   remoteFunctions.CreateGame.OnServerInvoke = GamesService.CreateGame
   remoteFunctions.AddPlayerToGame.OnServerInvoke = GamesService.AddPlayerToGame
   remoteFunctions.ListOfPublicGames.OnServerInvoke = GamesService.ListOfPublicGames
end

return GamesService