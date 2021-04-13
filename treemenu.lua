class = require "30log"
Treemenu = class("Treemenu")

function Treemenu:init(x, y, p, n, c)
	self.posx = x
	self.posy = y
	self.pad = p
	self.name = n
	self.code = c -- 1 : go back
	self.subs = {} -- submenus
	self.nb = 0 -- number of childs
	self.previous = 0
	self.current = 0
	self.inchild = -1
	self.anim = 0
	self.leap = 0
end

function Treemenu:add(child)
	self.subs[self.nb] = child
	self.nb = self.nb + 1
end

function Treemenu:removeselect() -- TODO vérifier existence ailleur et pertinence
	return self:remove(self.current)
end

function Treemenu:remove(n)
	for i = n, self.nb - 2 do
		self.subs[i] = self.subs[i + 1]
	end
	self.nb = self.nb - 1
	return self.nb
end

function Treemenu:update(v, old)
	local x, y = love.mouse.getPosition() -- get the position of the mouse

	self.previous = self.current

	if self.anim == 100 then
		self.leap = -1
	elseif self.anim == 0 then
		self.leap = 1
	end

	self.anim = self.anim + self.leap

	if self.inchild > -1 then
		tmp = self.subs[self.inchild]:update(v, self.subs[self.inchild]:getcode())
		if tmp == 1 then
			self.inchild = -1
		end
		return tmp
	else
		for i = 0, self.nb - 1 do
			if self.posy + self.pad * i < y and self.posy + self.pad * (i + 1) > y then
				self.current = i
			end
		end
		if click and self.posy + self.pad * self.current < y and self.posy + self.pad * (self.current + 1) > y then -- Select child with mouse
			if self.subs[self.current]:getnb() > 0 then -- Enter the child
				self.inchild = self.current
			else
				return self.subs[self.current]:getcode()
			end
		end
		if v:isdownonce("down") then
			self.current = (self.current + 1) % self.nb
		elseif v:isdownonce("up") then
			self.current = (self.current - 1) % self.nb
		elseif v:isdownonce("select") then -- Select child with space
			if self.subs[self.current]:getnb() > 0 then -- Enter the child
				self.inchild = self.current
			else
				return self.subs[self.current]:getcode()
			end
		end
		if not (self.previous == self.current) then
			self.anim = 0
		end
		return old
	end
end

function Treemenu:draw()
	if self.inchild > -1 then
		self.subs[self.inchild]:draw()
    else
		for i = 0, self.nb - 1 do
			love.graphics.setColor(255, 255, 255)
			if i == self.current then
				love.graphics.print(self.subs[i]:getname(), self.posx + self.anim / 4, self.posy + self.pad * i)
			else
				love.graphics.print(self.subs[i]:getname(), self.posx, self.posy + self.pad * i)
			end
	    end
	end
end

function Treemenu:getname()
	return self.name
end

function Treemenu:setname(str)
	self.name = str
end

function Treemenu:getnb()
	return self.nb
end

function Treemenu:getcode()
	return self.code
end
