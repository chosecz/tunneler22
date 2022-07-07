print('Tank script started')

local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')
local character = script.Parent
local player = game.Players:GetPlayerFromCharacter(character)

print("**** calling remote function")
remoteFunctions.ColorTank:InvokeServer(player)
