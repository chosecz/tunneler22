print('Tank script started')
local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')

-- call remote function
remoteFunctions.ColorTank:InvokeServer()
