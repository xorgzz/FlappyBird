local composer = require("composer")
local relayout = require("relayout")
local util = require("utilities")
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY

local scene = composer.newScene()

local bck = {}
local rury = {}
local czyDodacRure = 0
local gameON = false
local score = 0
local scoreLabel
local ptak
local MainLayer
local WorldLayer
local ScoreLayer


local function dodajRure()
	local odleglosc = math.random(170, 210)
	local yPos = math.random(200, _H - 200)
	local goraRura = display.newImageRect(WorldLayer, "rura.png", 50, 600)
	goraRura.x = _W + 50
	goraRura.y = yPos - (odleglosc / 2) - 300
	-- local goraRura = display.newRect(_W + 50, yPos - (odleglosc / 2) - 300, 50, 600)
	-- goraRura.fill = { 1, 0, 0 }
	goraRura.type = "rura"
	goraRura.xScale = -1
	goraRura.rotation = -180
	rury[#rury + 1] = goraRura

	local dolaRura = display.newImageRect(WorldLayer, "rura.png", 50, 600)
	dolaRura.x = _W + 50
	dolaRura.y = yPos + (odleglosc / 2) + 300
	-- local dolaRura = display.newRect(_W + 50, yPos + (odleglosc / 2) + 300, 50, 600)
	-- dolaRura.fill = { 0, 1, 0 }
	dolaRura.type = "rura"
	rury[#rury + 1] = dolaRura

	local sensor = display.newRect(WorldLayer, _W + 80, _CY + 300, 5, 2000)
	sensor.fill = { 0, 0, 1 }
	sensor.type = "sensor"
	sensor.alpha = 0
	rury[#rury + 1] = sensor
end


local function checkCollision(x1, x2)
	local L = (x1.contentBounds.xMin) <= x2.contentBounds.xMin and (x1.contentBounds.xMax) >= x2.contentBounds.xMin
	local R = (x1.contentBounds.xMin) >= x2.contentBounds.xMin and (x1.contentBounds.xMin) <= x2.contentBounds.xMax
	local U = (x1.contentBounds.yMin) <= x2.contentBounds.yMin and (x1.contentBounds.yMax) >= x2.contentBounds.yMin
	local D = (x1.contentBounds.yMin) >= x2.contentBounds.yMin and (x1.contentBounds.yMin) <= x2.contentBounds.yMax
	return (L or R) and (U or D)
end

--
-- update ptaka

local function update()
	if gameON and ptak.nieZyje then
		for i = #bck, 1, -1 do
			local b = bck[i]
			b:translate(-2, 0)
			if b.x < -(_W / 2) then
				b.x = b.x + _W * 3
			end
		end
		for i = #rury, 1, -1 do
			local object = rury[i]
			object:translate(-2, 0)


			-- to zapobiega przed zapychaniem pamięci miniętymi rurami
			if object.x < -100 then
				local zzz = table.remove(rury, i)
			end
			if zzz ~= nil then
				zzz:removeSelf()
				zzz = nil
			end

			if checkCollision(object, ptak) then
				if object.type == "sensor" then
					score = score + 1
					scoreLabel.text = score .. " ptk"
					print("score: " .. score)
					local zzz = table.remove(rury, i)
					if zzz ~= nil then
						zzz:removeSelf()
						zzz = nil
					end
				else
					print("die")
					util:setPreviousScore(score)
					ptak.nieZyje = false
					transition.to(ptak, { time = 600, y = _H - 20, onComplete=function ()
						composer.gotoScene("scenes.gameover")				
					end })
				end
			end
		end

		ptak.velocity = ptak.velocity - ptak.gravity
		ptak.y = ptak.y - ptak.velocity
		if ptak.y > _H or ptak.y < 0 then
			print("die")
			util:setPreviousScore(score)
			ptak.nieZyje = false
			transition.to(ptak, { time = 100, y = _H + 10, onComplete=function ()
				composer.gotoScene("scenes.gameover")				
			end })
		end

		if czyDodacRure > 100 then
			dodajRure()
			czyDodacRure = 0
		end
		czyDodacRure = czyDodacRure + 1
	end
end

Runtime:addEventListener("enterFrame", update)

--
-- Latanie

local function onTouch(event)
	if event.phase == "began" then
		if not gameON then
			gameON = true
		end
		ptak.velocity = 10
	end
end

Runtime:addEventListener("touch", onTouch)

function scene:create(event)
	print("scene:create - empty")
	
	MainLayer = display.newGroup()
	MainLayer = display.newGroup()
	WorldLayer = display.newGroup()
	MainLayer:insert(WorldLayer)

	ScoreLayer = display.newGroup()
	MainLayer:insert(ScoreLayer)

	self.view:insert(MainLayer)

	-- tło
	local b1 = display.newImageRect(WorldLayer, "background.png", _W, _H)
	b1.x = _CX
	b1.y = _CY
	bck[#bck + 1] = b1

	local b2 = display.newImageRect(WorldLayer, "background.png", _W, _H)
	b2.x = _CX + _W
	b2.y = _CY
	bck[#bck + 1] = b2

	local b3 = display.newImageRect(WorldLayer, "background.png", _W, _H)
	b3.x = _CX + 2 * _W
	b3.y = _CY
	bck[#bck + 1] = b3

	-- ptak
	ptak = display.newImageRect(WorldLayer, "ptak.png", 25, 20)
	ptak.x = 100
	ptak.y = _CY
	ptak.nieZyje = true
	-- local ptak = display.newRect(100, _CY, 20, 20) -- prototyp ptaka
	-- ptak.fill = {1, 1, 0}
	ptak.velocity = 0
	ptak.gravity = 0.6

	-- wynik
	scoreLabel = display.newText("0 ptk", _CX, 128, "czcionka.ttf", 36)
	ScoreLayer:insert(scoreLabel)


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
		Runtime:removeEventListener("touch", onTouch)
	end
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)


return scene
