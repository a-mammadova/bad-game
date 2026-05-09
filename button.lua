function button(text, func, param, width, height)
	return {
		width = width or 300,
		height = height or 150,
		func = func or function() print("nese function test") end,
		param = param,
		text = text or "cart",
		buttonx = 0,
		buttony = 0,
		textx = 0,
		texty = 0,

		draw = function(self, buttonx, buttony, textx, texty)
			self.buttonx = buttonx or self.buttonx
			self.buttony = buttony or self.buttony

			if textx then
				self.textx = self.buttonx + 25
			else
				self.textx = self.buttonx
			end

			if texty then
				self.texty = 20 + self.buttony
			else
				self.texty = self.buttony
			end

			love.graphics.setColor(0, 0, 0)
			love.graphics.rectangle("fill", self.buttonx - 5, self.buttony - 5,
			 self.width + 10, self.height + 10, 20, 20)

			if self:hovering(mouse_x, mouse_y) then
				love.graphics.setColor(250/255, 50/255, 80/255)
				love.graphics.rectangle("fill", self.buttonx, self.buttony, self.width, self.height, 20, 20)
			else
				love.graphics.setColor(199/255, 49/255, 117/255)
			end
				love.graphics.rectangle("fill", self.buttonx, self.buttony, self.width, self.height, 20, 20)

				love.graphics.setColor(0, 0, 0)
				love.graphics.setFont(font2)
				love.graphics.print(self.text, self.textx, self.texty)
				love.graphics.setColor(0, 0, 0)

		end,

		hovering = function(self, mousex, mousey)
			con1 = mousex >= self.buttonx and mousex <= self.buttonx + self.width
			con2 = mousey >= self.buttony and mousey <= self.buttony + self.height
			return con1 and con2
		end,
		
	}
end
return button