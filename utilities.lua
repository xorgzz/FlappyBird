local ggd = require("GGData")

local utilities = {}
local DataBase = ggd:new("db")

if not DataBase.highscore then
	DataBase:set("highscore", 0)
	DataBase:save()
end

if not DataBase.previousScore then
	DataBase:set("previousScore", 0)
	DataBase:save()
end

function utilities:getHighscore()
	return DataBase.highscore
end

function utilities:getPreviousScore()
	return DataBase.previousScore
end

function utilities:setHighScore(score)
	if score > DataBase.highscore then
		print("New highscore")

		DataBase:set("highscore", score)
		DataBase:save()

		return true
	else
		return false
	end
end

function utilities:setPreviousScore(score)
	DataBase:set("previousScore", score)
	DataBase:save()
end

return utilities
