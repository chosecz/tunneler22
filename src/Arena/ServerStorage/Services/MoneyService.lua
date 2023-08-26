local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Players = game:GetService("Players")

local MoneyService = Knit.CreateService({
  Name = "MoneyService",
  Client = {
    MoneyChanged = Knit.CreateSignal(),
  },
  MoneyPerPlayer = {},
  StartingMoney = 10,
})

function MoneyService:GetMoney(player)
  return self.MoneyPerPlayer[player] or self.StartingMoney
end

function MoneyService.Client:GetMoney(player)
  return self.Server:GetMoney(player)
end

function MoneyService:AddMoney(player, amount)
  local currentMoney = self:GetMoney(player)
  if amount > 0 then
    local newMoney = currentMoney + amount
    self.MoneyPerPlayer[player] = newMoney
    self.Client.MoneyChanged:Fire(player, newMoney)
  end
end

function MoneyService:KnitInit()
  print("MoneyService initialized")
  Players.PlayerRemoving:Connect(function(player)
    self.MoneyPerPlayer[player] = nil
  end)
end

function MoneyService:KnitStart()
  print("MoneyService started")

  while true do
    wait(1)
    for _, player in ipairs(Players:GetPlayers()) do
      self:AddMoney(player, 1)
    end
  end
end

return MoneyService
