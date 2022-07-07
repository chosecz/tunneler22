print('Tank script started')

local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')
local character = script.Parent
local player = game.Players:GetPlayerFromCharacter(character)

-- call remote function
remoteFunctions.ColorTank:InvokeServer(player)
