local GamesService = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('GamesService'))

local MyServerStorageService = {}

function MyServerStorageService.Exec()
   print('MyServerStorageService.Exec')
   GamesService.Exec()
end

return MyServerStorageService
