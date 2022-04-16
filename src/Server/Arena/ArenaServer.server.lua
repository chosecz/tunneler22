local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local GamesService = require(game.ServerScriptService:WaitForChild('Services'):WaitForChild('GamesService'))
local ServerStorageService = require(game.ServerStorage:WaitForChild('Services'):WaitForChild('ServerStorageService'))

ServerStorageService.Exec()
GamesService.Exec()

print('Arena Server started')
