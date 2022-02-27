local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')
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

   -- add player to list
   table.insert(game.Players, {
      Player = player,
      Team = "TODO",
      Ready = false,
   })

   -- set gameId for player
   player:SetAttribute("gameId", gameId)

   print("GamesService.AddPlayerToGame: Players:", game.Players)
end

function GamesService.CreateGame(player, options)
   print("Server: CreateGame", options)
   local gameId = generateGameId(player.UserId);
   local game = {
      GameType = options.GameType,
      GameMode = options.GameMode,
      Owner = player,
      Players = {},
   }

   -- add to game list
   GamesService.Games[gameId] = game

   -- add player to game
   GamesService.AddPlayerToGame(player, gameId)

   print("Server: Game created", gameId)
   return gameId
end

function GamesService.Exec()
   print('GamesService.Exec')
   remoteFunctions.CreateGame.OnServerInvoke = GamesService.CreateGame
   remoteFunctions.ListOfPublicGames.OnServerInvoke = GamesService.ListOfPublicGames
end

return GamesService