
local composer = require("composer")
local relayout = require("relayout")
local utilities = require("utilities")
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY


local scene = composer.newScene()

local grpMain

function scene:create(event)
	print("scene:create - menu")

	grpMain = display.newGroup()

	self.view:insert(grpMain)


	local bg = display.newImageRect("background.png", _W, _H)
	bg.x = _CX
	bg.y = _CY
	grpMain:insert(bg)

	--

	local btnPlay = display.newText("Start\n gry", _CX, _CY, "czcionka.ttf", 60)
	grpMain:insert(btnPlay)

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
