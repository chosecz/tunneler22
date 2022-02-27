local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')
local GamesService = {}

GamesService.PublicGames = {}
GamesService.FriendGames = {}

local function generateGameId(userId)
   return "GID_"..userId
end

function GamesService.ListOfPublicGames()
   return GamesService.PublicGames
end

function GamesService.CreateGame(player, options)
   print("Server: CreateGame", options)
   local gameId = generateGameId(player.UserId);
   local game = {
      GameType = options.GameType,
      GameMode = options.GameMode,
      Owner = player
   }

   -- is public or friend game
   if options.GameType == C.GAME_TYPE.PUBLIC then
      GamesService.PublicGames[gameId] = game
   elseif options.GameType == C.GAME_TYPE.FRIEND then
      GamesService.FriendGames[gameId] = game
   end

   print("Server: Game created", gameId)
   return gameId
end

function GamesService.Exec()
   print('GamesService.Exec')
   remoteFunctions.CreateGame.OnServerInvoke = GamesService.CreateGame
   remoteFunctions.ListOfPublicGames.OnServerInvoke = GamesService.ListOfPublicGames
end

return GamesService