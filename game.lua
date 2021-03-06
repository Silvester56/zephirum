class = require "30log"
require "circle"
require "treemenu"
Game = class("Game")

function Game:init()
	self.circles = {}
	self.nb = 0
	self.max = 3
	self.notbegun = true
	self.start = 0
	self.integer = 0
	self.won = false
	self.minutes = 0
	self.seconds = 0
	self.centis = 0
	self.tmenu = Treemenu:new(100, 100, 45, "Menu", 0)
	self.tmenu:add(Treemenu:new(100, 100, 45, "Try again", 2))
	self.tmenu:add(Treemenu:new(100, 100, 45, "Back", 1))
	self.notplayed = true
	self.gamesound = love.audio.newSource("sounds/game.mp3", "static")
end

function Game:add()
	local max = 5;
	local val
	local op = math.random(4) -- +, -, *, /, square root
	local center = love.graphics.getWidth() / 2

	for i = 2, 20 do
		if i * i == self.integer and math.random(3) == 1 then
			op = 5
		end
	end

	if self.integer > -10 and self.integer < 10 then
		max = 3
	end

	if op >= 3 then
		val = 1 + math.random(max - 1)
	else
		val = math.random(max)
	end

	for i = 0, self.nb - 1 do
		if (self.circles[i]:getval() == val and self.circles[i]:getop() == op) or (self.circles[i]:getop() == 5 and op == 5) then -- That circle already exist
			return
		end
	end

	self.circles[self.nb] = Circle:new(center + (self.nb - self.max / 2) * 150, 200, 50, val, op)
	self.nb = self.nb + 1
end

function Game:repop()
	self.circles = {}
	self.nb = 0

	while self.nb < self.max do
		self:add()
	end
end

function Game:update(v)
	if self.notbegun then
		self.integer = (50 + math.random(200)) * (3 - 2 * (math.random(2)))
		self:repop()
		self.start = love.timer.getTime()
		self.notbegun = false
	end

	if v:isdownonce("select") then
		self:repop()
	end
	if self.won then
		local tmp = self.tmenu:update(v)

		if tmp == 2 then
			self.notbegun = true
			self.won = false
			self.notplayed = true
		elseif tmp == 1 then
			return 7
		end
	else
		self.centis = math.floor((love.timer.getTime() - self.start) * 100) % 100
		self.seconds = math.floor(love.timer.getTime() - self.start) % 60
		self.minutes = math.floor((love.timer.getTime() - self.start) / 60)

		for i = 0, self.nb - 1 do
			local tmp = self.circles[i]:update(self.integer)

			if tmp ~= self.integer then
				self.integer = tmp
				if self.integer == 0 then
					self.won = true
				else
					self:repop()
				end
			end
		end
	end
	return 2
end

function printable(number)
	if number < 10 then
		return "0" .. number
	end
	return number
end

function Game:draw()
	width = love.graphics.getWidth()
	if self.won then
		if self.notplayed then
			self.gamesound:play()
			self.notplayed = false
		end
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("GAME!", width / 2, 300, 0, 3, 3)
		self.tmenu:draw()
	else
		for i = 0, self.nb - 1 do
			self.circles[i]:draw(width / 2 + (100 * (i - self.nb / 2)), 200)
		end
	end
	love.graphics.setColor(1, 1, 1)
	love.graphics.print(self.integer, width / 2, 30, 0, 2, 2)
	love.graphics.print(printable(self.minutes) .. ":" .. printable(self.seconds) .. ":" .. self.centis, width / 2, 400, 0, 2, 2)
end
