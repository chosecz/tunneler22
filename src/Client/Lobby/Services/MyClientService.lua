local UtilServices = game.ReplicatedStorage:WaitForChild('Utils')

local MyClientService = {}

function MyClientService.Exec()
   print('MyClientService.Exec')
end

return MyClientService