require "game"
require "virtualkeyboard"

function love.load()
	local i = 0

	font = love.graphics.newImageFont("images/font.png",
	    " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")

--	font = love.graphics.newImageFont("images/pixelfree.png",
--	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789#.!?: ")

--	font = love.graphics.newImageFont("images/opensans.png",
--	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&'()*+,-./:;<=>?@[\\]^_`{|}~?\"\" ")

--	font = love.graphics.newFont("fonts/minimal.otf", 32)

	love.graphics.setFont(font)

	vk = Virtualkeyboard:new()
	vk:bind("right", "d")
	vk:bind("left", "q")
	vk:bind("up", "z")
	vk:bind("down", "s")
	vk:bind("select", "space")

	volume = 0
	azerty = true

	click = false
	rclick = false
	longclick = false
	inmenu = true

	dropradius = 0
	dropx = 0
	dropy = 0

	number = 0

	game = Game:new()

	menumusic = love.audio.newSource("sounds/menu.mp3", "static")
	love.audio.setVolume(volume / 10)

	love.mouse.setVisible(false) -- make default mouse invisible
	love.graphics.setBackgroundColor(200, 200, 200)
	menumusic:play()

	tmenu = Treemenu:new(100, 100, 30, "Menu", 0)

		tplay = Treemenu:new(100, 100, 30, "Play", 2)

		toptions = Treemenu:new(100, 100, 30, "Options", 6)
			tmode = Treemenu:new(100, 100, 30, "Input mode : AZERTY", 9)
		toptions:add(Treemenu:new(100, 100, 30, "Vol+", 3))
		toptions:add(Treemenu:new(100, 100, 30, "Vol-", 4))
		toptions:add(tmode)
		toptions:add(Treemenu:new(100, 100, 30, "Back", 1))

		thow = Treemenu:new(100, 100, 30, "How to play", 8)
		thow:add(Treemenu:new(100, 100, 30, "Back", 1))

		tquit = Treemenu:new(100, 100, 30, "Quit", 5)
	tmenu:add(tplay)
	tmenu:add(toptions)
	tmenu:add(thow)
	tmenu:add(tquit)
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 then
		longclick = true
		click = true
		dropradius = 1
	elseif button == 2 then
		rclick = true
	end
end

function love.mousereleased(x, y, button, istouch)
   if button == 1 then
		longclick = false
	end
end

function love.update(dt)
	local x, y = love.mouse.getPosition() -- get the position of the mouse
	local tmp = 0


	if inmenu then
		number = tmenu:update(vk, number)
	else
		number = game:update(vk)
	end

	if number == 2 then -- GAME
		inmenu = false
		menumusic:stop()
	elseif number == 3 and volume < 10 then
		love.audio.setVolume(love.audio.getVolume() + 0.1)
		volume = volume + 1
	elseif number == 4 and volume > 0 then
		love.audio.setVolume(love.audio.getVolume() - 0.1)
		volume = volume - 1
	elseif number == 5 then
		love.event.push('quit')
	elseif number == 7 then
		inmenu = true
		menumusic:play()
		game = Game:new()
	elseif number == 8 then -- How to play
	elseif number == 9 then
		azerty = not azerty
		if azerty then
			tmode:setname("Input mode : AZERTY")
			vk:bind("left", "q")
			vk:bind("up", "z")
		else
			tmode:setname("Input mode : QWERTY")
			vk:bind("left", "a")
			vk:bind("up", "w")
		end
	end

	if dropradius > 0 then
		dropradius = (dropradius + 1) % 20
	end

	click = false
	rclick = false
	vk:update(dt)
end

function love.draw()
	local x, y = love.mouse.getPosition() -- get the position of the mouse


	if number == 2 then -- Draw game
		game:draw()
	else
		tmenu:draw()
		love.graphics.setColor(255, 255, 255)

		if number == 6 then -- Draw options
			love.graphics.print("Volume : " .. volume, 100, 400)
		elseif number == 8 then -- Draw how to play
			love.graphics.print("Click on the circles to bring the number to zero.\nPress space to generate new circles.\nDon't click on circles if the operation can't generate an integer.\nGood luck !", 100, 200)
		end
	end
	love.graphics.setColor(0, 0, 0)
	if longclick then
		love.graphics.circle("fill", x, y, 2, 100)
	else
		love.graphics.circle("fill", x, y, 4, 100)
	end

	if dropradius > 0 then
		if dropradius < 3 then
			dropx = x
			dropy = y
		end
		love.graphics.circle("line", dropx, dropy, dropradius, 100)
	end
end
