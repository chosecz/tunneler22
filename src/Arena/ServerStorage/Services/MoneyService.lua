local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local PlayerStore = DataStoreService:GetDataStore("PlayerStore", "Money")

local MoneyService = Knit.CreateService({
  Name = "MoneyService",
  Client = {
    MoneyChanged = Knit.CreateSignal(),
  },
  MoneyPerPlayer = {},
  StartingMoney = 10,
})

function MoneyService:GetMoney(player)
  print("Server:GetMoney > userId:" .. player.UserId)
  local userId = player.UserId
  local playerMoney = self.MoneyPerPlayer[userId]
  if playerMoney then
    return playerMoney
  end

  local success, savedMoney = pcall(function()
    return PlayerStore:GetAsync(player.UserId)
  end)

  -- return money from serveer of
  return savedMoney or self.StartingMoney
end

function MoneyService.Client:GetMoney(player)
  return self.Server:GetMoney(player)
end

function MoneyService:AddMoney(player, amount)
  local userId = player.UserId
  local currentMoney = self:GetMoney(player)
  if amount > 0 then
    local newMoney = currentMoney + amount
    self.MoneyPerPlayer[userId] = newMoney
    self.Client.MoneyChanged:Fire(player, newMoney)
  end
end

function MoneyService:RemovePlayer(player)
  print("PlayerRemoving...", player)
  local userId = player.UserId
  local currentMoney = self.MoneyPerPlayer[userId]
  if currentMoney and userId then
    local success, errorMessage = pcall(function()
      print("Going to save money ".. currentMoney .." for Player:", userId)
      PlayerStore:SetAsync(userId, currentMoney) 
    end)
    if not success then
      print(errorMessage)
    end  
    print("Money saved")
  end
  self.MoneyPerPlayer[userId] = nil
end

function MoneyService:KnitInit()
  print("MoneyService initialized")
  Players.PlayerRemoving:Connect(function(player)
    self:RemovePlayer(player)
  end)
end

function MoneyService:KnitStart()
  print("MoneyService started")
  print('Players', Players:GetPlayers())
  while true do
    wait(5)
    for _, player in ipairs(Players:GetPlayers()) do
      self:AddMoney(player, 1)
    end
  end
end

return MoneyService
