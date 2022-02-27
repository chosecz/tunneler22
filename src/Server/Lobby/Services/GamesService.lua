local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')
local GamesService = {}

GamesService.PublicGames = {}

local function generateGameId(userId)
   return "GID_"..userId
end

function GamesService.ListOfPublicGames()
   return GamesService.PublicGames
end

function GamesService.CreateGame(player, options)
   print("Server: CreateGame", options)
   local game = {
      GameType = options.GameType,
      GameMode = options.GameMode,
      Owner = player
   }
   local gameId = generateGameId(player.UserId);
   GamesService.PublicGames[gameId] = game
   print('gameId', gameId)
   print('game', game)
   return gameId
end

function GamesService.Exec()
   print('GamesService.Exec')
   remoteFunctions.CreateGame.OnServerInvoke = GamesService.CreateGame
   remoteFunctions.ListOfPublicGames.OnServerInvoke = GamesService.ListOfPublicGames
end

return GamesService