local UtilServices = game.ReplicatedStorage:WaitForChild('Utils')
local GamesService = require(UtilServices:WaitForChild('GamesService'))

local MyClientService = {}

function MyClientService.Exec()
   print('MyClientService.Exec')
   GamesService.Exec()
end

return MyClientService