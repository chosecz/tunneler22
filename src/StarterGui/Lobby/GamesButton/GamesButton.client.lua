local gamesButton = script.Parent:WaitForChild('Screen'):WaitForChild('GamesButton')

local function onButtonActivated()
	print("button pressed!")
end

gamesButton.Activated:Connect(onButtonActivated)
