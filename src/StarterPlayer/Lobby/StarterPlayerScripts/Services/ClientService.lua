repeat task.wait() until game.Players.LocalPlayer.Character
local UtilServices = game.ReplicatedStorage.Utils

local ClientService = {}

function ClientService.Exec()

   local Player = game:GetService('Players').LocalPlayer

   -- disable leaderboard on start
   game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

   print('ClientService.Exec')
end

return ClientService