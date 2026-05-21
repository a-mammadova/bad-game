carrot_types = {
	normal = {
		sprite = love.graphics.newImage("gfx/carrot.png"),
		score = 10,
	},
	purple = { -- cyberpunk neon weirdo world + new map, probably city, ruined movements, knockback 10k
		sprite = love.graphics.newImage("gfx/purple-carrot.png"),
		world_shift = true,

	},
	rotten = {
		sprite = love.graphics.newImage("gfx/rotten-carrot.png"),
		score = -10,
		heart = -1,
	},
	black = { -- health increase, darkness falls, enemy blinded
		sprite = love.graphics.newImage("gfx/black-carrot.png"),
		score = 20,
		heart = 3,
	},
	onion = { -- surroundings get blurry idk how i am gonna do that but maybe ill learn with time (hopefully)
		sprite = love.graphics.newImage("gfx/onion.png"),
		score = -2,
	},
}

type_names = {"normal", "purple", "rotten", "black", "onion"}

function carrot(type) 

	type = type or type_names[math.random(#type_names)]

	cirt = carrot_types[type]

	return {

		type = type,
		sprite = cirt.sprite,

		h = 100,
		w = 45,
		x = math.random(20, 40) * 70,
		y = math.random(20, 40) * 70,

		score = cirt.score or 0,
		heart = cirt.heart or 0,
		world_shift = cirt.world_shift or false,


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