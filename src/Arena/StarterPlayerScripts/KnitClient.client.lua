local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

-- add controllers
Knit.AddControllers(ReplicatedStorage.Source.Controllers)

Knit.Start():andThen(function()
	print("Knit client started")
end):catch(warn)
