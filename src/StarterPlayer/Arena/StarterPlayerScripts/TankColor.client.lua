print('Tank script started')

local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')
local player = script.Parent

-- call remote function
remoteFunctions.ColorTank:InvokeServer(player)
