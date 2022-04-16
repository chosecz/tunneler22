local C = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Constants'))
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

-- just fake game data for development
local fakeGame = {
  Id = "GID_-1",
  GameType = C.GAME_TYPE.PUBLIC,
  GameMode = C.GAME_MODE.ONE,
  GameStatus = C.GAME_STATUS.WAITING,
  Teams = {[C.GAME_TEAM.RED] = {
      [1] = {
        UserId = "-1",
        Name = "Player 1",
      }
    }, [C.GAME_TEAM.BLUE] = {
      [1] = {
        UserId = "-2",
        Name = "Player 2",
      }
    }
  }
}

local function onPlayerAdded(player)
    local joinData = player:GetJoinData()
    local game = joinData.TeleportData

    if (not game) then
      game = fakeGame
    end
    
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
