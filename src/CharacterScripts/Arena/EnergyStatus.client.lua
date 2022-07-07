repeat task.wait() until game.Players.LocalPlayer.Character
print("EnergyStatus started")

local remoteFunctions = game.ReplicatedStorage:WaitForChild('RemoteFunctions')
local localPlayer = game.Players.LocalPlayer

local function updateStatus()
	-- get energy from server
	local energy = remoteFunctions.UpdateEnergy:InvokeServer()
	
	-- update GUI
	local energyStatusFrame = localPlayer.PlayerGui:FindFirstChild("EnergyStatusFrame", true)
	if energyStatusFrame then
		energyStatusFrame.Size = UDim2.new(energy / 100, 0, 1, 0)
	end
	
	wait(0.5)
	updateStatus()
end

updateStatus()

--[[
local fuelCapacity = localPlayer.PlayerGui:WaitForChild("EnergyShieldStatus").EnergyFrame.Frame
local fullWidth = fuelCapacity.Size.X.Offset
local fuel = localPlayer.PlayerVars.Fuel
local inRefuelStation = localPlayer.PlayerVars.InRefuelStation

local function consumeFuel()
	-- print("p", localPlayer.Name)
	-- print("Energy:", fuel.Value)
	if (inRefuelStation.Value == false and fuel.Value > 0) then
		fuel.Value = fuel.Value - 1
	elseif (inRefuelStation.Value == true and fuel.Value < 100) then
		fuel.Value = fuel.Value + 1
	end

	-- update gui
	fuelCapacity.Size = UDim2.new(0, fullWidth / 100 * fuel.Value, 0, 40)

	if (fuel.Value == 0) then
		localPlayer.Character:FindFirstChild("Humanoid").Health = 0
	else
		task.wait(0.5)
		consumeFuel()	
	end

end

consumeFuel()

]]