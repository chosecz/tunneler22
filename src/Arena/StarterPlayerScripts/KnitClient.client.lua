local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

-- add controllers
Knit.AddControllers(ReplicatedStorage.Source.Controllers)

Knit.Start({
  Middleware = {
    Inbound = {
			function(args)
				print("INBOUND:", args)
				return true
			end
		},
  },
}):andThen(function()
  print("Knit client started")
end):catch(warn)