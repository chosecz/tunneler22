local refuelStation = workspace.BaseBlue.MainPartBlue
local refuelStation1 = workspace.BaseRed.MainPartRed
local inRefuelStation = game.Players.LocalPlayer.PlayerVars.InRefuelStation

local function onTouch(part)
	print("part", part.Parent)
	local plr = game.Players:GetPlayerFromCharacter(part.Parent)
	if (plr and plr.UserId ==  game.Players.LocalPlayer.UserId) then
		inRefuelStation.Value = true
	end
end

local function onLeave(part)
	print("part", part.Parent)
	local plr = game.Players:GetPlayerFromCharacter(part.Parent)
	if (plr and plr.UserId ==  game.Players.LocalPlayer.UserId) then
		inRefuelStation.Value = false
	end
end

refuelStation.Touched:Connect(onTouch)
refuelStation.TouchEnded:Connect(onLeave)

refuelStation1.Touched:Connect(onTouch)
refuelStation1.TouchEnded:Connect(onLeave)
