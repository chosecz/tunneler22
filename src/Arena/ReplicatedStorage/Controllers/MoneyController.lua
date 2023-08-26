local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Players = game:GetService("Players")

local MoneyController = Knit.CreateController {Name = "MoneyController"}

function MoneyController:KnitInit() print("MoneyController initialized") end

function MoneyController:KnitStart()
  print("MoneyController started")

  local function ObserveMoney(money) 
    print("Money changed to", money)
  end
  
  local MoneyService = Knit.GetService("MoneyService")
  MoneyService:GetMoney():andThen(ObserveMoney):andThen(function()
    MoneyService.MoneyChanged:Connect(ObserveMoney)
  end):catch(warn)

end

return MoneyController
