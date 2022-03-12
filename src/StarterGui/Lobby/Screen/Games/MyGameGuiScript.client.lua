repeat task.wait() until game.Players.LocalPlayer.Character

local F = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Functions'))
local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
local LocalPlayer = game:GetService('Players').LocalPlayer
local screenGui = LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui')
local remoteFunctions = game:GetService('ReplicatedStorage'):WaitForChild('RemoteFunctions')
local remoteEvents = game:GetService('ReplicatedStorage'):WaitForChild('RemoteEvents')
local bindableEvents = game:GetService('ReplicatedStorage'):WaitForChild('BindableEvents')

-- create button
print("MyGameGui: Creating")

local myGameGui = Instance.new("Frame")
myGameGui.Name = "MyGameGui"
myGameGui.BackgroundColor3 = C.COLOR.TURQUOISE
myGameGui.BackgroundTransparency = 0.5
myGameGui.Position = UDim2.new(0.8, 0, 0.3, 0)
myGameGui.Size = UDim2.new(0.2, 0, 0.6, 0)
myGameGui.Visible = false
myGameGui.Parent = screenGui
myGameGui:GetPropertyChangedSignal("Visible"):Connect(function()
  -- gamesGuiVisibilityChanged:Fire(myGameGui.Visible)
end)

function RenderMyGameGui()
  print("creating my game gui")

  myGameGui.Visible = true

  local gameId = LocalPlayer:getAttribute("gameId")
  local game = remoteFunctions.GetGame:InvokeServer(gameId)
  print("*** game", game)

  -- clear if exists
  local list = myGameGui:GetChildren()
	for i, row in pairs(list) do
		row:Destroy()
	end

  local leaveButton = F.createButton({
    Parent = myGameGui,
    Text = "Leave Game",
    Size = UDim2.new(0.8, 0, 0.05, 0),
    Position = UDim2.new(0.1, 0, 0.8, 0),
    Activated = function()
      remoteFunctions.LeaveGame:InvokeServer(gameId)
      bindableEvents.ShowGamesButton:Fire()
      myGameGui.Visible = false
    end
  })

  local readyButton = F.createButton({
    Parent = myGameGui,
    Text = "Ready?",
    Size = UDim2.new(0.8, 0, 0.05, 0),
    Position = UDim2.new(0.1, 0, 0.9, 0),
  })
  readyButton.Activated(function()
    local ready = LocalPlayer:GetAttribute("ready")
    -- not ready will invert value of ready
    ready = not ready
    -- send remote event
    remoteEvents.PlayerReadyChanged:FireServer({ Game = game, Ready = ready })
  end)

  if LocalPlayer:GetAttribute("ready") then
    readyButton.Select()
    readyButton.Text = "Yes, I am ready!"
  else
    readyButton.Unselect()
    readyButton.Text = "Ready?"
  end

  -- for 1 vs 1
  if (game.GameMode == C.GAME_MODE.ONE) then
    local red1name = F.createTextLabel({
      Parent = myGameGui,
      Text = "Waiting for player",
      Size = UDim2.new(0.7, 0, 0.1, 0),
      Position = UDim2.new(0.25, 0, 0.05, 0),
      BackgroundColor3 = Color3.fromRGB(255, 0, 0),
      BackgroundTransparency = 0,
    })
    local red1Ready = F.createTextLabel({
      Parent = myGameGui,
      Text = "?",
      Size = UDim2.new(0.2, 0, 0.1, 0),
      Position = UDim2.new(0.05, 0, 0.05, 0),
    })
     local blue1name = F.createTextLabel({
      Parent = myGameGui,
      Text = "Waiting for player",
      Size = UDim2.new(0.7, 0, 0.1, 0),
      Position = UDim2.new(0.25, 0, 0.2, 0),
      BackgroundColor3 = Color3.fromRGB(0, 0, 255),
      BackgroundTransparency = 0,
    })
    local blue1Ready = F.createTextLabel({
      Parent = myGameGui,
      Text = "?",
      Size = UDim2.new(0.2, 0, 0.1, 0),
      Position = UDim2.new(0.05, 0, 0.2, 0),
    })

    if (#game.Teams[C.GAME_TEAM.RED] > 0) then
      local player = game.Teams[C.GAME_TEAM.RED][1]
      red1name.Text = player.DisplayName
      if (player:GetAttribute("ready")) then
        red1Ready.Text = "✅"
      else
        red1Ready.Text = "?"
      end
    end

    if (#game.Teams[C.GAME_TEAM.BLUE] > 0) then
      local player = game.Teams[C.GAME_TEAM.BLUE][1]
      blue1name.Text = player.DisplayName
      if (player:GetAttribute("ready")) then
        blue1Ready.Text = "✅"
      else
        blue1Ready.Text = "?"
      end
    end
  end

  -- for 2 vs 2
  if (game.GameMode == C.GAME_MODE.TWO) then
    print("not implemented yes")
  end

end

local function checkAndRender(options)
  if (F.isMyGame(options.Game)) then
    RenderMyGameGui()
  end
end

-- REMOTE EVENTS
F.listenToRemoteEvents({ "PlayerJoinedGame", "PlayerLeftGame", "PlayerReadyChanged" }, checkAndRender)

print("MyGameGui: Done")
