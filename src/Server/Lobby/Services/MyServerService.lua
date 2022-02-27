local UtilServices = game.ReplicatedStorage:WaitForChild('Utils')
local GamesService = require(game.ServerScriptService:WaitForChild('Services'):WaitForChild('GamesService'))
local MyServerStorageService = require(game.ServerStorage:WaitForChild('Services'):WaitForChild('MyServerStorageService'))
local MyServerService = {}

function MyServerService.Exec()
   print('MyServerService.Exec')

   MyServerStorageService.Exec()
   GamesService.Exec()
end

return MyServerService