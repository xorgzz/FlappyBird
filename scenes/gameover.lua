local composer = require("composer")
local relayout = require("relayout")
local utilities = require("utilities")

local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY

local scene = composer.newScene()

local MainLayer

function scene:create(event)
	print("scene:create - gameover")

	MainLayer = display.newGroup()

	self.view:insert(MainLayer)

	local bg = display.newImageRect("background.png", _W, _H)
	bg.x = _CX
	bg.y = _CY
	MainLayer:insert(bg)


	local ScoreLabel = display.newText("Wynik: " .. utilities:getPreviousScore(), _CX, _CY, "czcionka.ttf", 34)
	MainLayer:insert(ScoreLabel)

	if utilities:getPreviousScore() > utilities:getHighscore() then
		utilities:setHighScore(utilities:getPreviousScore())
	end

	local HighScoreLabel = display.newText("Najlepszy wynik: " .. utilities:getHighscore(), _CX, _CY + 50,
		"czcionka.ttf", 18)
	MainLayer:insert(HighScoreLabel)

	local btnPlay = display.newText("Restart", _CX, _CY+280, "czcionka.ttf", 28)
	MainLayer:insert(btnPlay)

	btnPlay:addEventListener("tap", function()
		composer.gotoScene("scenes.game")
	end)
end

function scene:show(event)
	if (event.phase == "will") then
	elseif (event.phase == "did") then
	end
end

function scene:hide(event)
	if (event.phase == "will") then
	elseif (event.phase == "did") then
	end
end

function scene:destroy(event)
	if event.phase == "will" then
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)


return scene
