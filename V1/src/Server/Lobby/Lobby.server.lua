local LobbyService = require(game.ServerScriptService:WaitForChild('Services'):WaitForChild('LobbyService'))
local ServerStorageService = require(game.ServerStorage:WaitForChild('Services'):WaitForChild('ServerStorageService'))

ServerStorageService.Exec()
LobbyService.Exec()

print('Server started')
