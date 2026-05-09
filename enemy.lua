
function enemy()
	return {
		sprite = love.graphics.newImage("gfx/red-2.png"),
		level = 1,
		x = math.random(1, 18) * 80,
		y= math.random(1, 15) * 80,
		w = 151,
		h = 100,
		speed = math.random (3, 5) * 40,

		move = function(self, charx, chary)
			
			if charx - self.x > 0 then
				self.x = self.x + self.level/1.4
			elseif charx - self.x < 0 then
				self.x = self.x - self.level/1.4
			end

			if chary - self.y > 0 then
				self.y = self.y + self.level/1.4
			elseif chary - self.y < 0 then
				self.y = self.y - self.level/1.4
			end
		end,

		draw = function(self)
			love.graphics.draw(self.sprite, self.x, self.y)
			love.graphics.setColor(1, 1, 1)
		end,

		hit = function(self, charx, chary, charw, charh)
			if charx + charw - 70 <= self.x or
			 self.x + self.w - 8 <= charx or
			 self.y + self.h - 20 <= chary or
			  chary + charh - 100 <= self.y then
				return false
			else
				return true
			end
		end,
	}
end

return enemy