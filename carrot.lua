function carrot() 
	return {
		sprite = love.graphics.newImage("gfx/carrot.png"),
		h = 100,
		w = 45,
		x = math.random(1, 18) * 70,
		y = math.random(1, 15) * 70,

		draw = function(self, t)
			love.graphics.draw(self.sprite, self.x, self.y + math.sin(time * 3) * 15 + 1)
			love.graphics.setColor(199/255, 148/255, 209/200)
		end,

		eaten = function(self, charx, chary, charw, charh)
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
return carrot