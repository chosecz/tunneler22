local UtilServices = game.ReplicatedStorage:WaitForChild('Utils')
local MyUtilService = require(UtilServices:WaitForChild('MyUtilService'))
local MyServerStorageService = require(game.ServerStorage:WaitForChild('Services'):WaitForChild('MyServerStorageService'))

local MyServerService = {}

function MyServerService.Exec()
   print('MyServerService.Exec')
   MyServerStorageService.Exec()
   MyUtilService.Exec()
end

return MyServerService