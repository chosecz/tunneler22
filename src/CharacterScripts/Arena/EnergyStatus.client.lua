local localPlayer = game.Players.LocalPlayer
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