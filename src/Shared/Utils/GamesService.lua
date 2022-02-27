local GamesService = {}

GamesService.PublicGames = {}
GamesService.PublicGames['GID_1'] = { playerId="132135153", gameType="test" }
GamesService.PublicGames['GID_2'] = { playerId="879879", gameType="neco" }
GamesService.PublicGames['GID_3'] = { playerId="879879", gameType="xxxxx" }

function GamesService.GetListOfPublicGames()
   return GamesService.PublicGames
end

function GamesService.Exec()
   print('GamesService.Exec')
end

return GamesService