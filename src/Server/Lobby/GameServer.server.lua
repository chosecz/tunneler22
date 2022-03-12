local GamesService = require(game.ServerScriptService:WaitForChild('Services'):WaitForChild('GamesService'))
local ServerStorageService = require(game.ServerStorage:WaitForChild('Services'):WaitForChild('ServerStorageService'))

ServerStorageService.Exec()
GamesService.Exec()

print('Server started')
