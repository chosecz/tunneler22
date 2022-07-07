repeat task.wait() until game.Players.LocalPlayer.Character

local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')
local refuelStationBlue = workspace.BaseBlue.MainPartBlue
local refuelStationRed = workspace.BaseRed.MainPartRed
local localPlayer = game.Players.LocalPlayer

local function onTouch(part)
	local plr = game.Players:GetPlayerFromCharacter(part.Parent)
	if (plr and plr.UserId == localPlayer.UserId) then
		remoteFunctions.InRefuelStation:InvokeServer(true)
	end
end

local function onLeave(part)
	local plr = game.Players:GetPlayerFromCharacter(part.Parent)
	if (plr and plr.UserId == localPlayer.UserId) then
		remoteFunctions.InRefuelStation:InvokeServer(false)
	end
end

refuelStationBlue.Touched:Connect(onTouch)
refuelStationBlue.TouchEnded:Connect(onLeave)

refuelStationRed.Touched:Connect(onTouch)
refuelStationRed.TouchEnded:Connect(onLeave)
