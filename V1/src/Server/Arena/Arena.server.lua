local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local ArenaService = require(game.ServerScriptService:WaitForChild('Services'):WaitForChild('ArenaService'))
local ServerStorageService = require(game.ServerStorage:WaitForChild('Services'):WaitForChild('ServerStorageService'))

ServerStorageService.Exec()
ArenaService.Exec()

print('Arena Server started')
