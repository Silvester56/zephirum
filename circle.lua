class = require "30log"
Circle = class("Circle")

function Circle:init(x, y, r, val, op)
	self.posx = x
	self.posy = y
	self.radius = r
	self.r = math.random(150) / 255
	self.g = math.random(150) / 255
	self.b = math.random(150) / 255
	self.textcolor = 1
	if op == 5 then
		self.r = 0.8
		self.g = 0.8
		self.b = 0.8
		self.textcolor = 0.6
	end
	self.value = val
	self.operation = op
end

function Circle:update(number)
	local x, y = love.mouse.getPosition() -- get the position of the mouse
	local distance = math.sqrt((self.posx - x) * (self.posx - x) + (self.posy - y) * (self.posy - y))

	if click and distance < self.radius then -- Circle clicked
		if self.operation == 1 then
			return number + self.value
		elseif self.operation == 2 then
			return number - self.value
		elseif self.operation == 3 then
			return number * self.value
		elseif self.operation == 4 then
			if number % self.value == 0 then
				return number / self.value
			else
				self.r = 0.8
				self.g = 0
				self.b = 0
			end
		elseif self.operation == 5 then
			return math.sqrt(number)
		end
	end
	return number
end

function Circle:printcenter(text, x, y)
	local posx = x - font:getWidth(text) / 2
	local posy = y - font:getHeight() / 2
	love.graphics.print(text, math.floor(posx), math.floor(posy))
end

function Circle:draw()
	love.graphics.setColor(self.r, self.g, self.b)
    love.graphics.circle("fill", self.posx, self.posy, 50, 100)
	love.graphics.setColor(self.textcolor, self.textcolor, self.textcolor)
	if self.operation == 1 then
		self:printcenter("+" .. self.value, self.posx, self.posy, 9, 17)
	elseif self.operation == 2 then
		self:printcenter("-" .. self.value, self.posx, self.posy, 9, 17)
	elseif self.operation == 3 then
		self:printcenter("*" .. self.value, self.posx, self.posy, 9, 17)
	elseif self.operation == 4 then
		self:printcenter("/" .. self.value, self.posx, self.posy, 9, 17)
	elseif self.operation == 5 then
		self:printcenter("root", self.posx, self.posy, 9, 17)
	end
end

function Circle:getval()
	return self.value
end

function Circle:getop()
	return self.operation
end
