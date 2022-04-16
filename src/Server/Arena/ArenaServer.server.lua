-- local GamesService = require(game.ServerScriptService:WaitForChild('Services'):WaitForChild('GamesService'))
local ServerStorageService = require(game.ServerStorage:WaitForChild('Services'):WaitForChild('ServerStorageService'))
local Teams = game:GetService("Teams")

local redTeam = Instance.new("Team", Teams)
redTeam.TeamColor = BrickColor.new("Bright red")
redTeam.AutoAssignable = false
redTeam.Name = "Red Team"

local blueTeam = Instance.new("Team", Teams)
blueTeam.TeamColor = BrickColor.new("Bright blue")
blueTeam.AutoAssignable = false
blueTeam.Name = "Blue Team"

local Players = game:GetService("Players")
 
local function onPlayerAdded(player)
    local joinData = player:GetJoinData()
    local game = joinData.TeleportData
    if (game) then
      print("game.Id", game.Id)
      print("game.GameType", game.GameType)
      print("game.GameMode", game.GameMode)

      for i, team in pairs(game.Teams) do
        print("i team", i, team)
        for j, player in pairs(team) do
          print("j player", j, player.UserId, player.Name)
        end
      end
    end
end
 
Players.PlayerAdded:Connect(onPlayerAdded)


ServerStorageService.Exec()
-- GamesService.Exec()

print('Arena Server started')
