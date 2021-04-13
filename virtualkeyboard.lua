class = require "30log"
Virtualkeyboard = class("Virtualkeyboard")

function Virtualkeyboard:init()
	self.vkeyb = {}
	self.bools = {}
	self.desc = {}
	self.posx = 400
	self.posy = 200
end

function Virtualkeyboard:add(action, d)
	self.desc[action] = d
end

function Virtualkeyboard:bind(action, key)
	self.vkeyb[action] = key
	self.bools[action] = true
end

function Virtualkeyboard:isdown(act)
	return love.keyboard.isDown(self.vkeyb[act])
end

function Virtualkeyboard:isdownonce(act)
	if self.bools[act] and love.keyboard.isDown(self.vkeyb[act]) then
		self.bools[act] = false
		return true
	end
end

function Virtualkeyboard:update(dt)
	for k, v in pairs(self.bools) do
		if not v and not love.keyboard.isDown(self.vkeyb[k]) then
			self.bools[k] = true
		end
	end
end
