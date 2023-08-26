local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Players = game:GetService("Players")

-- add services
Knit.AddServices(ServerStorage.Source.Services)

Knit.Start():andThen(function()
  print("Knit server started")
end):catch(warn)