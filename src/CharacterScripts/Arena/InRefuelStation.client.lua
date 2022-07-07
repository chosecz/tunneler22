repeat task.wait() until game.Players.LocalPlayer.Character

local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')
local refuelStationBlue = workspace.BaseBlue.MainPartBlue
local refuelStationRed = workspace.BaseRed.MainPartRed
local localPlayer = game.Players.LocalPlayer

local function onTouch(part, team)
	local plr = game.Players:GetPlayerFromCharacter(part.Parent)
	if (plr and plr.UserId == localPlayer.UserId and localPlayer.Team.Name == team) then
		remoteFunctions.InRefuelStation:InvokeServer(true)
	end
end

local function onLeave(part, team)
	local plr = game.Players:GetPlayerFromCharacter(part.Parent)
	if (plr and plr.UserId == localPlayer.UserId and localPlayer.Team.Name == team) then
		remoteFunctions.InRefuelStation:InvokeServer(false)
	end
end

refuelStationBlue.Touched:Connect(function(part) onTouch(part, C.TEAM.BLUE) end)
refuelStationBlue.TouchEnded:Connect(function(part) onLeave(part, C.TEAM.BLUE) end)

refuelStationRed.Touched:Connect(function(part) onTouch(part, C.TEAM.RED) end)
refuelStationRed.TouchEnded:Connect(function(part) onLeave(part, C.TEAM.RED) end)
