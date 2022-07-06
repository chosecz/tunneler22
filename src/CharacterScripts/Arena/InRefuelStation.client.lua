local refuelStationBlue = workspace.BaseBlue.MainPartBlue
local refuelStationRed = workspace.BaseRed.MainPartRed
--[[
local inRefuelStation = game.Players.LocalPlayer.PlayerVars.InRefuelStation

local function onTouch(part)
	local plr = game.Players:GetPlayerFromCharacter(part.Parent)
	if (plr and plr.UserId ==  game.Players.LocalPlayer.UserId) then
		inRefuelStation.Value = true
	end
end

local function onLeave(part)
	local plr = game.Players:GetPlayerFromCharacter(part.Parent)
	if (plr and plr.UserId ==  game.Players.LocalPlayer.UserId) then
		inRefuelStation.Value = false
	end
end

refuelStationBlue.Touched:Connect(onTouch)
refuelStationBlue.TouchEnded:Connect(onLeave)

refuelStationRed.Touched:Connect(onTouch)
refuelStationRed.TouchEnded:Connect(onLeave)
]]