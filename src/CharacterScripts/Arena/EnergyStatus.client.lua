repeat task.wait() until game.Players.LocalPlayer.Character
print("EnergyStatus started")

local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')
local localPlayer = game.Players.LocalPlayer

local function updateStatus()
	local gameStatus = remoteFunctions.GetGameStatus:InvokeServer()
	local InRefuelStation = localPlayer:GetAttribute("InRefuelStation")

	if (gameStatus == C.GAME_STATUS.RUNNING) then
		-- get energy from server
		local energy = remoteFunctions.UpdateEnergy:InvokeServer()
		
		-- update GUI
		local energyStatusFrame = localPlayer.PlayerGui:FindFirstChild("EnergyStatusFrame", true)
		if energyStatusFrame then
			energyStatusFrame.Size = UDim2.new(energy / 100, 0, 1, 0)
		end
		-- energy refueling faster in station
		if (InRefuelStation) then
			wait(0.5)
		else
			wait(1)
		end
	end
	updateStatus()
end

updateStatus()
