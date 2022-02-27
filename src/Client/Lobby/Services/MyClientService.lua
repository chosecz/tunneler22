local UtilServices = game.ReplicatedStorage:WaitForChild('Utils')
local MyUtilService = require(UtilServices:WaitForChild('MyUtilService'))

local MyClientService = {}

function MyClientService.Exec()
   print('MyClientService.Exec')
   MyUtilService.Exec()
end

return MyClientService