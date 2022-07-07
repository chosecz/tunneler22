repeat task.wait() until game.Players.LocalPlayer.Character

local uis = game:GetService("UserInputService")
local remoteEvents = game.ReplicatedStorage:WaitForChild('RemoteEvents')

local function keyboardCheck(i)
  if i.KeyCode == Enum.KeyCode.Space then
    print("Space pressed")
    remoteEvents.PlayerWantsFire:FireServer()
  end
end

uis.InputBegan:Connect(keyboardCheck)